SSSD 1.13.1
===========

Highlights
----------

- Initial support for Smart Card authentication was added. The feature can be activated with the new `pam_cert_auth` option
- The PAM prompting was enhanced so that when Two-Factor Authentication is used, both factors (password and token) can be entered separately on separate prompts. At the same time, only the long-term password is cached, so offline access would still work using the long term password
- A new command line tool `sss_override` is present in this release. The tools allows to override attributes on the SSSD side. It's helpful in environment where e.g. some hosts need to have a different view of POSIX attributes than others. Please note that the overrides are stored in the cache as well, so removing the cache will also remove the overrides
- New methods were added to the SSSD D-Bus interface. Notably support for looking up a user by certificate and looking up multiple users using a wildcard was added. Please see the interface introspection or the design pages for full details
- Several enhancements to the dynamic DNS update code. Notably, clients that update multiple interfaces work better with this release
- This release supports authenticating againt a KDC proxy
- The fail over code was enhanced so that if a trusted domain is not reachable, only that domain will be marked as inactive but the backed would stay in online mode
- Several fixes to the GPO access control code are present

Packaging Changes
-----------------

- The Smart Card authentication feature requires a helper process `p11_child` that needs to be marked as setgid if SSSD needs to be able to. Please note the `p11_child` requires the NSS crypto library at the moment
- The `sss_override` tool was added along with its own manpage
- The upstream RPM can now build on RHEL/CentOS 6.7

Documentation Changes
---------------------

- The `config_file_version` configuration option now defaults to 2. As an effect, this option doesn't have to be set anymore unless the config file format is changed again by SSSD upstream
- It is now possible to specify a comma-separated list of interfaces in the `dyndns_iface` option
- The InfoPipe responder and the LDAP provider gained a new option `wildcard_lookup` that specifies an upper limit on the number of entries that can be returned with a wildcard lookup
- A new option `dyndns_server` was added. This option allows to attempt a fallback DNS update against a specific DNS server. Please note this option only works as a fallback, the first attempt will always be performed against autodiscovered servers.
- The PAM responder gained a new option `ca_db` that allows the storage of trusted CA certificates to be specified
- The time the `p11_child` is allowed to operate can be specified using a new option `p11_child_timeout`

Tickets Fixed
-------------

