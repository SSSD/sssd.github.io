# SSSD 2.4.1

## Highlights

### General information

* `SYSLOG_IDENTIFIER` was renamed to `SSSD_PRG_NAME` in journald output, to avoid issues with PID parsing in rsyslog (BSD-style forwarder) output.

### New features

* New PAM module `pam_sss_gss` for authentication using GSSAPI
* `case_sensitive=Preserving` can now be set for trusted domains with AD provider
* `case_sensitive=Preserving` can now be set for trusted domains with IPA provider. However, the option needs to be set to `Preserving` on both client and the server for it to take effect.
* `case_sensitive` option can be now inherited by subdomains
* `case_sensitive` can be now set separately for each subdomain in `[domain/parent/subdomain]` section
* `krb5_use_subdomain_realm=True` can now be used when sub-domain user principal names have upnSuffixes which are not known in the parent domain. SSSD will try to send the Kerberos request directly to a KDC of the sub-domain.

### Important fixes

* krb5_child uses proper umask for DIR type ccaches
* Memory leak in the simple access provider
* KCM performance has improved dramatically for cases where large amount of credentials are stored in the ccache.

### Packaging changes

* Added `pam_sss_gss.so` PAM module and `pam_sss_gss.8` manual page

### Configuration changes

* New default value of `debug_level` is 0x0070
* Added `pam_gssapi_check_upn` to enforce authentication only with principal that can be associated with target user.
* Added `pam_gssapi_services` to list PAM services that can authenticate using GSSAPI

## Tickets Fixed

