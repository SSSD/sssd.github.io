# SSSD 2.3.0

## Highlights

### New features

- SSSD can now handle `hosts` and `networks` nsswitch databases (see `resolve_provider` option)
- By default, authentication request only refresh user's initgroups if it is expired or there is not active user's session (see `pam_initgroups_scheme` option)
- OpenSSL is used as default crypto provider, NSS is deprecated
- Active Directory provider now defaults to GSS-SPNEGO SASL mechanism (see `ldap_sasl_mech` option)
- Active Directory provider can now be configured to use only `ldaps` port (see `ad_use_ldaps` option)
- SSSD now accepts host entries from GPO's security filter
- Format of debug messages has changed to be shorter and better sortable
- New debug level (`0x10000`) was added for low level ldb messages only (see `sssd.conf` man page)

### Packaging changes

- New configure option `--enable-gss-spnego-for-zero-maxssf`

### Documentation Changes

- Default value of `ldap_sasl_mech` has changed to `GSS-SPNEGO` for AD provider
- Return code of `pam_sss.so` are documented in `pam_sss` manpage
- Added option `ad_update_samba_machine_account_password`
- Added option `ad_use_ldaps`
- Added option `ldap_iphost_object_class`
- Added option `ldap_iphost_name`
- Added option `ldap_iphost_number`
- Added option `ldap_ipnetwork_object_class`
- Added option `ldap_ipnetwork_name`
- Added option `ldap_ipnetwork_number`
- Added option `ldap_iphost_search_base`
- Added option `ldap_ipnetwork_search_base`
- Added option `ldap_connection_expire_offset`
- Added option `ldap_sasl_maxssf`
- Added option `pam_initgroups_scheme`
- Added option `entry_cache_resolver_timeout`
- Added option `entry_cache_computer_timeout`
- Added option `resolver_provider`
- Added option `proxy_resolver_lib_name`
- Minor text improvements

## Tickets Fixed