- [\#546](https://pagure.io/SSSD/sssd/issue/546) [RFE] Support for smart cards
- [\#1697](https://pagure.io/SSSD/sssd/issue/1697) sssd: incorrect checks on length values during packet decoding
- [\#1926](https://pagure.io/SSSD/sssd/issue/1926) [RFE] Start the dynamic DNS update after the SSSD has been setup for the first time
- [\#1994](https://pagure.io/SSSD/sssd/issue/1994) Complain loudly if backend doesn't start due to missing or invalid keytab
- [\#2275](https://pagure.io/SSSD/sssd/issue/2275) nested netgroups do not work in IPA provider
- [\#2283](https://pagure.io/SSSD/sssd/issue/2283) test dyndns failed.
- [\#2335](https://pagure.io/SSSD/sssd/issue/2335) Investigate using the krb5 responder for driving the PAM conversation with OTPs
- [\#2463](https://pagure.io/SSSD/sssd/issue/2463) Pass error messages via the extdom plugin
- [\#2495](https://pagure.io/SSSD/sssd/issue/2495) [RFE]Allow sssd to add a new option that would specify which server to update DNS with
- [\#2549](https://pagure.io/SSSD/sssd/issue/2549) RFE: Support multiple interfaces with the dyndns_iface option
- [\#2553](https://pagure.io/SSSD/sssd/issue/2553) RFE: Add support for wildcard-based cache updates
- [\#2558](https://pagure.io/SSSD/sssd/issue/2558) Add dualstack and multihomed support
- [\#2561](https://pagure.io/SSSD/sssd/issue/2561) Too much logging
- [\#2579](https://pagure.io/SSSD/sssd/issue/2579) TRACKER: Support one-way trusts for IPA
- [\#2581](https://pagure.io/SSSD/sssd/issue/2581) Re-check memcache after acquiring the lock in the client code
- [\#2584](https://pagure.io/SSSD/sssd/issue/2584) RFE: Support client-side overrides
- [\#2597](https://pagure.io/SSSD/sssd/issue/2597) Add index for 'objectSIDString' and maybe to other cache attributes
- [\#2637](https://pagure.io/SSSD/sssd/issue/2637) RFE: Don't mark the main domain as offline if SSSD can't connect to a subdomain
- [\#2639](https://pagure.io/SSSD/sssd/issue/2639) RFE: Detect re-established trusts in the IPA subdomain code
- [\#2652](https://pagure.io/SSSD/sssd/issue/2652) KDC proxy not working with SSSD krb5_use_kdcinfo enabled
- [\#2676](https://pagure.io/SSSD/sssd/issue/2676) Group members are not turned into ghost entries when the user is purged from the SSSD cache
- [\#2682](https://pagure.io/SSSD/sssd/issue/2682) sudoOrder not honored as expected
- [\#2688](https://pagure.io/SSSD/sssd/issue/2688) Default to config_file_version=2
- [\#2691](https://pagure.io/SSSD/sssd/issue/2691) GPO: PAM system error returned for PAM_ACCT_MGMT and offline mode
- [\#2692](https://pagure.io/SSSD/sssd/issue/2692) GPO: Access denied due to using wrong sam_account_name
- [\#2699](https://pagure.io/SSSD/sssd/issue/2699) SSSDConfig: wrong return type returned on python3
- [\#2700](https://pagure.io/SSSD/sssd/issue/2700) krb5_child should always consider online state to allow use of MS-KKDC proxy
- [\#2708](https://pagure.io/SSSD/sssd/issue/2708) Logging messages from user point of view
- [\#2711](https://pagure.io/SSSD/sssd/issue/2711) [RFE] Provide interface for SSH to fetch user certificate
- [\#2712](https://pagure.io/SSSD/sssd/issue/2712) Initgroups memory cache does not work with fq names
- [\#2716](https://pagure.io/SSSD/sssd/issue/2716) Initgroups mmap cache needs update after db changes
- [\#2717](https://pagure.io/SSSD/sssd/issue/2717) well-known SID check is broken for NetBIOS prefixes
- [\#2718](https://pagure.io/SSSD/sssd/issue/2718) SSSD keytab validation check expects root ownership
- [\#2719](https://pagure.io/SSSD/sssd/issue/2719) IPA: returned unknown dp error code with disabled migration mode
- [\#2722](https://pagure.io/SSSD/sssd/issue/2722) Missing config options in gentoo init script
- [\#2723](https://pagure.io/SSSD/sssd/issue/2723) Could not resolve AD user from root domain
- [\#2724](https://pagure.io/SSSD/sssd/issue/2724) getgrgid for user's UID on a trust client prevents getpw\*
- [\#2725](https://pagure.io/SSSD/sssd/issue/2725) If AD site detection fails, not even ad_site override skipped
- [\#2729](https://pagure.io/SSSD/sssd/issue/2729) Do not send SSS_OTP if both factors were entered separately
- [\#2731](https://pagure.io/SSSD/sssd/issue/2731) searching SID by ID always checks all domains
- [\#2733](https://pagure.io/SSSD/sssd/issue/2733) Don't use deprecated libraries (libsystemd-\*)
- [\#2737](https://pagure.io/SSSD/sssd/issue/2737) sss_override: add import and export commands
- [\#2738](https://pagure.io/SSSD/sssd/issue/2738) Cannot build rpms from upstream spec file on rawhide
- [\#2742](https://pagure.io/SSSD/sssd/issue/2742) When certificate is added via user-add-cert, it cannot be looked up via org.freedesktop.sssd.infopipe.Users.FindByCertificate
- [\#2743](https://pagure.io/SSSD/sssd/issue/2743) memory cache can work intermittently
- [\#2744](https://pagure.io/SSSD/sssd/issue/2744) cleanup_groups should sanitize dn of groups
- [\#2746](https://pagure.io/SSSD/sssd/issue/2746) the PAM srv test often fails on RHEL-7
- [\#2748](https://pagure.io/SSSD/sssd/issue/2748) test_memory_cache failed in invalidation cache before stop
- [\#2749](https://pagure.io/SSSD/sssd/issue/2749) Fix crash in nss responder
- [\#2754](https://pagure.io/SSSD/sssd/issue/2754) Clear environment and set restrictive umask in p11_child
- [\#2757](https://pagure.io/SSSD/sssd/issue/2757) sss_override does not work correctly when 'use_fully_qualified_names = True'
- [\#2758](https://pagure.io/SSSD/sssd/issue/2758) sss_override contains an extra parameter --debug but is not listed in the man page or in the arguments help
- [\#2762](https://pagure.io/SSSD/sssd/issue/2762) [RFE] sssd: better feedback form constraint password change
- [\#2768](https://pagure.io/SSSD/sssd/issue/2768) Test 'test_id_cleanup_exp_group' failed
- [\#2772](https://pagure.io/SSSD/sssd/issue/2772) sssd cannot resolve user names containing backslash with ldap provider
- [\#2773](https://pagure.io/SSSD/sssd/issue/2773) Make p11_child timeout configurable
- [\#2777](https://pagure.io/SSSD/sssd/issue/2777) Fix memory leak in GPO
- [\#2782](https://pagure.io/SSSD/sssd/issue/2782) sss_override : The local override user is not found
- [\#2783](https://pagure.io/SSSD/sssd/issue/2783) REGRESSION: Dyndns soes not update reverse DNS records
- [\#2790](https://pagure.io/SSSD/sssd/issue/2790) sss_override --name doesn't work with RFC2307 and ghost users
- [\#2799](https://pagure.io/SSSD/sssd/issue/2799) unit tests do not link correctly on Debian
- [\#2803](https://pagure.io/SSSD/sssd/issue/2803) Memory leak / possible DoS with krb auth.
- [\#2805](https://pagure.io/SSSD/sssd/issue/2805) AD: Conditional jump or move depends on uninitialised value
Detailed Changelog
------------------

Jakub Hrozek (52):

- Updating the version for 1.13.1 development
- tests: Move N_ELEMENTS definition to tests/common.h
- SYSDB: Add functions to look up multiple entries including name and custom filter
- DP: Add DP_WILDCARD and SSS_DP_WILDCARD_USER/SSS_DP_WILDCARD_GROUP
- cache_req: Extend cache_req with wildcard lookups
- UTIL: Add sss_filter_sanitize_ex
- LDAP: Fetch users and groups using wildcards
- LDAP: Add sdap_get_and_parse_generic_send
- LDAP: Use sdap_get_and_parse_generic_/_recv
- LDAP: Add sdap_lookup_type enum
- LDAP: Add the wildcard_limit option
- IFP: Add wildcard requests
- Use NSCD path in execl()
- KRB5: Use the right domain for case-sensitive flag
- IPA: Better debugging
- UTIL: Lower debug level in perform_checks()
- IPA: Handle sssd-owned keytabs when running as root
- IPA: Remove MPG groups if getgrgid was called before getpw()
- LDAP: use ldb_binary_encode when printing attribute values
- IPA: Change the default of ldap_user_certificate to userCertificate;binary
- UTIL: Provide a common interface to safely create temporary files
- IPA: Always re-fetch the keytab from the IPA server
- DYNDNS: Add a new option dyndns_server
- p11child: set restrictive umask and clear environment
- KRB5: Use sss_unique file in krb5_child
- KRB5: Use sss_unique_file when creating kdcinfo files
- LDAP: Use sss_unique_filename in ldap_child
- SSH: Use sss_unique_file_ex to create the known hosts file
- SYSDB: Index the objectSIDString attribute
- sbus: Initialize errno if constructing message fails and add debug messages
- sbus: Add a special error code for messages sent by the bus itself
- GPO: Use sss_unique_file and close fd on failure
- SDAP: Remove unused function
- KRB5: Don't error out reading a minimal krb5.conf
- UTIL: Convert domain-&gt;disabled into tri-state with domain states
- DP: Provide a way to mark subdomain as disabled and auto-enable it later with offline_timeout
- SDAP: Do not set is_offline if ignore_mark_offline is set
- AD: Only ignore errors from SDAP lookups if there's another connection to fallback to
- KRB5: Offline operation with disabled domain
- AD: Do not mark the whole back end as offline if subdomain lookup fails
- AD: Set ignore_mark_offline=false when resolving AD root domain
- IPA: Do not allow the AD lookup code to set backend as offline in server mode
- BUILD: link dp tests with LDB directly to fix builds on Debian
- LDAP: imposing sizelimit=1 for single-entry searches breaks overlapping domains
- tests: Move named_domain from test_utils to common test code
- LDAP: Move sdap_create_search_base from ldap to sdap code
- LDAP: Filter out multiple entries when searching overlapping domains
- IPA: Change ipa_server_trust_add_send request to be reusable from ID code
- FO: Add an API to reset all servers in a single service
- FO: Also reset the server common data in addition to SRV
- IPA: Retry fetching keytab if IPA user lookup fails
- Updating translations for the 1.13.1 release

Lukas Slebodnik (49):

- KRB5: Return right data provider error code
- Update few debug messages
- intg: Invalidate memory cache before removing files
- SPEC: Update spec file for krb5_local_auth_plugin
- SSSDConfig: Return correct types in python3
- intg: Modernize 'except' clauses
- mmap_cache: Rename variables
- mmap_cache: "Override" functions for initgr mmap cache
- mmap: Invalidate initgroups memory cache after any change
- sss_client: Update integrity check of records in mmap cache
- intg_test: Add module for simulation of utility id
- intg_test: Add integration test for memory cache
- NSS: Initgr memory cache should work with fq names
- test_memory_cache: Add test for initgroups mc with fq names
- SPEC: Workaround for build with rpm 4.13
- KRB5: Do not try to remove missing ccache
- test_memory_cache: Test mmap cache after initgroups
- test_memory_cache: Test invalidation with sss_cache
- krb5_utils-tests: Remove unused variables
- sss_cache: Wait a while for invalidation of mc by nss responder
- test_memory_cache: Fix few python issues
- NSS: Fix use after free
- NSS: Don't ignore backslash in usernames with ldap provider
- intg_tests: Add regression test for 2163
- BUILD: Build libdlopen_test_providers.la as a dynamic library
- BUILD: Speed up build of some tests
- BUILD: Simplify build of simple_access_tests
- CI: Set env variable for all tabs in screen
- dyndns-tests: Simulate job in wrapped execv
- AUTOMAKE: Disable portability warnings
- tests: Use unique name for TEST_PATH
- tests: Move test_dom_suite_setup to different module
- test_ipa_subdomains_server: Use unique dorectory for keytabs
- test_copy_keytab: Create keytabs in unique directory
- test_ad_common: Use unique directory for keytabs
- Revert "LDAP: end on ENOMEM"
- Partially revert "LDAP: sanitize group name when used in filter"
- LDAP: Sanitize group dn before using in filter
- test_ldap_id_cleanup: Fix coding style issues
- DYNDNS: Return right error code in case of failure
- BUILD: Simplify build of test_data_provider_be
- BUILD: Remove unused variable CHECK_OBJ
- BUILD: Do not build libsss_ad_common.la as library
- BUILD: Remove unused variable SSSD_UTIL_OBJ
- CONFIGURE: Remove bashism
- IFP: Suppress warning from static analyzer
- BUILD: Link test_data_provider_be with -ldl
- sysdb-tests: Use valid base64 encoded certificate for search
- test_pam_srv: Run cert test only with NSS

Michal Židek (13):

- DEBUG: Add new debug category for fail over.
- pam: Incerease p11 child timeout
- sdap_async: Use specific errmsg when available
- TESTS: ldap_id_cleanup timeouts
- sssd: incorrect checks on length values during packet decoding
- CONFDB: Assume config file version 2 if missing
- Makefile.am: Add missing AM_CFLAGS
- SYSDB: Add function to expire entry
- cleanup task: Expire all memberof targets when removing user
- CI: Add regression test for [\#2676](https://pagure.io/SSSD/sssd/issue/2676)
- intg: Fix some PEP 8 violations
- PAM: Make p11_child timeout configurable
- tests: Set p11_child_timeout to 30 in tests

Nikolai Kondrashov (1):

- TESTS: Add trailing whitespace test

Pavel Březina (18):

- VIEWS TEST: add null-check
- SYSDB: prepare for LOCAL view
- TOOLS: add common command framework
- TOOLS: add sss_override for local overrides
- AD: Use ad_site also when site search fails
- IFP: use default limit if provided is 0
- sudo: use "higher value wins" when ordering rules
- sss_override: print input name if unable to parse it
- sss_override: support domains that require fqname
- TOOLS: add sss_colondb API
- sss_override: decompose code better
- sss_override: support import and export
- sss_override: document --debug options
- sss_override: support fqn in override name
- views: do not require overrideDN in grous when LOCAL view is set
- views: fix two typos in debug messages
- views: allow ghost members for LOCAL view
- sss_override: remove -d from manpage

Pavel Reichl (23):

- DYNDNS: sss_iface_addr_list_get return ENOENT
- DYNDNS: support mult. interfaces for dyndns_iface opt
- DYNDNS: special value '\*' for dyndns_iface option
- TESTS: dyndns tests support AAAA addresses
- DYNDNS: support for dualstack
- TESTS: fix compiler warnings
- SDAP: rename SDAP_CACHE_PURGE_TIMEOUT
- IPA: Improve messages about failures
- DYNDNS: Don't use server cmd in nsupdate by default
- DYNDNS: remove redundant talloc_steal()
- DYNDNS: remove zone command
- DYNDNS: rename field of sdap_dyndns_update_state
- DYNDNS: remove code duplication
- TESTS: UT for sss_iface_addr_list_as_str_list()
- LDAP: sanitize group name when used in filter
- LDAP: minor improvements in ldap id cleanup
- TESTS: fix fail in test_id_cleanup_exp_group
- LDAP: end on ENOMEM
- AD: send less logs to syslog
- Remove trailing whitespace
- GPO: fix memory leak
- DDNS: execute nsupdate for single update of PTR rec
- AD: inicialize root_domain_attrs field

Petr Cech (6):

- BUILD: Repair dependecies on deprecated libraries
- TESTS: Removing part of responder_cache_req-tests
- UTIL: Function 2string for enum sss_cli_command
- UTIL: Fixing Makefile.am for util/sss_cli_cmd.h
- DATA_PROVIDER: BE_REQ as string in log message
- IPA PROVIDER: Resolve nested netgroup membership

Robin McCorkell (1):

- man: List alternative schema defaults for LDAP AutoFS parameters

Stephen Gallagher (1):

- AD: Handle cases where no GPOs apply

Sumit Bose (17):

- test common: sss_dp_get_account_recv() fix assignment
- nss_check_name_of_well_known_sid() improve name splitting
- negcache: allow domain name for UID and GID
- nss: use negative cache for sid-by-id requests
- krb5: do not send SSS_OTP if two factors were used
- utils: add NSS version of cert utils
- Add NSS version of p11_child
- pack_message_v3: allow empty name
- authok: add support for Smart Card related authtokens
- PAM: add certificate support to PAM (pre-)auth requests
- pam_sss: add sc support
- ssh: generate public keys from certificate
- krb5 utils: add sss_krb5_realm_has_proxy()
- krb5: do not create kdcinfo file if proxy configuration exists
- krb5: assume online state if KDC proxy is configured
- GPO: use SDAP_SASL_AUTHID as samAccountName
- utils: make sss_krb5_get_primary() private

Thomas Oulevey (1):

- Fix memory leak in sssdpac_verify()

Tyler Gates (1):

- CONTRIB: Gentoo daemon startup options as declared in conf.d/sssd

Yuri Chornoivan (1):

- Fix minor typos
