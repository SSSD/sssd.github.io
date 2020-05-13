# Contribute

There are many ways you can contribute to the System Security Services Daemon. This page should provide some basic pointers.

SSSD development discussions occur either on the [SSSD development (sssd-devel) mailing list](https://lists.fedorahosted.org/archives/list/sssd-devel@lists.fedorahosted.org/) or on the [\#sssd IRC channel](irc://irc.freenode.net/sssd) on [freenode](http://freenode.net/). Keep in mind that SSSD developers are spread across different time zones, which makes mailing list preferred communication channel if you wish to reach the entire team.

The SSSD originated as a sister-project to [FreeIPA](http://www.freeipa.org), so we share many pieces. Contributing to FreeIPA may also help SSSD and vice versa.

If you want to file a bug or enhancement request, please log in with your Fedora Account System credentials. If you do not have a Fedora Account, you can register for one at <https://admin.fedoraproject.org/accounts/>. There is dedicated page about [bug reporting](https://docs.pagure.org/SSSD.sssd/users/reporting_bugs.html).

## Contribution Policy

All source code committed to the SSSD is assumed to be made available under the GPLv3+ license unless the submitter specifies another license at that time. The upstream SSSD maintainers reserve the right to refuse a submission if the license is deemed incompatible with the goals of the project.

## Source Code Repository

For the SSSD project, we use the [Git](http://www.kernel.org/pub/software/scm/git/docs/gittutorial.html) source control system.

Hosted on [Pagure](https://pagure.io/SSSD/sssd) are the [documentation](https://pagure.io/SSSD/docs), the [issue tracker](https://pagure.io/SSSD/sssd/issues), and the referential repository: :

    https://pagure.io/SSSD/sssd.git

SSSD's repository on Pagure is mirrored to GitHub and maintained as read-only instance: :

    https://github.com/SSSD/sssd

The preferred way for sending patches is to create pull requests either on Pagure or GitHub. You can also e-mail your patch as an attachment to the [sssd-devel](https://docs.pagure.org/SSSD.sssd/developers/contribute.html#contribute) mailing list. A guide for a [GitHub workflow](https://docs.pagure.org/SSSD.sssd/newcomers/getting_started.html#github-workflow) is available. The paragraphs below assume you are using Pagure.

## Tasks for newcomers

We try to mark tickets that don't require too much existing knowledge with the `easyfix` keyword in our issue tracker. We also prepared [a query](https://pagure.io/SSSD/sssd/issues?status=Open&tags=easyfix) that lists the easy fixes. Before starting the work on any of these tickets, it might be a good idea to contact the SSSD developers on the [sssd-devel](https://docs.pagure.org/SSSD.sssd/developers/contribute.html#contribute) mailing list and check if the ticket is still valid or ask for guidance in general.

### Getting the source

To check out the latest SSSD sources, install git on your system (Instructions are for Fedora, you may need to use a platform-specific installation mechanism for other OSes). :

    sudo dnf -y install git

You can find an excellent [tutorial](http://www.kernel.org/pub/software/scm/git/docs/gittutorial.html) for using git.

The first time, you will want to configure git with your name and email address for patch attribution: :

    git config --global user.name "GIVENNAME SURNAME"
    git config --global user.email "username@domain.com"

You can enable syntax highlighting at the console (for git commands such as '`git status`' and '`git diff`') by setting: :

    git config --global color.ui auto

And if you would like to have a graphical tool for resolving merge conflicts, you can install and set up meld: :

    sudo dnf -y install meld
    git config --global merge.tool meld

It can be invoked with :

    git mergetool

Once that's done, you can clone our upstream git repository with :

    git clone https://pagure.io/SSSD/sssd.git

This will create a new subdirectory 'sssd' in the current directory which will contain the current master sources. All development should be done first against the master branch, then backported to one of the stable branches if necessary.

You can also enable the commit template by: :

    git config commit.template .git-commit-template

## Building SSSD

Starting with SSSD 1.10 beta, we now include a set of helper aliases and environment variables in SSSD to simplify building development versions of SSSD on Fedora. To take advantage of them, use the following command: :

    . /path/to/sssd-source/contrib/fedora/bashrc_sssd

To build SSSD from source, follow these steps:

1.  Install necessary tools :
    
        # when using yum
        sudo yum -y install rpm-build yum-utils libldb-devel
        
        # when using dnf
        sudo dnf -y install rpm-build dnf-plugins-core libldb-devel

2.  Create source rpm (run from git root directory) :
    
        contrib/fedora/make_srpm.sh

3.  Install SSSD dependencies :
    
        # when using yum
        sudo yum-builddep rpmbuild/SRPMS/sssd-*.src.rpm
        
        # when using dnf
        sudo dnf builddep rpmbuild/SRPMS/sssd-*.src.rpm

If you plan on working with the SSSD source often, you may want to add the following to your `~/.bashrc` file: :

    if [ -f /path/to/sssd-source/contrib/fedora/bashrc_sssd ]; then
        . /path/to/sssd-source/contrib/fedora/bashrc_sssd
    fi

You can now produce a Debug build of SSSD by running: :

    cd /path/to/sssd-source
    reconfig && chmake

The `reconfig` alias will run `autoreconf -if`, create a parallel build directory named after your CPU architecture (e.g. x86_64) and then run the configure script with the appropriate options for installing on a Fedora system with all experimental features enabled.

The `chmake` alias will then perform the build (with build messages suppressed except on warning or error) as well as build and run tests.

Finally, assuming you have sudo privilege, you can run the `sssinstall` alias to install this debug build onto the build machine. :

    sssinstall && echo build install successful

You can also directly build **rpm packages** for Fedora or CentOS using make target *rpms* or *prerelease-rpms*. The second version will create rpm packages with date and git hash in package release. :

    make rpms
    #snip
    Wrote: /dev/shm/gcc/rpmbuild/RPMS/x86_64/sssd-libwbclient-1.13.90-0.fc23.x86_64.rpm
    Wrote: /dev/shm/gcc/rpmbuild/RPMS/x86_64/sssd-libwbclient-devel-1.13.90-0.fc23.x86_64.rpm
    Wrote: /dev/shm/gcc/rpmbuild/RPMS/x86_64/sssd-debuginfo-1.13.90-0.fc23.x86_64.rpm
    Executing(%clean): /bin/sh -e /var/tmp/rpm-tmp.jeWpr7
    + umask 022
    + cd /dev/shm/gcc/rpmbuild/BUILD
    + cd sssd-1.13.90
    + rm -rf /dev/shm/gcc/rpmbuild/BUILDROOT/sssd-1.13.90-0.fc23.x86_64
    + exit 0

To install SSSD on other distributions, you can run the usual Autotools combo: :

    autoreconf -i -f && \
    ./configure --enable-nsslibdir=/lib64 --enable-pammoddir=/lib64/security && \
    make
    sudo make install

To build and install the code. Please note that by default, the Autotools install prefix is `/usr/local`. Also, if you are building and installing on a 32bit machine, you should use `/lib/` instead of `/lib64` for `nsslibdir` and `pammoddir`. Please note that even if you are installing to `/usr/local`, the NSS and PAM libraries must be installed to system library directories as that's where NSS and PAM would be looking for them.

### COPR Repository

You can download development packages from [COPR](https://copr.fedoraproject.org/coprs/) repo:

  - <https://copr.fedorainfracloud.org/groups/g/sssd/coprs/>

## Sending patch to upstream

### Coding Style

We have adopted the code style and formatting specification used by the FreeIPA project to describe our [Python](http://www.freeipa.org/page/Python_Coding_Style) coding style. For C language we also used [FreeIPA C style](http://www.freeipa.org/page/Coding_Style) but this style is currently outdated and a [new updated C style guide](https://docs.pagure.org/SSSD.sssd/developers/coding_style.html) was written for SSSD.

### Spell-checker

Please, check the spelling before submitting.

Use your favorite spell-checker. Checking with LibreOffice can be done like:

  - open file(s) that contain(s) changes with "LibreOffice Writer"
  - set the document language to "English (USA)" (either Tools -- Language -- For all Text or select whole text with keyboard shortcut Ctrl+A, then click at the bottom in the middle)
  - to start the check press F7 (equals Tools -- Spelling and Grammar ...)
  - press [Ignore Once] for spelling mistakes press [Ignore All] to ignore the known good string until LibreOffice is closed press [Add to Dictionary] to add the word to the known good list
  - fix spelling mistake with editor, not LibreOffice
  - in terminal run fgrep -ri ${BADWORD} or egrep -r 'REGEXP' to double-check and find other instances of problem

### Submitting

Please, read the basic etiquette paragraph of the [GitHub workflow](https://docs.pagure.org/SSSD.sssd/newcomers/getting_started.html#github-workflow) before submitting.

Make your changes and then add any new or modified files to a change-set with the command: :

    git add <path_to_file1<path_to_file2...
    git commit

Before submitting a patch, always make sure it doesn't break [SSSD tests](https://docs.pagure.org/SSSD.sssd/users/reporting_bugs.html#running-integration-tests-locally) and applies to the latest upstream master branch. You will want to rebase to this branch and fix any merge conflicts (in case someone else changed the same code). :

    git remote update
    git rebase -i origin/master

If this rebase has a merge conflict, you will need to resolve the conflict before you continue. If you get stuck or make a mistake, you can use :

    git rebase --abort

This will put you right back where you started.

Patches should be split so that every logical change in the large patchset is contained in its own patch. An example of this is [SSSD Ticket \#2789](https://pagure.io/SSSD/sssd/issue/2789) where one patch makes the `resolv_is_address()` function public with tests and the other adds the function in the SSSD providers.

Once your changes are ready for submission, submit it via a pull request.

If a patch isn't accepted on the first review, you will need to modify it and resubmit it. When this happens, you will want to amend your changes to the existing patch with :

    git add <files>
    git commit --amend

If you need to make changes to earlier patches in your tree, you can use :

    git rebase -i origin/master

and follow the directions in the interactive rebase to modify specific patches.

Then just re-push the patches, the pull request will be refreshed automatically.

### Patch metadata

The description associated with the patch is an important piece of information that allows other developers or users to see what the change was about, what bug did the commit fix or what feature did the commit implement. To structure the information many SSSD developers use the following format:

  - one-line short description
  - blank line
  - ticket or bugzilla URL (if available)
  - blank line
  - One or more paragraphs that describe the change if it can't be described fully in the one-line description

These best practices are loosely based on the [kernel patch submission recommendation](http://www.kernel.org/doc/Documentation/SubmittingPatches).

An example of a patch formatted according to the above guidelines is commit [925a14d50edf0e3b800ce659b10b771ae1cde293](https://pagure.io/SSSD/sssd/c/925a14d50edf0e3b800ce659b10b771ae1cde293/): :

    LDAP: Fix nesting level comparison
    
    Correct an issue with nesting level comparison of option
    ldap_group_nesting_level to ensure that setting nesting level 0
    will avoid parent group of group searches.
    
    Resolves:
    https://pagure.io/SSSD/sssd/issue/3425

### Testing SSSD

There is a dedicated page about <span data-role="doc">tests</span>.

### Localization and Internationalization

Our development policy for the SSSD requires that any code that generates a user-facing message should be wrapped by GNU `gettext` macros so that they can eventually be translated. We use [zanata](http://zanata.org/) for translating.
