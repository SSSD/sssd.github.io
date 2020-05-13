# Running and developing SSSD tests

SSSD is a complex piece of software with a long development history. Therefore, there are several layers of tests with different goals and using different frameworks. This page shows how to run the tests and how to add new ones or modify the existing tests.

## Existing test tiers

Each test is different. Sometimes, you want to test the whole system end-to-end, sometimes the test should exercise some corner case for which special input and environment must be simulated. This section should give you a better idea what kind of tests already exist in SSSD so that you can choose where to add a new test and also provides a general overview.

### Unit tests

Unit tests typically run a function or a tevent request without running the full deamon. The unit tests in SSSD are developed using either the [check](https://libcheck.github.io/check/) library or the [cmocka](https://cmocka.org) library.

It might sound strange that two different C unit testing libraries are used. The reason is mostly historical - when SSSD was started, the check library was the best choice, but it had become unmaintained for some time. While check has seen some development happening since then, the SSSD team had moved to using cmocka in the meantime. In addition, cmocka has support for mocking values using the `mock` and `will_return` functions. Therefore, cmocka should be used for any new unit tests added to SSSD.

The unit tests are fast to execute and in general this is where corner cases are typically easiest to test as you can provide false or unexpected input to the code under test. Unit tests are also often used to test a library's API.

An important part of many tests using cmocka is wrapping a function provided by an external library using the `ld` linker's `--wrap` feature. You can learn more about cmocka and this feature in a [lwn.net article the cmocka developers contributed](https://lwn.net/Articles/558106/). In the SSSD source tree, the unit tests reside under `src/tests/*.c` (check-based tests) and `src/tests/cmocka/*.c`.

To run the tests, make sure both the cmocka and check libraries are installed on your system. On Fedora/RHEL, the package names are `libcmocka-devel` and `check-devel`. Running `make check` from your build directory will then execute all the unit tests.

#### Testing for talloc context memory growth

Talloc can be a double-edged sword sometimes. On the one hand, talloc greatly simplifies memory management, on the other hand, using talloc creates a risk that a memory related to some operation is allocated using a top-level memory context and outlives the lifetime of the related request. To make sure we catch errors like this, our tests contain several useful functions that record the amount of memory a talloc context takes before an operation begins and compares that amount of memory after the operation finishes. The functions to set up and tear down the memory leak detection are called `leak_check_setup` and `leak_check_teardown.` For every operation, you'll want to record the amount of memory taken before the operation with `check_leaks_push` and then check the amount of memory taken after the operation with `check_leaks_pop`.

#### Examples of what can be tested by unit tests

A typical use-case is the sysdb API tests at e.g. `src/tests/sysdb-tests.c`.

A less typical use-case is testing of the NSS or PAM responders in isolation. The NSS responder test is located at `src/tests/cmocka/test_nss_srv.c`. Normally, the NSS responder would require a client such as getent to talk to it through the nss_sss module and would send requests to and receive replies from a back end. In unit tests, the NSS client's input is simulatd by calling the `sss_cmd_execute` directly, but with mocked input (see e.g. `mock_input_user_or_group`. The test even fakes communication to the Data Provider by mocking the `sss_dp_get_account_send` and `sss_dp_get_account_recv` request that normally talks to the Data Provider over D-Bus (see e.g. the `test_nss_getpwnam_search` test).

### Integration tests

SSSD integration tests run the deamon at the same machine you are developing on with the help from the cwrap https://cwrap.org/libraries. The integration tests are half-way between the unit tests that call APIs or run a single component in isolation and between the multihost tests that run on a dedicated VM. During the integration tests, a build of SSSD is compiled and installed into an environment set up with the help of the `fakeroot` program. Then, the cwrap libraries are preloaded into the test environment. The socket_wrapper library provides networking through UNIX pipes, the uid_wrapper library provides the notion of running as root and the nss_wrapper library allows to route requests for users and groups through the NSS module under test.

The advantage over the unit tests is obvious, the full deamon is ran and you can talk to the SSSD using the same interfaces as a user would do in production, e.g. resolve a user with `getpwnam`. Because the tests are ran on the same machine as the developer works on, is is much faster to compile a new SSSD version for the tests to run and so the develop-test-fix cycle is generally quite fast. The integration tests also offer a simple way to add a "breakpoint" to the tests and connect to the tests using `screen(1)`. Finally, since the tests run on the same machine, they can trivially run on any OS release or any distribution with little to no changes, even in build systems that typically have no network connectivity as part of the SSSD build.

The disadvantages also stem from running the tests on the local machine. SSSD relies on whatever server it is connecting to to also run in the test environment provided by the cwrap libraries, but in many cases that is so difficult that we even haven't done the work (e.g. FreeIPA) or outright impossible (Active Directory). Even within the tests themselves, we sometimes stretch the limits of the cwrap libraries. As an example, the socket_wrapper library doesn't support faking the client credentials that the SSSD reads using the `getsockopt` call with the `SO_PEERCRED` parameter.

#### Running integration tests

The easiest way to run the integration tests is by running: :

    make intgcheck

This makefile target consists of two targets, actually:

    make intgcheck-prepare
    make intgcheck-run

The former builds the special SSSD build and creates the environment for tests. The latter actually runs the tests.

Running the complete suite of tests may be overkill for debugging. Running individual tests from the suite can be done according to the following examples: :

    make intgcheck-prepare
    INTGCHECK_PYTEST_ARGS="-k test_netgroup.py" make intgcheck-run
    INTGCHECK_PYTEST_ARGS="test_netgroup.py -k test_add_empty_netgroup" make intgcheck-run

The `INTGCHECK_PYTEST_ARGS` format can be checked in the [PyTest official documentation](http://doc.pytest.org/en/latest/contents.html).

Sometimes, during test development, you find out that the code needs to be fixed and then you'd like to re-run some tests. To do so, you need to first have the environment prepared by running `intgcheck-prepare`. This needs to be done only once per "debugging session". Then, after you've done the required changes to the SSSD code, navigate into the `intg/bld` subdirectory in your build directory and recompile and re-install the test build:

    cd intg/bld
    make
    make -j1 install # Sometimes parallel installation causes issues

Now, re-running make intgcheck-run (optionally with any parameters, like only a subset of tests) would run your modified code\!

#### Debugging integration tests

There are three basic ways to debug the integration tests - add print statements to the test, read the SSSD logs from the test directory and insert a breakpoint.

Print statements can be useful to know what's going on in the test code itself, but not the SSSD. As a general note, the tests remove the logs after a successful run and also suppress stdout during a successful run, so in order to make use of either print statements or the logs, you might need to fail the test on purpose e.g. by adding:

    assert 1 == 0

The debug logs might be useful to get an insight into the SSSD. Let's pretend we want to debug the test called `test_add_empty_netgroup`. We would add the dummy assert to fail the test first. Then, in the test fixture, we'd locate the function that generates the `sssd.conf` (often the function is called `format_basic_conf` in many tests) and we'd add the `debug_level` parameter:

  --- a/src/tests/intg/test_netgroup.py
    +++ b/src/tests/intg/test_netgroup.py
    @@ -109,6 +109,7 @@ def format_basic_conf(ldap_conn, schema):
            disable_netlink     = true
    
            [nss]
    +       debug_level = 10
    
            [domain/LDAP]
            {schema_conf}

Next, we can run the test, expecting it to fail:

    INTGCHECK_PYTEST_ARGS="-k add_empty_netgroup" make intgcheck-run

In the test output, we locate the test directory which always starts with `/tmp/sssd-intg-*`. This director contains the fake root and we can then do useful things such as read the logs from outside the build environment:

    less /tmp/sssd-intg.1ifu0f6n/var/log/sssd/sssd_nss.log

The final option is to insert a breakpoint into the test and jump into the test environment with `screen(1)`. The breakpoint is inserted by calling the `run_shell()` function from the `util` package. Again, using the `test_add_empty_netgroup` test as an example, we need to first import `run_shell`:

    from util import run_shell

Next, we call `run_shell()` from the test function and invoke `intgcheck-run` again. You will see that the test started, but did not finish with either pass or fail, it seemingly hangs. This is when we can check that there is a screen instance running and connect to it:

    $  screen -ls
    There is a screen on:
            21302.sssd_cwrap_session        (Detached)
    1 Socket in /run/screen/S-jhrozek.
    $  screen -r sssd_cwrap_session

From within the screen session, you can attach `gdb` to the SSSD processes, call `getent` to resolve users or groups `ldbsearch` the cache etc. To finish the debugging session, simply exit all the terminals in the tabs.

#### Examples

The tests themselves are located under `src/tests/intg`. Each file corresponds to one "test area", like testing the LDAP provider or testing the KCM responder.

To see an example of adding test cases to existing tests, see commit `76ce965fc3abfdcf3a4a9518e57545ea060033d6` or for an example of adding a whole new test, including faking the client library (which should also illustrate the limits of the cwrap testing), see commit `5d838e13351d3062346ca449e00845750b9447da` and the two preceding it.

### Multihost tests

SSSD multihost tests are the closest our tests get to running SSSD in the real world. The multihost tests utilize a VM the tests are ran at, so no part of the setup is faked. This is also the test's biggest advantage, as long as you can prepare the test environment, the tests can then be used to test even Active Directory or FreeIPA integration. Also, unlike the cwrap tests or the unit tests, the multihost tests are typically good enough for distribution QE teams, so the multihost tests allow a collaboration between the team that typically just develops SSSD and the team that tests it.

The disadvantage of the tests is that setting up the environment can be complex and the development loop (the time between modifying test, modifying the SSSD sources, deploying them to the test environment and running the tests) is much longer than with the cwrap based tests.

Please note that at the time this page is written, the multihost tests are still work in progress. Running the tests is not as easy as it should be. This page documents the manual steps, but we do acknowledge that the setup should be automated further.

#### Running multihost tests

First, the infrastructure does not yet concern itself with provisioning at all. You need to set up a VM to run the tests on yourself. As an example, we'll be running the tests on a Fedora 28 machine which we will create using the [vagrant](https://www.vagrantup.com) tool. To make things at least a little more palatable, the tests are expected to clean up after themselves, so it's possible to reuse the same provisioned VM for multiple test runs.

You can start with initializing the vagrant environment:

    $ vagrant init fedora/28-cloud-base

Next, assign your test VM some address and host name in the `Vagrantfile`:

    SERVER_HOSTNAME="testmachine.sssd.test"
    SERVER_IP_ADDRESS="192.168.122.101"
    
    config.vm.define "testmachine" do |testmachine|
        testmachine.vm.network "private_network", ip: "#{SERVER_IP_ADDRESS}"
        testmachine.vm.hostname = "#{SERVER_HOSTNAME}"
    end

The multihost tests ssh to the test VM as root and generally expect to know the root password. Start the machine and change the password:

    $ vagrant up
    $ vagrant ssh
    [vagrant@testmachine ~]$ sudo passwd root

I'll be using `Secret123` as the root password in this document.

Next, you need to make sure the host (i.e. your laptop) can resolve the guest. Provided that you use `libvirt` as your VM management, you can just add a line with the VM's host name and IP address to `/etc/hosts` followed by sending the `HUP` signal to the `dnsmasq` daemon:

    $  grep testmachine /etc/hosts
    192.168.122.101 testmachine.sssd.test
    $  sudo pkill -HUP dnsmasq
    $  ping testmachine.sssd.test
    PING testmachine.sssd.test (192.168.122.101) 56(84) bytes of data.
    64 bytes from testmachine.sssd.test (192.168.122.101): icmp_seq=1 ttl=64 time=0.371 ms
    ^C
    $ ssh root@testmachine.sssd.test # Use Secret123

Now that we have the test VM prepared, we can proceed to setting up the tests. For some reason, the tests run in a Python virtual environment and download some packages from PIP instead of relying on distribution packages. This is again something we should change at the very least to make it possible to run the multihost tests easily using a make target.

Nonetheless, let's describe the current state. Make sure the following packages are installed:

    dnf install python3-pip python3-virtualenv

Create the Python virtual environment. The directory name is arbitrary:

    $ virtualenv-3 /tmp/abc
    Using base prefix '/usr'
    New python executable in /tmp/abc/bin/python3
    Not overwriting existing python script /tmp/abc/bin/python (you must use /tmp/abc/bin/python3)
    Installing setuptools, pip, wheel...done.

Activate the virtual environment:

    $ source /tmp/abc/bin/activate
    $ (abc) [root@master-7740 bin]#

You can verify the environment is active by inspecting the `PATH` variable, the `/tmp/abc/bin` directory should be the first one.

Install the `sssd-testlib` into your virtualenv:

    $ pwd
    # You should be at your SSSD checkout now
    $ cd src/tests/python
    $ python setup.py install

Install the required Python packages into the virtual environment:

    $ pip install pytest pytest-multihost paramiko python-ldap PyYAML

We're almost there. The next step is to configure the test by telling the tests where to run. There is a template YAML file at `src/tests/multihost/basic/mhc.yaml`. You can copy the file and add the details of your test machine like this:

    $ cat /tmp/mhc.yaml
    windows_test_dir: '/home/Administrator'
    root_password: 'Secret123'
    domains:
  - name: testmachine.sssd.test
      type: sssd
      hosts:
    - name: testmachine.sssd.test
        external_hostname: testmachine.sssd.test
        role: master

Now we can finally move on to running the test\!. Navigate to the `src/tests/multihost` directory and run:

    py.test  -s -v --multihost-config=/tmp/mhc.yaml

You can also add the `-v` switch to `py.test` to see more debug messages, including the commands that are executed on the test VM.

#### Shortening the development loop

As you may have noticed, the tests run whatever packages the VM can install from its repositories. This is fine for testing of stable distributions or for usage from a CI engine, where the packages can be fetched from e.g. a COPR repository.

But for developers hacking on SSSD, normally what you want is to compile and install SSSD from your git checkout. One example of a workflow might be to use the [Vagrant shared folders](https://www.vagrantup.com/docs/synced-folders/) to share the SSSD sources from the host machine. This allows you to use your favorite editor or IDE on your host machine and just compile and run the SSSD on the test VM.

There are several kinds of shared folders, but I've found that the sshfs shared folder has the best ease of use to performance ratio. Start by installing the `vagrant-sshfs` plugin. On Fedora, it is normally present in the repos.

Then, you can define the folder in your Vagrantfile:

    SSSD_SRC="/home/remote/jhrozek/devel/sssd"
    testmachine.vm.synced_folder "#{SSSD_SRC}", "/sssd", type: "sshfs", sshfs_opts_append: "-o cache=no"

Note the `-o cache=no` option. This causes some extra network traffic, but since the VM is local, this is OK and makes sure that the changes are propagated from the host to the VMs immediately. Then, using this setup, you'll have the SSSD sources mounted at `/sssd` and you can build and install SSSD on the machine using the usual steps.
