SSSD 1.13.2
===========

Highlights
----------

- This is primarily a bugfix release, with minor features added to the local overrides feature
- The `sss_override` tool gained new `user-show`, `user-find`, `group-show` and `group-find` commands
- The PAM responder was crashing if PAM_USER was set to an empty string. This bug was fixed
- The `sssd_be` process could crash when looking up groups in setups with IPA-AD trusts that use POSIX attributes but do not replicate them to the Global Catalog
- A socket leak in case SSSD couldn't establish a connection to an LDAP server was fixed
- SSSD's memory cache now behaves better when used by long-running applications such as system daemons and the administrator invalidates the cache
- The SSSDConfig Python API no longer throws an exception when config_file_version is missing
- The InfoPipe D-Bus interface is able to retrieve user groups correctly if the user is a member of non-POSIX groups like ipausers as well
- Lookups by certificate now work correctly in multi-domain environment
- The lookup of POSIX attributes after startup was relaxed to only check attribute presence, not validity. The POSIX check was also made less verbose.
- A bug when looking up a subdomain user by UPN users was fixed

Packaging Changes
-----------------

- The memory cache for initgroups results was previously not packaged. This bug was fixed.
- Python 2/3 packaging in the RPM specfile was improved

Tickets Fixed
-------------


- [\#2176](https://pagure.io/SSSD/sssd/issue/2176) warn if memcache_timeout is greater than entry_cache_timeout
- [\#2493](https://pagure.io/SSSD/sssd/issue/2493) Check chown_debug_file() usage
- [\#2673](https://pagure.io/SSSD/sssd/issue/2673) Consider also disabled domains when link_forest_roots() is called
- [\#2697](https://pagure.io/SSSD/sssd/issue/2697) extend PAM responder unit test
- [\#2706](https://pagure.io/SSSD/sssd/issue/2706) Contribute and DevelTips are duplicate
- [\#2726](https://pagure.io/SSSD/sssd/issue/2726) Long living applicantion can use removed memory cache.
- [\#2730](https://pagure.io/SSSD/sssd/issue/2730) responder_cache_req-tests failed
- [\#2736](https://pagure.io/SSSD/sssd/issue/2736) sss_override: add find and show commands
- [\#2759](https://pagure.io/SSSD/sssd/issue/2759) sbus_codegen_tests leaves a process running
- [\#2779](https://pagure.io/SSSD/sssd/issue/2779) Review and update wiki pages for 1.13.2
- [\#2786](https://pagure.io/SSSD/sssd/issue/2786) Create a wiki page that lists security-sensitive options
- [\#2792](https://pagure.io/SSSD/sssd/issue/2792) SSSD is not closing sockets properly
- [\#2800](https://pagure.io/SSSD/sssd/issue/2800) Relax POSIX check
- [\#2802](https://pagure.io/SSSD/sssd/issue/2802) sss_override segfaults when accidentally adding --help flag to some commands
- [\#2804](https://pagure.io/SSSD/sssd/issue/2804) Size limit exceeded too loud during POSIX check
- [\#2807](https://pagure.io/SSSD/sssd/issue/2807) CI: configure script failed on CentOS {6,7}
- [\#2810](https://pagure.io/SSSD/sssd/issue/2810) sssd_be crashed
- [\#2811](https://pagure.io/SSSD/sssd/issue/2811) PAM responder crashed if user was not set
- [\#2814](https://pagure.io/SSSD/sssd/issue/2814) avoid symlinks witih python modules
- [\#2819](https://pagure.io/SSSD/sssd/issue/2819) CI: test_ipa_subdomains_server failed on rhel6 + --coverage (FAIL: test_ipa_subdom_server)
- [\#2826](https://pagure.io/SSSD/sssd/issue/2826) sss_override: memory violation
- [\#2827](https://pagure.io/SSSD/sssd/issue/2827) bug in UPN lookups for subdomain users
- [\#2833](https://pagure.io/SSSD/sssd/issue/2833) local overrides: don't contact server with overriden name/id
- [\#2837](https://pagure.io/SSSD/sssd/issue/2837) REGRESSION: ipa-client-automout failed
- [\#2861](https://pagure.io/SSSD/sssd/issue/2861) sssd crashes if non-UTF-8 locale is used
- [\#2863](https://pagure.io/SSSD/sssd/issue/2863) IFP: ifp_users_user_get_groups doesn't handle non-POSIX groups

Detailed Changelog
------------------

Dan Lavu (1):

- sss_override: Add restart requirements to man page

Jakub Hrozek (10):

- Bump the version for the 1.13.2 development
- AD: Provide common connection list construction functions
- AD: Consolidate connection list construction on ad_common.c
- tests: Fix compilation warning
- tools: Don't shadow 'exit'
- IFP: Skip non-POSIX groups properly
- DP: Drop dp_pam_err_to_string
- DP: Check callback messages for valid UTF-8
- sbus: Check string arguments for valid UTF-8 strings
- Updating translations for the 1.13.2 release

Lukas Slebodnik (33):

- CI: Fix configure script arguments for CentOS
- CI: Don't depend on user input with apt-get
- CI: Add missing dependency for debian
- CI: Run integration tests on debian testing
- BUILD: Link just libsss_crypto with crypto libraries
- BUILD: Link crypto_tests with existing library
- BUILD: Remove unused variable TEST_MOCK_OBJ
- BUILD: Avoid symlinks with python modules
- SSSDConfigTest: Try load saved config
- SSSDConfigTest: Test real config without config_file_version
- intg_tests: Fix PEP8 warnings
- BUILD: Accept krb5 1.14 for building the PAC plugin
- BUILD: Fix detection of pthread with strict CFLAGS
- BUILD: Fix doc directory for sss_simpleifp
- LDAP: Fix leak of file descriptors
- CI: Workaroung for code coverage with old gcc
- cache_req: Fix warning -Wshadow
- SBUS: Fix warnings -Wshadow
- TESTS: Fix warnings -Wshadow
- INIT: Drop syslog.target from service file
- sbus_codegen_tests: Suppress warning Wmaybe-uninitialized
- DP_PTASK: Fix warning may be used uninitialized
- UTIL: Fix memory leak in switch_creds
- TESTS: Initialize leak check
- TESTS: Check return value of check_leaks_pop
- TESTS: Make check_leaks static function
- TESTS: Add warning for unused result of leak check functions
- sss_client: Fix underflow of active_threads
- sssd_client: Do not use removed memory cache
- test_memory_cache: Test removing mc without invalidation
- Revert "intg: Invalidate memory cache before removing files"
- CONFIGURE: Bump AM_GNU_GETTEXT_VERSION
- test_sysdb_subdomains: Do not use assignment in assertions

Michal Židek (7):

- SSSDConfig: Do not raise exception if config_file_version is missing
- spec: Missing initgroups mmap file
- util: Update get_next_domain's interface
- tests: Add get_next_domain_flags test
- sysdb: Include disabled domains in link_forest_roots
- sysdb: Use get_next_domain instead of dom-&gt;next
- Refactor some conditions

Nikolai Kondrashov (13):

- CI: Update reason blocking move to DNF
- CI: Exclude whitespace_test from Valgrind checks
- intg: Get base DN from LDAP connection object
- intg: Add support for specifying all user attrs
- intg: Split LDAP test fixtures for flexibility
- intg: Reduce sssd.conf duplication in test_ldap.py
- intg: Fix RFC2307bis group member creation
- intg: Do not use non-existent pre-increment
- CI: Do not skip tests not checked with Valgrind
- CI: Handle dashes in valgrind-condense
- intg: Fix all PEP8 issues
- CI: Enforce coverage make check failures
- intg: Add more LDAP tests

Pavel Březina (23):

- sss tools: improve option handling
- sbus codegen tests: free ctx
- cache_req: provide extra flag for oob request
- cache_req: add support for UPN
- cache_req tests: reduce code duplication
- cache_req: remove raw_name and do not touch orig_name
- sss_override: fix comment describing format
- sss_override: explicitly set ret = EOK
- sss_override: steal msgs string to objs
- nss: send original name and id with local views if possible
- sudo: search with view even if user is found
- sudo: send original name and id with local views if possible
- sss_tools: always show common and help options
- sss_override: fix exporting multiple domains
- sss_override: add user-find
- sss_override: add group-find
- sss_override: add user-show
- sss_override: add group-show
- sss_override: do not free ldb_dn in get_object_dn()
- sss_override: use more generic help text
- sss_tools: do not allow unexpected free argument
- BE: Add IFP to known clients
- AD: remove annoying debug message

Pavel Reichl (12):

- AD: add debug messages for netlogon get info
- confdb: warn if memcache_timeout &gt; than entry_cache
- SDAP: Relax POSIX check
- SDAP: optional warning - sizelimit exceeded in POSIX check
- SDAP: allow_paging in sdap_get_generic_ext_send()
- SDAP: change type of attrsonly in sdap_get_generic_ext_state
- SDAP: pass params in sdap_get_and_parse_generic_send
- sss_override: amend man page - overrides do not stack
- sss_override: Removed overrides might be in memcache
- pam-srv-tests: split pam_test_setup() so it can be reused
- pam-srv-tests: Add UT for cached 'online' auth.
- intg: Add test for user and group local overrides

Petr Cech (9):

- DEBUG: Preventing chown_debug_file if journald on
- TEST: Add test_user_by_recent_filter_valid
- TEST: Refactor of test_responder_cache_req.c
- TEST: Refactor of test_responder_cache_req.c
- TEST: Add common function are_values_in_array()
- TEST: Add test_users_by_recent_filter_valid
- TEST: Add test_group_by_recent_filter_valid
- TEST: Refactor of test_responder_cache_req.c
- TEST: Add test_groups_by_recent_filter_valid

Stephen Gallagher (2):

- LDAP: Inform about small range size
- Monitor: Show service pings at debug level 8

Sumit Bose (5):

- PAM: only allow missing user name for certificate authentication
- fix ldb_search usage
- fix upn cache_req for sub-domain users
- nss: fix UPN lookups for sub-domain users
- cache_req: check all domains for lookups by certificate
