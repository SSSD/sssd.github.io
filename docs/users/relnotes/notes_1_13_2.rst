SSSD 1.13.2
===========

Highlights
----------

-  This is primarily a bugfix release, with minor features added to the
   local overrides feature
-  The ``sss_override`` tool gained new ``user-show``, ``user-find``,
   ``group-show`` and ``group-find`` commands
-  The PAM responder was crashing if PAM\_USER was set to an empty
   string. This bug was fixed
-  The ``sssd_be`` process could crash when looking up groups in setups
   with IPA-AD trusts that use POSIX attributes but do not replicate
   them to the Global Catalog
-  A socket leak in case SSSD couldn't establish a connection to an LDAP
   server was fixed
-  SSSD's memory cache now behaves better when used by long-running
   applications such as system daemons and the administrator invalidates
   the cache
-  The SSSDConfig Python API no longer throws an exception when
   config\_file\_version is missing
-  The InfoPipe D-Bus interface is able to retrieve user groups
   correctly if the user is a member of non-POSIX groups like ipausers
   as well
-  Lookups by certificate now work correctly in multi-domain environment
-  The lookup of POSIX attributes after startup was relaxed to only
   check attribute presence, not validity. The POSIX check was also made
   less verbose.
-  A bug when looking up a subdomain user by UPN users was fixed

Packaging Changes
-----------------

-  The memory cache for initgroups results was previously not packaged.
   This bug was fixed.
-  Python 2/3 packaging in the RPM specfile was improved

Tickets Fixed
-------------

.. raw:: html

   <div>

`#2176 <https://pagure.io/SSSD/sssd/issue/2176>`__
    warn if memcache\_timeout is greater than entry\_cache\_timeout
`#2493 <https://pagure.io/SSSD/sssd/issue/2493>`__
    Check chown\_debug\_file() usage
`#2673 <https://pagure.io/SSSD/sssd/issue/2673>`__
    Consider also disabled domains when link\_forest\_roots() is called
`#2697 <https://pagure.io/SSSD/sssd/issue/2697>`__
    extend PAM responder unit test
`#2706 <https://pagure.io/SSSD/sssd/issue/2706>`__
    Contribute and DevelTips are duplicate
`#2726 <https://pagure.io/SSSD/sssd/issue/2726>`__
    Long living applicantion can use removed memory cache.
`#2730 <https://pagure.io/SSSD/sssd/issue/2730>`__
    responder\_cache\_req-tests failed
`#2736 <https://pagure.io/SSSD/sssd/issue/2736>`__
    sss\_override: add find and show commands
`#2759 <https://pagure.io/SSSD/sssd/issue/2759>`__
    sbus\_codegen\_tests leaves a process running
`#2779 <https://pagure.io/SSSD/sssd/issue/2779>`__
    Review and update wiki pages for 1.13.2
`#2786 <https://pagure.io/SSSD/sssd/issue/2786>`__
    Create a wiki page that lists security-sensitive options
`#2792 <https://pagure.io/SSSD/sssd/issue/2792>`__
    SSSD is not closing sockets properly
`#2800 <https://pagure.io/SSSD/sssd/issue/2800>`__
    Relax POSIX check
`#2802 <https://pagure.io/SSSD/sssd/issue/2802>`__
    sss\_override segfaults when accidentally adding --help flag to some
    commands
`#2804 <https://pagure.io/SSSD/sssd/issue/2804>`__
    Size limit exceeded too loud during POSIX check
`#2807 <https://pagure.io/SSSD/sssd/issue/2807>`__
    CI: configure script failed on CentOS {6,7}
`#2810 <https://pagure.io/SSSD/sssd/issue/2810>`__
    sssd\_be crashed
`#2811 <https://pagure.io/SSSD/sssd/issue/2811>`__
    PAM responder crashed if user was not set
`#2814 <https://pagure.io/SSSD/sssd/issue/2814>`__
    avoid symlinks witih python modules
`#2819 <https://pagure.io/SSSD/sssd/issue/2819>`__
    CI: test\_ipa\_subdomains\_server failed on rhel6 + --coverage
    (FAIL: test\_ipa\_subdom\_server)
`#2826 <https://pagure.io/SSSD/sssd/issue/2826>`__
    sss\_override: memory violation
`#2827 <https://pagure.io/SSSD/sssd/issue/2827>`__
    bug in UPN lookups for subdomain users
`#2833 <https://pagure.io/SSSD/sssd/issue/2833>`__
    local overrides: don't contact server with overriden name/id
`#2837 <https://pagure.io/SSSD/sssd/issue/2837>`__
    REGRESSION: ipa-client-automout failed
`#2861 <https://pagure.io/SSSD/sssd/issue/2861>`__
    sssd crashes if non-UTF-8 locale is used
`#2863 <https://pagure.io/SSSD/sssd/issue/2863>`__
    IFP: ifp\_users\_user\_get\_groups doesn't handle non-POSIX groups

.. raw:: html

   </div>

Detailed Changelog
------------------

Dan Lavu (1):

-  sss\_override: Add restart requirements to man page

Jakub Hrozek (10):

-  Bump the version for the 1.13.2 development
-  AD: Provide common connection list construction functions
-  AD: Consolidate connection list construction on ad\_common.c
-  tests: Fix compilation warning
-  tools: Don't shadow 'exit'
-  IFP: Skip non-POSIX groups properly
-  DP: Drop dp\_pam\_err\_to\_string
-  DP: Check callback messages for valid UTF-8
-  sbus: Check string arguments for valid UTF-8 strings
-  Updating translations for the 1.13.2 release

Lukas Slebodnik (33):