- [#1025](https://github.com/SSSD/sssd/issues/1025) - Man pages don't mention that `use_fully_qualified_names==true` for trusted domain
- [#1032](https://github.com/SSSD/sssd/issues/1032) - Wrong debug level in calc_flat_name()?
- [#1038](https://github.com/SSSD/sssd/issues/1038) - `sssd.api.conf` and `sssd.api.d` should belong to `python-sssdconfig` package
- [#2404](https://github.com/SSSD/sssd/issues/2404) - Fill missing config options in SSSDConfig.py
- [#4356](https://github.com/SSSD/sssd/issues/4356) - GPO Security Filtering and Access Control are not Compliant with MS-ADTS
- [#4489](https://github.com/SSSD/sssd/issues/4489) - TESTS: make intgcheck is not always passing in the internal CI (enumeration tests)
- [#4541](https://github.com/SSSD/sssd/issues/4541) - Disable host wildcards in sudoHost attribute (ldap_sudo_include_regexp=false)
- [#4651](https://github.com/SSSD/sssd/issues/4651) - Randomize ldap_connection_expire_timeout either by default or w/ a configure option
- [#4691](https://github.com/SSSD/sssd/issues/4691) - Provide a list of pam_status return codes used by the pam_sss.so module in the module man file
- [#4730](https://github.com/SSSD/sssd/issues/4730) - subdomain lookup fails when certmaprule contains DN
- [#4978](https://github.com/SSSD/sssd/issues/4978) - [RFE] SSSD should use GSS-SPNEGO instead of GSSAPI when talking to AD
- [#5010](https://github.com/SSSD/sssd/issues/5010) - MAN page: sssd-ipa: confusing text
- [#5029](https://github.com/SSSD/sssd/issues/5029) - override_gid not working for subdomains
- [#5052](https://github.com/SSSD/sssd/issues/5052) - server/be: SIGTERM handling is incorrect
- [#5053](https://github.com/SSSD/sssd/issues/5053) - Watchdog implementation or usage is incorrect
- [#5062](https://github.com/SSSD/sssd/issues/5062) - initgroups for already logged in users should not cause long delays
- [#5079](https://github.com/SSSD/sssd/issues/5079) - sssd requires timed sudoers ldap entries to be specified up to the seconds
- [#5082](https://github.com/SSSD/sssd/issues/5082) - [RFE]: use certificate matching rule when generating SSH key from a certificate
- [#5085](https://github.com/SSSD/sssd/issues/5085) - Impossible to enforce GID on the AD's "domain users" group in the IPA-AD trust setup
- [#5087](https://github.com/SSSD/sssd/issues/5087) - pcscd rejecting sssd ldap_child as unauthorized
- [#5088](https://github.com/SSSD/sssd/issues/5088) - [Doc]Provide explanation on escape character for match rules sss-certmap
- [#5090](https://github.com/SSSD/sssd/issues/5090) - sssctl config-check command does not give proper error messages with line numbers
- [#5092](https://github.com/SSSD/sssd/issues/5092) - Force LDAPS over 636 with AD Provider
- [#5094](https://github.com/SSSD/sssd/issues/5094) - Unreadable GPOs should not be logged as a critical failure
- [#5096](https://github.com/SSSD/sssd/issues/5096) - util/sss_ptr_hash.c: potential double free in `sss_ptr_hash_delete_cb()`
- [#5100](https://github.com/SSSD/sssd/issues/5100) - sssd_be frequent crash
- [#5105](https://github.com/SSSD/sssd/issues/5105) - Build error with python3.8-config --ldflags
- [#5106](https://github.com/SSSD/sssd/issues/5106) - Expecting appropriate error message when new password length is less than 8 characters when ldap_pwmodify_mode = ldap_modify in sssd.conf
- [#5114](https://github.com/SSSD/sssd/issues/5114) - p11_child should have an option to skip C_WaitForSlotEvent  if the PKCS#11 module does not implement it properly
- [#5116](https://github.com/SSSD/sssd/issues/5116) - sssctl config-check reports errors when auto_private_groups is disabled/enabled in child domains
- [#5124](https://github.com/SSSD/sssd/issues/5124) - "off-by-one error" in watchdog implementation
- [#5126](https://github.com/SSSD/sssd/issues/5126) - sbus: wrong handling of certain fails in sbus_dbus_connect_address()
- [#5128](https://github.com/SSSD/sssd/issues/5128) - SSSD doesn't honour the customized ID view created in IPA
- [#5129](https://github.com/SSSD/sssd/issues/5129) - id_provider = proxy proxy_lib_name = files returns * in password field, breaking PAM authentication
- [#5132](https://github.com/SSSD/sssd/issues/5132) - background refresh task does not refresh updated netgroup entries
- [#5133](https://github.com/SSSD/sssd/issues/5133) - Odd lastUpdate attribute if SSSD is started without sssd.conf
- [#5136](https://github.com/SSSD/sssd/issues/5136) - ad and ipa backends should require proper version of `samba-client-libs`
- [#5139](https://github.com/SSSD/sssd/issues/5139) - pam_sss reports PAM_CRED_ERR when providing wrong password for an existing IPA user, but this error's description is misleading
- [#5160](https://github.com/SSSD/sssd/issues/5160) - Multiples Kerberos ticket on RHEL 7.7 after lock and unlock screen

## Detailed changelog

- Alex Rodin (5):
  - Update pam_sss.8.xml
  - Update __init__.py.in
  - SSSDConfig: Update of config options
  - SSSDConfig: New SSSDOptions class
  - MAN: use_fully_qualified_names description updated

- Alexey Tikhonov (26):
  - providers/krb5: got rid of unused code
  - data_provider_be: got rid of duplicating SIGTERM handler
  - util/server: improved debug at shutdown
  - util/watchdog: fixed watchdog implementation
  - util/sss_ptr_hash: fixed double free in sss_ptr_hash_delete_cb()
  - sbus_server: stylistic rename
  - sss_ptr_hash: don't keep empty sss_ptr_hash_delete_data
  - sss_ptr_hash: sss_ptr_hash_delete fix/optimization
  - sss_ptr_hash: removed redundant check
  - sss_ptr_hash: fixed memory leak
  - sss_ptr_hash: internal refactoring
  - TESTS: added sss_ptr_hash unit test
  - Watchdog: fixes "off-by-one" error
  - sssd.spec.in: added missing Requires
  - PAM: fixed wrong debug message
  - MAN: fixed description of pam_cert_db_path
  - SPEC: added explicit `samba-client-libs` dependency
  - config: switch to OpenSSL as default crypto backend
  - SPEC: 'sssd.api.*' should belong `python-sssdconfig`
  - TESTS: NSS db setup is only required in NSS based build
  - SBUS: do not return invalid connection pointer
  - Fixed unsafe usage of strncpy()
  - DEBUG: changed timestamp output format
  - DEBUG: introduce new SSSDBG_TRACE_LDB level
  - DEBUG: changed "debug_prg_name" format
  - WATCHDOG: log process termination to the journal

- Andreas Hasenack (1):
  - Fix another build failure with python 3.8

- Andrew Gunnerson (1):
  - ad: Add support for passing --add-samba-data to adcli

- David Mulder (5):
  - SSSD should accept host entries from GPO's security filter
  - Test the host sid checking
  - Remove sssd Security Filtering host comment from man
  - Create a computer_timeout for caching GPO security filter
  - Resolve computer lookup failure when sam!=cn

- Fabiano Fidêncio (1):
  - INTG: Increase the sleep() time so the changes are reflected on SSSD

- Joakim Tjernlund (1):
  - Update OpenRC init.d script

- Lars Francke (1):
  - ldap: set ldap_group_name to sAMAccountName for ad schema

- Lukas Slebodnik (8):
  - BE_REFRESH: Do not try to refresh domains from other backends
  - SSS_INI: Fix syntax error in sss_ini_add_snippets
  - PROXY: Fix warning-format-overflow directive argument is null
  - test_nss_srv: Suppress Conditional jump or move depends on uninitialised value
  - CONFIGURE: Fix detection of samba version for idmap plugin
  - CONFIGURE: Fix detection of attribute fallthrough
  - BUILD: Accept krb5 1.18 for building the PAC plugin
  - CI: Drop usage of unnecessary copr repo for mock

- MIZUTA Takeshi (4):
  - util/server: Fix the timing to close() the PID file
  - Remove redundant header file inclusion
  - monitor: Fix check process about multiple starts of sssd when pidfile remains
  - man: fix typos - correct manpage reference - correct wrong word - capitalize the first letter

- Michal Židek (5):
  - Update version in version.m4 to track the next release.
  - Bump the version.
  - nss: Collision with external nss symbol
  - sssd.spec: Add recommended packages
  - spec: Do not overwrite /etc/pam.d/sssd-shadowutils

- Noel Power (2):
  - Use ndr_pull_steal_switch_value for modern samba versions
  - ad_gpo_ndr.c: refresh ndr_ methods from samba-4.12

- Pavel Březina (18):
  - nss: use real primary gid if the value is overriden
  - ci: add rhel7
  - ci: set sssd-ci notification to pending state when job is started
  - ci: archive ci-mock-result
  - tests: fix race condition in enumeration tests
  - ci: add CentOS 7
  - sss_sockets: pass pointer instead of integer
  - ci: keep system list outside repository
  - ci: remove old dependency repository
  - sdap: provide error message when password change fail in ldap_modify mode
  - sbus: commit complete generated code
  - proxy: set pwfield to x for files library
  - proxy: do not fail if proxy_resolver_lib_name is not set
  - be: add BE_REQ_HOST to be_req2str
  - dp: free methods if target is not configured
  - sysdb: check if the id override belongs to requested domain
  - p11_child: fix initializer error
  - Move from Pagure to Github

- Paweł Poławski (6):
  - sysdb_sudo: Enable LDAP time format compatibility
  - GPO: Duplicated error message for unreadable GPO
  - LDAP: Netgroups refresh in background task
  - SYSDB: Cache selector as enum
  - DOMAIN: Downgrade log message type
  - MAN: refresh_expired_interval description updated

- Petr Vaněk (1):
  - configure: prefer python3 if available

- REIM THOMAS (5):
  - GPO: Grant access if DACL is not present
  - GPO: Support group policy file main folders with upper case name
  - GPO: Close group policy file after copying
  - GPO: Group policy access evaluation not in line with [MS-ADTS]
  - GPO: Improve logging of GPO security filtering

- Samuel Cabrero (69):
  - AD: Improve host SID retrieval
  - AD: use getaddrinfo with AI_CANONNAME to find the FQDN
  - STAP: Add missing session data provider target
  - UTIL: Add a function to canonicalize IP addresses
  - SYSDB: Add sysdb functions for hosts entries
  - SYSDB: Add index for hostAddress attribute
  - SBUS: Add new resolver target interface
  - DP: Add a new filter type, filter by address
  - RESPONDER: Add sss_dp_resolver_get_send
  - CACHE_REQ: Rename cache req host by name name plugin used by SSH
  - CACHE_REQ: Add a data field to store network addresses
  - CACHE_REQ: Implement ip_host_by_addr and ip_host_by_name plugins
  - NSS: Add client support for hosts (non-enumeration)
  - NSS: Add gethostbyname and gethostbyaddr support to the NSS responder
  - TESTS: Add gethostbyname and gethostbyaddr NSS responder tests
  - DP: Implement resolver target handler
  - CONFDB: Add new options for resolver provider
  - CONFDB: Add a new resolver_timeout to timeout cached resolver entries
  - UTIL: Allow to specify mandatory and optional symbols when loading nss libs
  - PROXY: Create a module context to store id and auth contexts
  - PROXY: Load resolver NSS library
  - PROXY: Register resolver hosts handler method
  - PROXY: Handle resolver hosts by name requests
  - PROXY: Store results from NSS library call into the cache
  - SYSDB: Extend sysdb_store_host() to accept extra attributes
  - PROXY: Handle resolver hosts by address requests
  - LDAP: Initialize resolver provider
  - AD: Initialize resolver provider
  - LDAP: Initialize ldap_iphost_* options
  - LDAP: Document new ldap_iphost_* options
  - AD: Initialize ldap_iphost_* options
  - LDAP: Prepare for iphost lookups
  - LDAP: Add support for iphost lookups (no enumeration)
  - NSS: Add client support for `[set|get|end]hostent()`
  - SYSDB: Add support for enumerating hosts
  - CACHE_REQ: Add support for enumerating hosts
  - LDAP: Setup resolver enumeration tasks
  - LDAP: Add support for iphost enumeration
  - AD: Setup resolver enumeration tasks
  - AD: Add support for iphost enumeration
  - LDAP: Implement iphost cleanup for expired cache entries
  - AD: Implement iphost cleanup for expired cache entries
  - PROXY: Add support for iphost enumeration
  - TESTS: Add LDAP resolver target integration tests
  - SYSDB: Add sysdb functions for ipnetwork entries
  - SYSDB: Add index for ipNetworkNumber attribute
  - CACHE_REQ: Implement ip_network_by_name and ip_network_by_addr plugins
  - NSS: Add client support for networks (non-enumeration)
  - NSS: Add getnetbyname and getnetbyaddr support to the NSS responder
  - TESTS: Add getnetbyname and getnetbyaddr NSS responder tests
  - DP: Handle IP network requests in resolver target
  - PROXY: Load networks symbols
  - PROXY: Handle resolver IP network by name requests
  - PROXY: Handle resolver IP network by address requests
  - SYSDB: Add functions to store IP networks from providers
  - PROXY: Store IP network results from NSS library in the cache
  - LDAP: Initialize ldap_ipnetwork_* options
  - LDAP: Document new ldap_ipnetwork_* options
  - AD: Initialize new ldap_ipnetwork_* options
  - LDAP: Prepare for ipnetwork lookups (no enumeration)
  - LDAP: Add support for ipnetwork lookups (no enumeration)
  - NSS: Add client support for `[set|get|end]netent()`
  - SYSDB: Add support for enumerating ipnetworks
  - CACHE_REQ: Add support for enumerating ip networks
  - LDAP: Add support for ipnetworks enumeration
  - LDAP: Implement ipnetwork cleanup for expired cache entries
  - PROXY: Add support for ipnetwork enumeration
  - TESTS: Add LDAP resolver IP networks tests
  - Drop obsolete SUSE spec file

- Simo Sorce (3):
  - Add TCP level timeout to LDAP services
  - cache_req: introduce cache_behavior enumeration
  - pam: Use cache for users with existing session

- Stephen Gallagher (1):
  - Fix build failure against samba 4.12.0rc1

- Sumit Bose (23):
  - ldap_child: do not try PKINIT
  - certmap: mention special regex characters in man page
  - ad: allow booleans for ad_inherit_opts_if_needed()
  - ad: add ad_use_ldaps
  - ldap: add new option ldap_sasl_maxssf
  - ad: set min and max ssf for ldaps
  - ssh: do not mix different certificate lists
  - ssh: add 'no_rules' and 'all_rules' to ssh_use_certificate_matching_rules
  - p11_child: check if card is present in wait_for_card()
  - PAM client: only require UID 0 for private socket
  - ssh: fix matching rules default
  - ipa: add missing new-line in debug message
  - sysdb: sanitize certmap rule name before using it in DN
  - confdb: use proper timestamp if sssd.conf is missing
  - sudo: fix ldap_sudo_include_regexp default
  - ad: use GSSAPI with LDAPS
  - ad: change SASL mech default to GSS-SPNEGO
  - ad: make GSS-SPNEGO maxssf=0 workaround configurable
  - krb5: do not cache ccache or password during preauth
  - pam: add option pam_initgroups_scheme
  - pam: use pam_initgroups_scheme
  - cache_req: no refresh with CACHE_REQ_BYPASS_PROVIDER
  - pam: make sure initgr cache is not created twice

- Thorsten Scherf (2):
  - Fix sssd-ldap man page
  - add reference to sss_obfuscate man page

- Tomas Halman (3):
  - sdap: Add randomness to ldap connection timeout
  - INI: sssctl config-check command error messages
  - SYSDB: override_gid not working for subdomains

- Yuri Chornoivan (1):
  - sssctl: fix typo in user message

- ikerexxe (3):
  - config: allowed auto_private_groups in child domains
  - man: in sssd-ipa clarified trusted domains section
  - ipa_auth and krb5_auth: when providing wrong password return PAM_AUTH_ERR
