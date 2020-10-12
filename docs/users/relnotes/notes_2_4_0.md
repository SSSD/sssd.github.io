# SSSD 2.4.0

## Highlights

- `libnss` support was dropped, SSSD now supports only `openssl` cryptography

### New features

- Session recording can now exclude specific users or groups when `scope` is set to `all` (see `exclude_users` and `exclude_groups` options)
- Active Directory provider now sends CLDAP pings over UDP protocol to Domain Controllers in parallel to determine site and forest to speed up server discovery

### Packaging changes

- python2 bindings are disable by default, use `--with-python2-bindings` to build it

### Documentation Changes

- Default value of `client_idle_timeout` changed from 60 to 300 seconds for KCM, this allows more time for user interaction (e.g. during `kinit`)
- Added `exclude_users` and `exclude_groups` option to `session_recording` section, this allows to exclude user or groups from session recording when `scope` is set to `all`
- Added `ldap_library_debug_level` option to enable debug messages from `libldap`
- Added `dyndns_auth_ptr` to set authentication mechanism for PTR DNS records update
- Added `ad_allow_remote_domain_local_groups` to be compatible with other solutions

## Tickets Fixed

* [#1030](https://github.com/SSSD/sssd/issues/1030) - Excessive dependencies on `libsss_certmap`
* [#1041](https://github.com/SSSD/sssd/issues/1041) - Deprecate and eventually get rid of support of NSS as a crypto backend
* [#3743](https://github.com/SSSD/sssd/issues/3743) - RFE: Improve AD site discovery process
* [#3987](https://github.com/SSSD/sssd/issues/3987) - "domains" description in pam_sss(8) is misleading
* [#4569](https://github.com/SSSD/sssd/issues/4569) - IFP: org.freedesktop.sssd.infopipe.GetUserGroups does not take SYSDB_PRIMARY_GROUP_GIDNUM into account
* [#4733](https://github.com/SSSD/sssd/issues/4733) - Access after free during kcm shutdown with a non-empty queue
* [#4743](https://github.com/SSSD/sssd/issues/4743) - [RFE] Add "enabled" option to domain section
* [#4829](https://github.com/SSSD/sssd/issues/4829) - KCM: Increase the default client idle timeout, consider decreasing the timeout on busy servers
* [#4840](https://github.com/SSSD/sssd/issues/4840) - gpo: use correct base dn
* [#5002](https://github.com/SSSD/sssd/issues/5002) - p11_child::do_ocsp() function implementation is not FIPS140 compliant
* [#5061](https://github.com/SSSD/sssd/issues/5061) - [RFE] Add a new mode for ad_gpo_implicit_deny
* [#5089](https://github.com/SSSD/sssd/issues/5089) - Enable exclusions in the sssd-session-recording configuration
* [#5097](https://github.com/SSSD/sssd/issues/5097) - please migrate to the new Fedora translation platform
* [#5215](https://github.com/SSSD/sssd/issues/5215) - SSSD uses only TCP/IP stream to send CLDAP request
* [#5256](https://github.com/SSSD/sssd/issues/5256) - `getent networks ip` is not working
* [#5259](https://github.com/SSSD/sssd/issues/5259) - False errors/warnings are logged in sssd.log file after enabling 2FA prompting settings in sssd.conf
* [#5261](https://github.com/SSSD/sssd/issues/5261) - Secondary LDAP group go missing from 'id' command on RHEL 7.8 with sssd-1.16.2-37.el7_8.1
* [#5274](https://github.com/SSSD/sssd/issues/5274) - dyndns: asym auth for nsupdate
* [#5278](https://github.com/SSSD/sssd/issues/5278) - sss-certmap man page change to add clarification for userPrincipalName attribute from AD schema
* [#5290](https://github.com/SSSD/sssd/issues/5290) - krb5_child denies ssh users when pki device detected
* [#5295](https://github.com/SSSD/sssd/issues/5295) - Crash in ad_get_account_domain_search()
* [#5314](https://github.com/SSSD/sssd/issues/5314) - Attribute 'ldap_sasl_realm' is not allowed in section 'domain/example.com'. Check for typos.
* [#5325](https://github.com/SSSD/sssd/issues/5325) - correction in sssd.conf man page
* [#5330](https://github.com/SSSD/sssd/issues/5330) - automount sssd issue when 2 automount maps have the same key (one un uppercase, one in lowercase)
* [#5333](https://github.com/SSSD/sssd/issues/5333) - sssd-kcm does not store TGT with ssh login using GSSAPI
* [#5338](https://github.com/SSSD/sssd/issues/5338) - [RFE] sssd-ldap man page modification for parameter "ldap_referrals"
* [#5346](https://github.com/SSSD/sssd/issues/5346) - [RfE] Implement a new sssd.conf option to disable the filter for AD domain local groups from trusted domains

## Detailed changelog

- Alexey Tikhonov (27):
  - Got rid of unused Transifex settings (".tx")
  - Got rid of "zanata.xml" due to migration to Weblate.
  - p11_child: switch default ocsp_dgst to sha1
  - Drop support of libnss as a crypto backend
  - Get rid of "NSS DB" references.
  - CONFDB: fixed compilation warning
  - CONFDB: fixed bug in confdb_get_domain_enabled()
  - CLIENT:PAM: fixed missed return check
  - PAM responder: fixed compilation warning
  - KCM: supress false positive cppcheck warnings
  - RESOLV: makes use of sss_rand() helper
  - UTIL: fortify IS_SSSD_ERROR() check
  - LDAP: sdap_parse_entry() optimization
  - DP: fixes couple of covscan's complains
  - cmocka based tests: explicitly turn LTO off
  - Makefile.am: get rid of `libsss_nss_idmap_tests`
  - sss_nss_idmap-tests: fixed error in iteration over `test_data`
  - UTIL:utf8: code cleanup
  - UTIL:utf8: moved a couple of helper
  - AD: validate `search_bases` in DPM_ACCT_DOMAIN_HANDLER
  - DP:getAccountDomain: add DP_FAST_REPLY support
  - Got rid of unused providers/data_provider/dp_pam_data.h
  - UTILS: adds helper to convert authtok type to str
  - krb5_child: fixed few mistypes in debug messages
  - parse_krb5_child_response: adds verbosity
  - krb5_child: adds verbosity
  - krb5_child: reduce log severity in sss_krb5_prompter

- Anuj Borah (1):
  - libdirsrv should be modified to be compatible with new DS

- Duncan Eastoe (4):
  - data_provider_be: Configurable max offline time
  - be_ptask: max_backoff may not be reached
  - be_ptask: backoff not applied on first re-schedule
  - data_provider_be: Add OFFLINE_TIMEOUT_DEFAULT

- Joakim Tjernlund (1):
  - Add dyndns_auth_ptr support

- Jonatan Pålsson (1):
  - build: Don't use AC_CHECK_FILE when building manpages

- Justin Stephenson (11):
  - KCM: Increase client idle timeout to 5 minutes
  - CONFIG: Add SR exclude_users exclude_groups options
  - UTIL: Add support for SR exclude_users exclude_groups
  - NSS: Rely on sessionRecording attribute
  - PAM: Rely on sessionRecording attribute
  - DP: Support SR excludes in initgroups postprocessing
  - CACHE_REQ: Support SR exclude options
  - INTG: Add session recording exclude tests
  - MAN: Add SR exclude_users and exclude_groups options
  - KCM: Fix GSSAPI delegation for the memory back end
  - KCM: Fix access after free on shutdown

- Luiz Angelo Daros de Luca (2):
  - ldap: add ldap_sasl_realm to cfg_rules.ini
  - SSSCTL: fix logs-remove when log directory is empty

- Lukas Slebodnik (20):
  - DLOPEN-TESTS: Fix error too few arguments to function ‘_ck_assert_failed’
  - SYSDB-TESTS: Fix error too few arguments to function ‘_ck_assert_failed’
  - SYSDB-TESTS: Fix format string
  - STRTONUM-TESTS: Fix format string issues
  - RESOLV-TESTS: Fix error too few arguments to function ‘_ck_assert_failed’
  - KRB5-UTILS-TESTS: Fix error too few arguments to function ‘_ck_assert_failed’
  - KRB5-UTILS-TESTS: Fix format string issues
  - CHECK-AND-OPEN-TESTS: Fix format string issues
  - REFCOUNT-TESTS: Fix error too few arguments to function ‘_ck_assert_failed’
  - FAIL-OVER-TESTS: Fix error too few arguments to function ‘_ck_assert_failed’
  - FAIL-OVER-TESTS: Fix format string issues
  - AUTH-TESTS: Fix format string issues
  - IPA-LDAP-OPT-TESTS: Fix error too few arguments to function ‘_ck_assert_failed’
  - CRYPTO-TESTS: Fix error too few arguments to function ‘_ck_assert_failed’
  - UTIL-TESTS: Fix error too few arguments to function ‘_ck_assert_failed’
  - UTIL-TESTS: Fix format string issues
  - IPA-HBAC-TESTS: Fix error too few arguments to function ‘_ck_assert_failed’
  - SSS-IDMAP-TESTS: Fix format string issues
  - RESPONDER-SOCKET-ACCESS-TESTS: Fix format string issues
  - DEBUG-TESTS: Fix warnings format not a string literal and no format arguments

- Niranjan M.R (1):
  - pytest/testlib: Execute pk12util command to create ca.p12

- Pavel Březina (21):
  - Update version in version.m4 to track the next release
  - gpo: remove unused variable domain_dn
  - gpo: use correct base dn
  - dp: fix potential race condition in provider's sbus server
  - conf: disable python2 bindings by default
  - be: remove accidental sleep
  - ldap: add support for cldap and udp connections
  - ad: use cldap for site and forrest discover (perform CLDAP ping)
  - ad: connect to the first available server for cldap ping
  - ad: if all in-site dc are unreachable try off-site controllers
  - man: fix typo in failover description
  - ad: renew site information only when SSSD was previously offline
  - tevent: correctly handle req timeout error
  - autofs: if more then one entry is found store all of them
  - pot: update pot files to allow updated translations
  - multihost: move sssd.testlib closer to tests
  - multihost: remove packaging files
  - spec: enable kcm by default
  - tests: run TIER-0 multihost tests in PRCI
  - git-template: add tags to help with release notes automation
  - Release sssd-2.4.0

- Samuel Cabrero (7):
  - PROXY: Fix iphost not found code path in get_host_by_name_internal
  - NSS: Fix get ip network by address when address type is AF_UNSPEC
  - NSS: Fix _nss_sss_getnetbyaddr_r address byte order
  - PROXY: getnetbyaddr_r expects the net argument in host byte order
  - TESTS: getnetbyaddr_r expects network in host byte order
  - TESTS: Fix resolver test calling getnetbyname instead of getnetbyaddr
  - TESTS: Extend resolver tests to check getnetbyaddr with AF_UNSPEC

- Simo Sorce (1):
  - krb5_child: Harden credentials validation code

- Steeve Goveas (3):
  - use prerealease option in make srpm script
  - Add seconds in copr version
  - enable files domain in copr builds for testing

- Sumit Bose (16):
  - GPO: respect ad_gpo_implicit_deny when evaluation rules
  - cache_req: allow to restrict the domains an object is search in
  - tests: add unit-test for cache_req_data_set_requested_domains
  - pam: use requested_domains to restrict cache_req searches
  - intg: krb5 auth and pam_sss domains option test
  - pam_sss: clarify man page entry of domains option
  - krb5: only try pkinit with Smartcard credentials
  - ldap: add new option ldap_library_debug_level
  - ldap: use member DN to create ghost user hash table
  - intg: allow member DN to have a different case
  - ad: fix handling of current site and forest in cldap ping
  - ad: add ad_allow_remote_domain_local_groups
  - cert: move cert_to_ssh_key_send/recv() to ssh responder
  - sysdb: add sysdb_cert_derb64_to_ldap_filter()
  - cert: move sss_cert_derb64_to_ldap_filter() out of libsss_cert.so
  - build: remove libsss_certmap from dependencies of libsss_cert

- Thorsten Scherf (2):
  - MAN: fix 'pam_responsive_filter' option type
  - MAN: update 'ldap_referrals' config entry

- Timothée Ravier (1):
  - sss_cache: Do nothing if SYSTEMD_OFFLINE=1

- Tomas Halman (3):
  - UTIL: DN sanitization
  - UTIL: Use sss_sanitize_dn where we deal with DN
  - UTIL: Use sss_sanitize_dn where we deal with DN 2

- Weblate (1):
  - Update the translations for the 2.4.0 release

- ikerexxe (8):
  - man: clarify AD certificate rule
  - config: allow prompting options in configuration
  - util/sss_python: change MODINITERROR to dereference module
  - python/pysss_nss_idmap: check return from functions
  - python/pyhbac: if PyModule* fails decrement references
  - python/pysss: if PyModule* fails decrement references
  - IFP: GetUserGroups() returns origPrimaryGroupGidNumber
  - IFP-TESTS: GetUserGroups() returns origPrimaryGroupGidNumber