-  CI: Fix configure script arguments for CentOS
-  CI: Don't depend on user input with apt-get
-  CI: Add missing dependency for debian
-  CI: Run integration tests on debian testing
-  BUILD: Link just libsss\_crypto with crypto libraries
-  BUILD: Link crypto\_tests with existing library
-  BUILD: Remove unused variable TEST\_MOCK\_OBJ
-  BUILD: Avoid symlinks with python modules
-  SSSDConfigTest: Try load saved config
-  SSSDConfigTest: Test real config without config\_file\_version
-  intg\_tests: Fix PEP8 warnings
-  BUILD: Accept krb5 1.14 for building the PAC plugin
-  BUILD: Fix detection of pthread with strict CFLAGS
-  BUILD: Fix doc directory for sss\_simpleifp
-  LDAP: Fix leak of file descriptors
-  CI: Workaroung for code coverage with old gcc
-  cache\_req: Fix warning -Wshadow
-  SBUS: Fix warnings -Wshadow
-  TESTS: Fix warnings -Wshadow
-  INIT: Drop syslog.target from service file
-  sbus\_codegen\_tests: Suppress warning Wmaybe-uninitialized
-  DP\_PTASK: Fix warning may be used uninitialized
-  UTIL: Fix memory leak in switch\_creds
-  TESTS: Initialize leak check
-  TESTS: Check return value of check\_leaks\_pop
-  TESTS: Make check\_leaks static function
-  TESTS: Add warning for unused result of leak check functions
-  sss\_client: Fix underflow of active\_threads
-  sssd\_client: Do not use removed memory cache
-  test\_memory\_cache: Test removing mc without invalidation
-  Revert "intg: Invalidate memory cache before removing files"
-  CONFIGURE: Bump AM\_GNU\_GETTEXT\_VERSION
-  test\_sysdb\_subdomains: Do not use assignment in assertions

Michal Židek (7):

-  SSSDConfig: Do not raise exception if config\_file\_version is
   missing
-  spec: Missing initgroups mmap file
-  util: Update get\_next\_domain's interface
-  tests: Add get\_next\_domain\_flags test
-  sysdb: Include disabled domains in link\_forest\_roots
-  sysdb: Use get\_next\_domain instead of dom->next
-  Refactor some conditions

Nikolai Kondrashov (13):

-  CI: Update reason blocking move to DNF
-  CI: Exclude whitespace\_test from Valgrind checks
-  intg: Get base DN from LDAP connection object
-  intg: Add support for specifying all user attrs
-  intg: Split LDAP test fixtures for flexibility
-  intg: Reduce sssd.conf duplication in test\_ldap.py
-  intg: Fix RFC2307bis group member creation
-  intg: Do not use non-existent pre-increment
-  CI: Do not skip tests not checked with Valgrind
-  CI: Handle dashes in valgrind-condense
-  intg: Fix all PEP8 issues
-  CI: Enforce coverage make check failures
-  intg: Add more LDAP tests

Pavel Březina (23):

-  sss tools: improve option handling
-  sbus codegen tests: free ctx
-  cache\_req: provide extra flag for oob request
-  cache\_req: add support for UPN
-  cache\_req tests: reduce code duplication
-  cache\_req: remove raw\_name and do not touch orig\_name
-  sss\_override: fix comment describing format
-  sss\_override: explicitly set ret = EOK
-  sss\_override: steal msgs string to objs
-  nss: send original name and id with local views if possible
-  sudo: search with view even if user is found
-  sudo: send original name and id with local views if possible
-  sss\_tools: always show common and help options
-  sss\_override: fix exporting multiple domains
-  sss\_override: add user-find
-  sss\_override: add group-find
-  sss\_override: add user-show
-  sss\_override: add group-show
-  sss\_override: do not free ldb\_dn in get\_object\_dn()
-  sss\_override: use more generic help text
-  sss\_tools: do not allow unexpected free argument
-  BE: Add IFP to known clients
-  AD: remove annoying debug message

Pavel Reichl (12):

-  AD: add debug messages for netlogon get info
-  confdb: warn if memcache\_timeout > than entry\_cache
-  SDAP: Relax POSIX check
-  SDAP: optional warning - sizelimit exceeded in POSIX check
-  SDAP: allow\_paging in sdap\_get\_generic\_ext\_send()
-  SDAP: change type of attrsonly in sdap\_get\_generic\_ext\_state
-  SDAP: pass params in sdap\_get\_and\_parse\_generic\_send
-  sss\_override: amend man page - overrides do not stack
-  sss\_override: Removed overrides might be in memcache
-  pam-srv-tests: split pam\_test\_setup() so it can be reused
-  pam-srv-tests: Add UT for cached 'online' auth.
-  intg: Add test for user and group local overrides

Petr Cech (9):

-  DEBUG: Preventing chown\_debug\_file if journald on
-  TEST: Add test\_user\_by\_recent\_filter\_valid
-  TEST: Refactor of test\_responder\_cache\_req.c
-  TEST: Refactor of test\_responder\_cache\_req.c
-  TEST: Add common function are\_values\_in\_array()
-  TEST: Add test\_users\_by\_recent\_filter\_valid
-  TEST: Add test\_group\_by\_recent\_filter\_valid
-  TEST: Refactor of test\_responder\_cache\_req.c
-  TEST: Add test\_groups\_by\_recent\_filter\_valid

Stephen Gallagher (2):

-  LDAP: Inform about small range size
-  Monitor: Show service pings at debug level 8

Sumit Bose (5):

-  PAM: only allow missing user name for certificate authentication
-  fix ldb\_search usage
-  fix upn cache\_req for sub-domain users
-  nss: fix UPN lookups for sub-domain users
-  cache\_req: check all domains for lookups by certificate