* [#3413](https://github.com/SSSD/sssd/issues/3413) - autofs: return a connection failure until maps have been fetched
* [#3730](https://github.com/SSSD/sssd/issues/3730) - proxy_child hardening
* [#4590](https://github.com/SSSD/sssd/issues/4590) - syslog mesages for back ends uses invalid ident tag
* [#4759](https://github.com/SSSD/sssd/issues/4759) - sssd krb5_child using wrong domain to authenticate
* [#4829](https://github.com/SSSD/sssd/issues/4829) - KCM: Increase the default client idle timeout, consider decreasing the timeout on busy servers
* [#5121](https://github.com/SSSD/sssd/issues/5121) - timestamp cache entries are not created if missing
* [#5238](https://github.com/SSSD/sssd/issues/5238) - Unexpected behavior and issue with filter_users/filter_groups option
* [#5250](https://github.com/SSSD/sssd/issues/5250) - [RFE] RHEL8 sssd: inheritance of the case_sensitive parameter for subdomains.
* [#5333](https://github.com/SSSD/sssd/issues/5333) - sssd-kcm does not store TGT with ssh login using GSSAPI
* [#5349](https://github.com/SSSD/sssd/issues/5349) - kcm: poor performance with large number of credentials
* [#5351](https://github.com/SSSD/sssd/issues/5351) - Do not overwrite LDAP data of local domain when looking up a Global Catalog
* [#5359](https://github.com/SSSD/sssd/issues/5359) - SSSD can hang being blocked on TCP operation involving socket opened internally by libldap
* [#5382](https://github.com/SSSD/sssd/issues/5382) - User lookups over the InfoPipe responder fail intermittently
* [#5384](https://github.com/SSSD/sssd/issues/5384) - sssd syslog/journal logging is now too generic
* [#5400](https://github.com/SSSD/sssd/issues/5400) - Can't login with smartcard with multiple certs having same ID value
* [#5403](https://github.com/SSSD/sssd/issues/5403) - filter_groups option partially filters the group from 'id' output of the user because gidNumber still appears in 'id' output [RHEL 8]
* [#5412](https://github.com/SSSD/sssd/issues/5412) - sssd_be segfaults at be_refresh_get_values_ex() due to NULL ptrs in results of sysdb_search_with_ts_attr()
* [#5425](https://github.com/SSSD/sssd/issues/5425) - SBUS: failures during servers startup
* [#5436](https://github.com/SSSD/sssd/issues/5436) - krb5_child: "DIR:" ccache directory created with bad mode 0600 due to umask
* [#5451](https://github.com/SSSD/sssd/issues/5451) - resolv: resolv_gethostbyname_dns_parse() doesn't properly handle fail of ares_parse_*_reply()
* [#5456](https://github.com/SSSD/sssd/issues/5456) - Memory leak in the simple access provider
* [#5466](https://github.com/SSSD/sssd/issues/5466) - SBUS: NULL deref in dp_client_handshake_timeout()
* [#5469](https://github.com/SSSD/sssd/issues/5469) - sssd unable to lookup certmap rules
* [#5471](https://github.com/SSSD/sssd/issues/5471) - [RFE] sss_override:  Usage limitations clarification in man page
* [#5475](https://github.com/SSSD/sssd/issues/5475) - Do not add '%' to group names already prefixed with '%' in IPA sudo rules
* [#5488](https://github.com/SSSD/sssd/issues/5488) - Unexpected (?) side effect of SSSDBG_DEFAULT change

## Detailed changelog

- Alexander Bokovoy (1):
  - sudo runas: do not add '%' to external groups in IPA

- Alexey Tikhonov (65):
  - SDAP: set common options for sockets open by libldap
  - DEBUG: journal_send() was made static
  - DEBUG: fixes program identifier as seen in syslog
  - SYSDB: merge_res_sysdb_attrs() fixed to avoid NULL ptr in msgs[]
  - KCM: avoid NULL deref
  - SYSDB:autofs: cosmetic updates
  - SYSDB: wrong debug message corrected
  - SYSDB:sudo: changed debug message to be consistent
  - SYSDB:iphosts: severity level of few debug messages adjusted
  - SYSDB:ipnetworks: severity level of few debug messages adjusted
  - SYSDB:ops: few debug messages were corrected
  - SYSDB:search: few debug messages were corrected
  - SYSDB:selinux: debug message severity level was adjusted
  - SYSDB:service: severity level of few debug messages adjusted
  - SYSDB:upgrade: debug message corrected
  - SYSDB:views: few debug message corrections
  - MONITOR: severity level of few debug messages adjusted
  - P11_CHILD: severity level of few debug messages adjusted
  - AD: few debug message corrections
  - DP: few debug message corrections
  - IPA: few debug message corrections
  - KRB5: few debug message corrections
  - LDAP: few debug message corrections
  - PROXY: few debug message corrections
  - RESOLV: debug message correction
  - AUTOFS: few debug message corrections
  - CACHE_REQ: debug message correction
  - RESPONDER: few debug message corrections
  - IFP: few debug message corrections
  - NSS: few debug message corrections
  - PAM: few debug message corrections
  - UTIL: few debug message corrections
  - PAM: reduce log level in may_do_cert_auth()
  - UTIL: sss_ldb_error_to_errno() improved
  - SYSDB: reduce log level in sysdb_update_members_ex() in case failed attempt to DEL unexisting attribute
  - LDAP: added missed \n in log message
  - SSS_IFACE: corrected misleading return code
  - IPA: corrected confusing message
  - DP: do not log failure in case provider doesn't support check_online method
  - RESPONDER: reduce log level in sss_parse_inp_done() in case of "Unknown domain" since this might be search by UPN
  - SBUS: reduced log level in case of unexpected signal
  - LDAP: reduced log level in hosts_get_done()
  - CACHE_REQ: reduced log level in cache_req_object_by_name_well_known() Non fqdn input isn't necessarily an error here.
  - SDAP: reduced log level in case group without members
  - AD: reduced log level in case check_if_pac_is_available() can't find user entry. This is typical situation when, for example, INITGROUPS lookup is executed for uncached user.
  - FILES: reduced debug level in refresh_override_attrs() if case "No overrides, nothing to do"
  - LOGS: default log level changed to <= SSSDBG_OP_FAILURE
  - UTIL: fixed bug in server_setup() that prevented setting debug level to 0 explicitly
  - CERTMAP: removed stray debug message
  - IPA: reduce log level in apply_subdomain_homedir()
  - SYSDB: changed log level in sysdb_update_members_ex()
  - IPA: ignore failed group search in certain cases
  - IPA: changed logging in ipa_get_subdom_acct_send()
  - SYSDB: changed logging in sysdb_get_real_name()
  - LDAP: reduce log level in case of fail to store members of missing group (it might be built-in skipped intentionally)
  - LDAP: sdap_save_grpmem(): log level changed
  - UTIL: find_domain_by_object_name_ex() changed log level
  - RESOLV: handle fail of ares_parse_*_reply() properly
  - SBUS: do not try to del non existing sender
  - Removed leftovers after PR #5246
  - dhash tables are now created with count=0 whenever no useful size hint available
  - SBUS: set sbus_name before dp_init_send()
  - PROXY: child process security hardening
  - Sanitize --domain option to allow safe usage as a part of log file name
  - Makefile: add missing '-fno-lto' to some tests

- Anuj Borah (1):
  - TESTS:KCM: Increase client idle timeout to 5 minutes

- Armin Kuster (1):
  - Provide missing defines which otherwise are available on glibc system headers

- Deepak Das (1):
  - man: sss_override clarification

- Duncan Eastoe (2):
  - nss: Use posix_fallocate() to alloc memcache file
  - nss: remove clear_mc_flag file after clearing caches

- Evgeny Sinelnikov (1):
  - krb5: allow to use subdomain realm during authentication

- Justin Stephenson (1):
  - krb5: Remove secrets text from drop-in KCM file

- Madhuri Upadhye (6):
  - Test: AD: For sssd crash in ad_get_account_domain_search
  - Test: alltests: "enabled" option to domain section
  - Update remove command to delete the snippet files
  - Update the title of test case.
  - Tests: alltests: "ldap_library_debug_level" option to domain section
  - alltests: password_policy: Removing the log debug messages

- Marco Trevisan (Treviño) (1):
  - test_ca: Look for libsofthsm2 in libdir before falling back to hardcoded paths

- Pavel Březina (64):
  - Update version in version.m4 to track the next release
  - kcm: fix typos in debug messages
  - kcm: avoid name confusion in GET_CRED_UUID_LIST handlers
  - kcm: disable encryption
  - kcm: avoid multiple debug messages if sss_sec_put fails
  - secrets: allow to specify secret's data format
  - secrets: accept binary data instead of string
  - iobuf: add more iobuf functions
  - kcm: add json suffix to existing searialization functions
  - kcm: move sec key parser to separate file so it can be shared
  - kcm: avoid suppression of cppcheck warning
  - kcm: add spaces around operators in kcmsrv_ccache_key.c
  - kcm: use binary format to store ccache instead of json
  - kcm: add per-connection data to be shared between requests
  - sss_ptr_hash: fix double free for circular dependencies
  - kcm: store credentials list in hash table to avoid cache lookups
  - secrets: fix may_payload_size exceeded debug message
  - secrets: default to "plaintext" if "enctype" attr is missing
  - secrets: move attrs names to macros
  - secrets: remove base64 enctype
  - cache_req: allow cache_req to return ERR_OFFLINE if all dp request failed
  - autofs: return ERR_OFFLINE if we fail to get information from backend and cache is empty
  - autofs: translate ERR_OFFLINE to EHOSTDOWN
  - autofs: disable fast reply
  - autofs: correlate errors for different protocol versions
  - configure: check for stdatomic.h
  - kcm: decode base64 encoded secret on upgrade path
  - sss_format.h: include config.h
  - packet: add sss_packet_set_body
  - domain: store hostname and keytab path
  - cache_req: add helper to call user by upn search
  - pam: fix typo in debug message
  - pam: add pam_gssapi_services option
  - pam: add pam_gssapi_check_upn option
  - pam: add pam_sss_gss module for gssapi authentication
  - pam_sss: fix missing initializer warning
  - pamsrv_gssapi: fix implicit conversion warning
  - gssapi: default pam_gssapi_services to NULL in domain section
  - pam_sss_gssapi: fix coverity issues
  - cache_req: ignore autofs not configured error
  - man: add auto_private_groups to subdomain_inherit
  - subdomains: allow to inherit case_sensitive=Preserving
  - subdomains: allow to set case_sensitive=Preserving in subdomain section
  - subdomains: allow to inherit case_sensitive=Preserving for IPA
  - man: update case_sensitive documentation to reflect changes for subdomains
  - po: add pam_sss_gss to translated man pages
  - pot: update pot files
  - spec: synchronize with Fedora 34 spec file
  - spec: remove unneeded conditionals and unused variables
  - spec: keep _strict_symbol_defs_build
  - spec: enable LTO
  - spec: remove support for NSS
  - spec: remove --without-python2-bindings
  - spec: re-import changes that were not merged in Fedora
  - spec: synchronize with RHEL spec file
  - spec: use sssd user on RHEL
  - spec: remove conflicts that no longer make sense
  - spec: remove unused BuildRequires
  - spec: remove unused Requires
  - spec: sort Requires, BuildRequires and configure for better clarity
  - spec: comment some requirements
  - spec: fix spelling in package description
  - spec: use %autosetup instead of %setup
  - configure: libcollection is not required

- Paweł Poławski (2):
  - data_provider_be: Add random offset default
  - data_provider_be: MAN page update

- Samuel Cabrero (2):
  - Improve samba version check for ndr_pull_steal_switch_value signature
  - winbind idmap plugin: Fix struct idmap_domain definition

- Sergio Durigan Junior (1):
  - Only start sssd.service if there's a configuration file present

- Shridhar Gadekar (1):
  - Tests:ad:sudo: support non-posix groups in sudo rules

- Steeve Goveas (13):
  - Move conftest.py to basic dir
  - Add alltests code
  - Add ad test code
  - Add ipa test code
  - Update sssd testlibs
  - Add empty conftest.py and update path to run basic tests
  - Fix pep8 issues
  - Include data directory
  - Fix errors found during testing
  - Remove trailing whitespaces
  - tests: modify ipa client install for fedora
  - TEST: Split tier1 tests with new pytest marker
  - tests: netstat command not found for test

- Sumit Bose (18):
  - ifp: fix use-after-free
  - AD: do not override LDAP data during GC lookups
  - negcache: make sure domain config does not leak into global
  - utils: add SSS_GND_SUBDOMAINS flag for get_next_domain()
  - negcache: make sure short names are added to sub-domains
  - negcache: do not use default_domain_suffix
  - ifp: fix original fix use-after-free
  - nss: check if groups are filtered during initgroups
  - pam_sss: use unique id for gdm choice list
  - authtok: add label to Smartcard token
  - pam_sss: add certificate label to reply to pam_sss
  - add tests multiple certs same id
  - simple: fix memory leak while reloading lists
  - krb5_child: use proper umask for DIR type ccaches
  - BUILD: Accept krb5 1.19 for building the PAC plugin
  - responders: add callback to schedule_get_domains_task()
  - pam: refresh certificate maps at the end of initial domains lookup
  - ssh: restore default debug level

- Tomas Halman (2):
  - CACHE: Create timestamp if missing
  - TESTS: Add test for recreating cache timestamp

- Valters Jansons (1):
  - DEBUG: Drop custom syslog identifier from journald

- aborah (1):
  - TESTS:sssd-kcm does not store TGT with ssh login using GSSAPI

- peptekmail (3):
  - Add rsassapss cert for future checks
  - Add rsassapss cert for future checks
  - Add rsassapss cert for future checks

- tobias-gruenewald (3):
  - Change LDAP group type from int to string
  - Change LDAP group type from int to string
  - Change LDAP group type from int to string
