SSSD 1.16.0
===========

Highlights
----------

### Security fixes

- This release fixes CVE-2017-12173: Unsanitized input when searching in local cache database. SSSD stores its cached data in an LDAP like local database file using `libldb.` To lookup cached data LDAP search filters like `(objectClass=user)(name=user_name)` are used. However, in `sysdb_search_user_by_upn_res()`, the input was not sanitized and allowed to manipulate the search filter for cache lookups. This would allow a logged in user to discover the password hash of a different user.

### New Features

- SSSD now supports session recording configuration through `tlog`. This feature enables recording of everything specific users see or type during their sessions on a text terminal. For more information, see the `sssd-session-recording(5)` manual page.
- SSSD can act as a client agent to deliver [Fleet Commander](https://wiki.gnome.org/Projects/FleetCommander) policies defined on an IPA server. Fleet Commander provides a configuration management interface that is controlled centrally and that covers desktop, applications and network configuration.
- Several new [systemtap](https://sourceware.org/systemtap/) probes were added into various locations in SSSD code to assist in troubleshooting and analyzing performance related issues. Please see the `sssd-systemtap(5)` manual page for more information.
- A new LDAP provide access control mechanism that allows to restrict access based on PAM's rhost data field was added. For more details, please consult the `sssd-ldap(5)` manual page, in particular the options `ldap_user_authorized_rhost` and the `rhost` value of `ldap_access_filter`.

### Performance enhancements

- Several attributes in the SSSD cache that are quite often used during cache searches were not indexed. This release adds the missing indices, which improves SSSD performance in large environments.

### Notable bug fixes

- The SSSD libwbclient implementation adjusted its behaviour in order to be compatible with Winbind's return value of wbcAuthenticateUserEx(). This enables the SSSD libwbclient library to work with Samba-4.6 or newer.
- SSSD's plugin for MIT Kerberos to send the PAC to the PAC responder did not protect the communication with the PAC responder with a mutex. This was causing multi-threaded applications that process the Kerberos PAC to miss a reply from SSSD and then were blocked until the default client timeout of 300 seconds passed. This release adds the mutex, which fixes the PAC responder usage in multi-threaded environments.
- Previously, SSSD used to refresh several expired sudo rules by combining them into a long LDAP filter. This was ineffective, because the LDAP server had to process the query, but at that point, the client was quite often querying most or all of the sudo rules anyway. In this version, when the number of sudo rules to be refreshed exceeds the value of a new option `sudo_threshold`, all sudo rules are fetched instead.
- A bug in the sudo integration that prevented the rules from matching if the user name referenced in that rule was overriden with `sss_override` or IPA ID views was fixed
- When SSSD is configured with `id_provider=ad`, then a Kerberos configuration is created that instructs libkrb5 to use TCP for communication with the AD DC by default. This would save switching from UDP to TCP, which happens almost every time with the `ad` provider due to the PAC attached to the Kerberos ticket.

Packaging Changes
-----------------

- The `sss_debuglevel` and `sss_cache` utilities were superseded by `sssctl` commands `sssctl debug-level` and `sssctl cache-expire`, respectively. While this change is backwards-compatible in the sense that the old commands continue to work, it is recommended to switch to the `sssctl` command which will in future encompass all SSSD administration tasks.
- Two new manpages, `sssd-session-recording(5)` and `sssd-systemtap(5)` were added.
- A new systemtap example script, which is packaged by default at `/usr/share/sssd/systemtap/dp_request.stp` was added.
- A new directory called `deskprofile` under the SSSD state directory (typically `/var/lib/sss/`) was added. SSSD downloads the Fleet Commander profiles into this directory.

Documentation Changes
---------------------

- The `ldap_user_certificate` option has changed its default value in the LDAP provider from "not set" to `userCertificate;binary`.
- The `ldap_access_filter` option has a new allowed value `rhost` to support access control based on the PAM rhost value. The attribute that SSSD reads during the rhost access control can be configured using the new option `ldap_user_authorized_rhost`.
- The thresholds after which the IPA and LDAP sudo providers will refresh all sudo rules instead of only the expired ones can be tuned using the `sudo_threshold` option.
- A new provider handler, `session_provider` was added. At the moment, only two handlers, `ipa` and `none` are supported. The IPA session handler is used to fetch the Fleet Commander profiles from an IPA server.
- The interval after which the IPA session provider will check for new FleetCommander profiles can be configured using the new `ipa_deskprofile_request_interval` option.

Tickets Fixed
-------------

- [\#3549](https://pagure.io/SSSD/sssd/issue/3549) - CVE-2017-12173: Unsanitized input when searching in local cache database
- [\#3531](https://pagure.io/SSSD/sssd/issue/3531) - dbus-1.11.18 caused hangs in cwrap integration tests
- [\#3518](https://pagure.io/SSSD/sssd/issue/3518) - sssd_client: add mutex protected call to the PAC responder
- [\#3511](https://pagure.io/SSSD/sssd/issue/3511) - sssd incorrectly checks 'try_inotify' thinking it is the wrong section
- [\#3508](https://pagure.io/SSSD/sssd/issue/3508) - Issues with certificate mapping rules
- [\#3501](https://pagure.io/SSSD/sssd/issue/3501) - Accessing IdM kerberos ticket fails while id mapping is applied
- [\#3491](https://pagure.io/SSSD/sssd/issue/3491) - pysss_nss_idmap: py3 constants defined as strings or bytes
- [\#3485](https://pagure.io/SSSD/sssd/issue/3485) - getsidbyid does not work with 1.15.3
- [\#3481](https://pagure.io/SSSD/sssd/issue/3481) - ERROR at setup of test_kcm_sec_init_list_destroy
- [\#3459](https://pagure.io/SSSD/sssd/issue/3459) - Allow fallback from krb5_aname_to_localname to other krb5 plugins
- [\#3461](https://pagure.io/SSSD/sssd/issue/3461) - unable to access cifs share using sssd-libwbclient
- [\#3488](https://pagure.io/SSSD/sssd/issue/3488) - SUDO doesn't work for IPA users on IPA clients after applying ID Views for them in IPA server
- [\#3478](https://pagure.io/SSSD/sssd/issue/3478) - sudo: fall back to the full refresh after reaching a certain threshold
- [\#3473](https://pagure.io/SSSD/sssd/issue/3473) - Failures on test_idle_timeout()
- [\#3472](https://pagure.io/SSSD/sssd/issue/3472) - sysdb index improvements - missing ghost attribute indexing, unneeded objectclass index etc..
- [\#3363](https://pagure.io/SSSD/sssd/issue/3363) - secrets: Per UID secrets quota
- [\#3507](https://pagure.io/SSSD/sssd/issue/3507) - Long search filters are created during IPA sudo command + command group retrieval
- [\#3499](https://pagure.io/SSSD/sssd/issue/3499) - Change the ldap_user_certificate to userCertificate;binary for the generic LDAP provider as well
- [\#3482](https://pagure.io/SSSD/sssd/issue/3482) - Fleet Commander: Add a timeout to avoid contacting the DP too often in case there was no profile fetched in the last login
- [\#3460](https://pagure.io/SSSD/sssd/issue/3460) - id root triggers an LDAP lookup
- [\#3315](https://pagure.io/SSSD/sssd/issue/3315) - infopipe: org.freedesktop.sssd.infopipe.Groups.Group doesn't show users
- [\#3308](https://pagure.io/SSSD/sssd/issue/3308) - SELinux: Use libselinux's getseuserbyname to get the correct seuser
- [\#3307](https://pagure.io/SSSD/sssd/issue/3307) - RFE: Log to syslog when sssd cannot contact servers, goes offline
- [\#3306](https://pagure.io/SSSD/sssd/issue/3306) - infopipe: List\* with limit = 0 returns 0 results
- [\#3305](https://pagure.io/SSSD/sssd/issue/3305) - infopipe: crash when filter doesn't contain '\*'
- [\#3254](https://pagure.io/SSSD/sssd/issue/3254) - Set udp_preference_limit=0 by sssd-ad using a krb5 snippet
- [\#2995](https://pagure.io/SSSD/sssd/issue/2995) - RFE: Deliver FleetCommander URL endpoint from an IPA server
- [\#2893](https://pagure.io/SSSD/sssd/issue/2893) - [RFE] Conditionally wrap user terminal with tlog
- [\#3513](https://pagure.io/SSSD/sssd/issue/3513) - MAN: Document that full_name_format must be set if the output of trusted domains user resolution should be shortnames only
- [\#3450](https://pagure.io/SSSD/sssd/issue/3450) - Unnecessary second log event causing much spam to syslog
- [\#3417](https://pagure.io/SSSD/sssd/issue/3417) - MAN: document that attribute 'provider' is not allowed in section 'secrets'
- [\#3399](https://pagure.io/SSSD/sssd/issue/3399) - Improve description of 'trusted domain section' in sssd.conf's man page
- [\#3061](https://pagure.io/SSSD/sssd/issue/3061) - Add systemtap probes into the top-level data provider requests
- [\#2809](https://pagure.io/SSSD/sssd/issue/2809) - CI doesn't work with DNF
- [\#2301](https://pagure.io/SSSD/sssd/issue/2301) - Print a warning when enumeration is requrested but disabled
- [\#1898](https://pagure.io/SSSD/sssd/issue/1898) - Move header files consumed by both server and client to special folder
- [\#3517](https://pagure.io/SSSD/sssd/issue/3517) - Prevent "TypeError: must be type, not classobj"
- [\#3147](https://pagure.io/SSSD/sssd/issue/3147) - sssctl: get and set debug level
- [\#3057](https://pagure.io/SSSD/sssd/issue/3057) - Merge existing command line tools into sssctl

Detailed Changelog
------------------

- Alexey Kamenskiy (1):

  - LDAP: Add support for rhost access control

- AmitKumar (6):

  - Moving headers used by both server and client to special folder
  - ldap_child: Removing duplicate log message
  - MAN: Improve description of 'trusted domain section' in sssd.conf's man page
  - MAN: Improve ipa_hostname description
  - IPA: check if IPA hostname is fully qualified
  - Print a warning when enumeration is requested but disabled

- Fabiano Fidêncio (57):

  - CACHE_REQ: Fix warning may be used uninitialized
  - INTG: Add --with-session-recording=/bin/false to intgcheck's configure
  - IFP: Change ifp_list_ctx_remaining_capacity() return type
  - IFP: Don't pre-allocate the amount of entries requested
  - IPA_ACCESS: Remove not used attribute
  - IPA: Make ipa_hbac_sysdb_save() more generic
  - IPA: Leave only HBAC specific defines in ipa_hbac_private.h
  - IPA_ACCESS: Make hbac_get_cache_rules() more generic
  - IPA_ACCESS: Make ipa_purge_hbac() more generic
  - IPA_RULES_COMMON: Introduce ipa_common_save_rules()
  - IPA_RULES_COMMON: Introduce ipa_common_get_hostgroupname()
  - IPA_ACCESS: Make use of struct ipa_common_entries
  - IPA_COMMON: Introduce ipa_get_host_attrs()
  - UTIL: move {files,selinux}.c under util directory
  - UTIL: Add sss_create_dir()
  - DESKPROFILE: Introduce the new IPA session provider
  - HBAC: Fix tevent hierarchy in ipa_hbac_rule_info_send()
  - HBAC: Document ipa_hbac_rule_info_next()'s behaviour
  - HBAC: Remove a cosmetic extra space from an if clause
  - HBAC: Improve readability of ipa_hbac_rule_info_send()
  - HBAC: Enforce coding style on ipa_hbac_rule_info_send()
  - HBAC: Enforce coding style ipa_hbac_rule_info_recv()
  - HBAC: Add a debug message in case ipa_hbac_rule_info_next() fails
  - HBAC: Not having rules should not be logged as error
  - DESKPROFILE: Add ipa_deskprofile_request_interval
  - NEGCACHE: Add some comments about each step of sss_ncache_prepopulate()
  - NEGCACHE: Always add "root" to the negative cache
  - TEST_NEGCACHE: Test that "root" is always added to ncache
  - NEGCACHE: Descend to all subdomains when adding user/groups
  - CACHE_REQ: Don't error out when searching by id = 0
  - NSS: Don't error out when deleting an entry which has id = 0 from the memcache
  - NEGCACHE: Add root's UID/GID to ncache
  - TEST_NEGCACHE: Ensure root's UID and GID are always added to ncache
  - CONFDB: Set a default value for subdomain_refresh_interval in case an invalid value is set
  - SDAP: Add a debug message to explain why a backend was marked offline
  - SDAP: Don't call be_mark_offline() because sdap_id_conn_data_set_expire_timer() failed
  - PYTHON: Define constants as bytes instead of strings
  - SYSDB: Add sysdb_search_by_orig_dn()
  - TESTS: Add tests for `sysdb_search()`{users,groups}_by_orig_dn()
  - IPA: Use `sysdb_search*()`_by_orig_dn() _hbac_users.c
  - SDAP: Use `sysdb_search*()`_by_orig_dn() in sdap_async_nested_groups.c
  - SDAP: Use `sysdb_search*()`_by_orig_dn() in sdap_async_groups.c
  - IPA: Use `sysdb_search*()`_by_orig_dn() in _subdomains_ext_group.c
  - MAN: Add a note about the output of all commands when using domain_resolution_order
  - RESOLV: Fix "-Werror=null-dereference" caught by GCC
  - SIFP: Fix "-Wjump-misses-init" caught by GCC
  - NSS: Fix "-Wold-style-definition" caught by GCC
  - TESTS: Fix "-Werror=null-dereference" caught by GCC
  - TOOLS: Fix "-Wstack-protector" caught by GCC
  - SSSCTL: Fix "-Wshadow" warning caught by GCC
  - SSSCTL: Fix "-Wunitialized" caught by GCC
  - SSSCTL: Use get prefix for the sssctl_attr_fn functions
  - TESTS: Fix "-Wshadow" caught by GCC
  - RESPONDER: Fix "-Wold-style-definition" caught by GCC
  - PAM: Avoid overwriting pam_status in _lookup_by_cert_done()
  - DP: Fix the output type used in dp_req_recv_ptr()
  - DP: Log to syslog whether it's online or offline

- Jakub Hrozek (29):

  - Updating the version for the 1.15.4 release
  - MAN: Don't tell the user to autostart sssd-kcm.service; it's socket-enabled
  - TESTS: Add wrappers to request a user or a group by ID
  - TESTS: Add files provider tests that request a user and group by ID
  - TESTS: Add regression tests to try if resolving root and ID 0 fails as expected
  - CONFDB: Do not crash with an invalid domain_type or case_sensitive value
  - IPA: Only attempt migration for the joined domain
  - SECRETS: Remove unused declarations
  - SECRETS: Do not link with c-ares
  - SECRETS: Store quotas in a per-hive configuration structure
  - SECRETS: Read the quotas for cn=secrets from [secrets/secrets] configuration subsection
  - SECRETS: Rename local_db_req.basedn to local_db_req.req_dn
  - SECRETS: Use separate quotas for /kcm and /secrets hives
  - TESTS: Test that ccaches can be stored after max_secrets is reached for regular non-ccache secrets
  - SECRETS: Add a new option to control per-UID limits
  - SECRETS: Support 0 as unlimited for the quotas
  - TESTS: Relax the assert in test_idle_timeout
  - IPA: Reword the DEBUG message about SRV resolution on IDM masters
  - IPA: Only generate kdcinfo files on clients
  - MAN: Improve failover documentation by explaining the timeout better
  - MAN: Document that the secrets provider can only be specified in a per-client section
  - TESTS: Use NULL for pointer, not 0
  - SUDO: Use initgr_with_views when looking up a sudo user
  - KCM: Do not leak newly created ccache in case the name is malformed
  - KCM: Use the right memory context
  - KCM: Add some forgotten NULL checks
  - GPO: Don't use freed LDAPURLDesc if domain for AD DC cannot be found
  - Updating the translation for the 1.16.0 release
  - Updating the version for the 1.16.0 release

- Justin Stephenson (8):

  - SELINUX: Use getseuserbyname to get IPA seuser
  - DP: Add Generic DP Request Probes
  - CONTRIB: Add DP Request analysis script
  - MAN: Add sssd-systemtap man page
  - SSSCTL: Move sss_debuglevel to sssctl debug-level
  - SSSCTL: Replace sss_debuglevel with shell wrapper
  - SSSCTL: Add cache-expire command
  - IPA: Add threshold for sudo searches

- Lukas Slebodnik (31):

  - SPEC: Use language file for sssd-kcm
  - SHARED: Return warning back about minimal header files
  - intg: Disable add_remove tests
  - SPEC: require http-parser only on rhel7.4
  - intg: Increase startup timeouts for kcm and secrets
  - libwbclient: Change return code for wbcAuthenticateUserEx
  - libwbclient: Fix warning statement with no effect
  - SPEC: rhel8 will have python3 as well
  - SPEC: Fix unowned directory
  - certmap: Suppress warning Wmissing-braces
  - cache_req: Look for name attribute also in nss_cmd_getsidbyid
  - SPEC: Update owner and mode for /var/lib/sss/deskprofile
  - CI: Use dnf 2.0 for installation of packages in fedora
  - Revert "PYTHON: Define constants as bytes instead of strings"
  - pysss_nss_idmap: return same type as it is in module constants
  - pysss_nss_idmap: Fix typos in python documentation
  - CONFIG: Fix schema for try_inotify
  - SPEC: Fix detecting of minor release
  - Fix warning declaration of 'index' shadows a global declaration
  - intg: Fix execution with dbus-1.11.18
  - TOOLS: Log redirection info for sss_debuglevel to stderr
  - TOOLS: Print Better usage for sssctl debug-level
  - TOOLS: Hide option --debug in sssctl
  - intg: Fix pep8 warnings in config.py template
  - intg: Let python paths be configurable
  - intg: prevent "TypeError: must be type, not classobj"
  - intg: Prefer locally built python modules
  - ds_openldap: Extract functionality to protected methods
  - intg: Create FakeAD class based on openldap
  - intg: Add sanity tests for pysss_nss_idmap
  - Revert "IPA: Only generate kdcinfo files on clients"

- Marlena Marlenowska (1):

  - IDMAP: Prevent colision for explicitly defined slice.

- Nikolai Kondrashov (16):

  - CACHE_REQ: Propagate num_results to cache_req_state
  - NSS: Move shell options to common responder
  - NSS: Move nss_get_shell_override to responder utils
  - CONFIG: Add session_recording section
  - BUILD: Support configuring session recording shell
  - UTIL: Add session recording conf management module
  - RESPONDER: Add session recording conf loading
  - DP: Add session recording conf loading
  - SYSDB: Add sessionRecording attribute macro
  - DP: Load override_space into be_ctx
  - DP: Overlay sessionRecording attribute on initgr
  - CACHE_REQ: Pull sessionRecording attrs from initgr
  - NSS: Substitute session recording shell
  - PAM: Export original shell to tlog-rec-session
  - INTG: Add session recording tests
  - MAN: Describe session recording configuration

Pavel Březina (4):

- DP: Update viewname for all providers
- sudo: add a threshold option to reduce size of rules refresh filter
- IFP: fix typo in option name in man pages
- IFP: parse ping arguments in codegen

Petr Čech (4):

- IFP: Do not fail when a GHOST group is not found
- UTIL: Set udp_preference_limit=0 in krb5 snippet
- IFP: Filter with \* in infopipe group methods
- IFP: Fix of limit = 0 (unlimited result)

Sumit Bose (15):

- libwbclient-sssd: update interface to version 0.14
- localauth plugin: change return code of sss_an2ln
- tests: add unit tests for krb5 localauth plugin
- IPA: format fixes
- certmap: add OpenSSL implementation
- ipa: make sure view name is initialized at startup
- certmap: make sure eku_oid_list is always allocated
- IPA: fix handling of certmap_ctx
- sysdb: add missing indices
- IDMAP: add a unit test
- sssd_client: add mutex protected call to the PAC responder
- BUILD: Accept krb5 1.16 for building the PAC plugin
- sysdb: sanitize search filter input
- IPA: sanitize name in override search filter
- sss_client: refactor internal timeout handling

Yuri Chornoivan (3):

- Fix minor typos
- Fix minor typos
- Fix minor typos in docs

amitkuma (2):

- ldap: Change ldap_user_certificate to userCertificate;binary
- python: Changing class declaration from old to new-style type
