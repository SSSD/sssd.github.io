SSSD 1.15.3
===========

Highlights
----------

### New Features

- In a setup where an IPA domain trusts an Active Directory domain, it is now possible to [define the domain resolution order](http://www.freeipa.org/page/Releases/4.5.0#AD_User_Short_Names). Starting with this version, SSSD is able to read and honor the domain resolution order, providing a way to resolve Active Directory users by just their short name. SSSD also supports a new option `domain_resolution_order` applicable in the `[sssd]` section that allows to configure short names for AD users in setup with `id_provider=ad` or in a setup with an older IPA server that doesn't support the `ipa config-mod --domain-resolution-order` configuration option. Also, it is now possible to use `use_fully_qualified_names=False` in a subdomain configuration, but please note that the user and group output from trusted domains will always be qualified to avoid conflicts.
  - Design page - [Shortnames in trusted domains](../../design_pages/shortnames.md)
- SSSD ships with a new service called KCM. This service acts as a storage for Kerberos tickets when `libkrb5` is configured to use `KCM:` in `krb5.conf`. Compared to other Kerberos credential cache types, KCM is better suited for containerized environments and because the credential caches are managed by a stateful daemon, in future releases will also allow to renew tickets acquired outside SSSD (e.g. with `kinit`) or provide notifications about ticket changes. This feature is optional and can be disabled by selecting `--without-kcm` when configuring the SSSD build.
  - Design page - [KCM server for SSSD](../../design_pages/kcm.md)
  - \`NOTE\`: There are several known issues in the `KCM` responder that will be handled in the next release such as [issues with very large tickets](https://github.com/SSSD/sssd/issues/4413) or [tracking the SELinux label of the peer](https://github.com/SSSD/sssd/issues/4461) or even one [intermittent crash](https://github.com/SSSD/sssd/issues/4481). There are also some differences between how SSSD's KCM server works compared to Heimdal's KCM server such as [visibility of ccaches by root](https://github.com/SSSD/sssd/issues/4405).
- Support for user and group resolution through the D-Bus interface and authentication and/or authorization through the PAM interface even for setups without UIDs or Windows SIDs present on the LDAP directory side. This enhancement allows SSSD to be used together with [apache modules](https://github.com/adelton/mod_lookup_identity) to provide identities for applications
  - Design page - [Support for non-POSIX users and groups](../../design_pages/non_posix_support.md)
- SSSD ships a new public library called `libsss_certmap` that allows a flexible and configurable way of mapping a certificate to a user identity. This is required e.g. in environments where it is not possible to add the certificate to the LDAP user entry, because the certificates are issued externally or the LDAP schema cannot be modified. Additionally, specific matching rules allow a specific certificate on a smart card to be selected for authentication.
  - Design page - [Matching and Mapping Certificates](../../design_pages/matching_and_mapping_certificates.md)
- The Kerberos locator plugin can be disabled using an environment variable `SSSD_KRB5_LOCATOR_DISABLE`. Please refer to the `sssd_krb5_locator_plugin` manual page for mode details.
- The `sssctl` command line tool supports a new command `user-checks` that enables the administrator to check whether a certain user should be allowed or denied access to a certain PAM service.
- The `secrets` responder now forwards requests to a proxy Custodia back end over a secure channel.

### Notable bug fixes

- The IPA HBAC evaluator no longer relies on `originalMemberOf` attributes to construct the list of groups the user is a member of. Maintaining the `originalMemberOf` attribute was unreliable and was causing intermittent HBAC issues.
- A bug where the cleanup operation might erroneously remove cached users during their cache validation in case SSSD was set up with `enumerate=True` was fixed.
- Several bugs related to configuration of trusted domains were fixed, in particular handling of custom LDAP search bases set for trusted domains.
- Password changes for users from trusted Active Directory domains were fixed

Packaging Changes
-----------------

- A new KCM responder was added along with a manpage. The upstream reference specfile packages the responder in its own subpackage called `sssd-kcm` and a krb5.conf snippet that enables the `KCM` credentials cache simply by installing the subpackage
- The `libsss_certmap` library was packaged in a separate package. There is also a `libsss_certmap-devel` subpackage in the upstream packaging.

Documentation Changes
---------------------

- `sssd-kcm` and `libsss_certmap` are documented in their own manual pages.
- A new option `domain_resolution_order` was added. This option allows to specify the lookup order (especially w.r.t. trusted domains) that sssd will follow. Please see the [Shortnames in trusted domains](../../design_pages/shortnames.md) design page. for mode details.
- New options `pam_app_services` and `domain_type` were added. These options can be used to only limit certain PAM services to reach certain SSSD domains that should only be exposed to non-OS applications. For more details, refer to the [Support for non-POSIX users and groups](../../design_pages/non_posix_support.md) design page.
>
- The `secrets` responder supports several new options related to TLS setup and handling including `verify_peer`, `verify_host`, `capath`, `cacert` and `cert`. These options are all described in the `sssd-secrets` manual page.

Tickets Fixed
-------------

- [\#4451](https://github.com/SSSD/sssd/issues/4451) - calling nspr_nss_setup/cleanup repeatedly in sss_encrypt SIGABRTs NSS eventually
- [\#4479](https://github.com/SSSD/sssd/issues/4479) - ad_account_can_shortcut: allow shortcut for unhandled IDs
- [\#4474](https://github.com/SSSD/sssd/issues/4474) - files provider should not use LOCAL_pam_handler but call the backend
- [\#4462](https://github.com/SSSD/sssd/issues/4462) - Create a function to copy search bases between sdap_domain structures
- [\#4458](https://github.com/SSSD/sssd/issues/4458) - Loading enterprise principals doesn't work with a primed cache
- [\#4453](https://github.com/SSSD/sssd/issues/4453) - IPA client cannot change AD Trusted User password
- [\#4445](https://github.com/SSSD/sssd/issues/4445) - Segfault in access_provider = krb5 is set in sssd.conf due to an off-by-one error when constructing the child send buffer
- [\#4437](https://github.com/SSSD/sssd/issues/4437) - python-sssdconfig doesn't parse hexadecimal debug_level, resulting in set_option(): /usr/lib/python2.7/site-packages/SSSDConfig/__init__.py killed by TypeError
- [\#4435](https://github.com/SSSD/sssd/issues/4435) - Accept changed principal if krb5_canonicalize=True
- [\#4431](https://github.com/SSSD/sssd/issues/4431) - man: Update option "ipa_server_mode=True" in "man sssd-ipa"
- [\#4430](https://github.com/SSSD/sssd/issues/4430) - SSSD doesn't handle conflicts between users from trusted domains with the same name when shortname user resolution is enabled
- [\#4425](https://github.com/SSSD/sssd/issues/4425) - MAN: The timeout option doesn't say after how many heartbeats will the process be killed
- [\#4424](https://github.com/SSSD/sssd/issues/4424) - ad provider: Child domains always use autodiscovered search bases
- [\#4420](https://github.com/SSSD/sssd/issues/4420) - sss_nss_getlistbycert() does not return results from multiple domains
- [\#4418](https://github.com/SSSD/sssd/issues/4418) - sss_override doesn't work with files provider
- [\#4416](https://github.com/SSSD/sssd/issues/4416) - subdomain_homedir is not present in cfg_rules.ini
- [\#4407](https://github.com/SSSD/sssd/issues/4407) - domain_to_basedn() function should use SDAP_SEARCH_BASE value from the domain code
- [\#4406](https://github.com/SSSD/sssd/issues/4406) - sssd-ad man page should clarify that GSSAPI is used
- [\#4404](https://github.com/SSSD/sssd/issues/4404) - minor typo fix that might have big impact
- [\#4391](https://github.com/SSSD/sssd/issues/4391) - sssd_be crashes if ad_enabled_domains is selected
- [\#4389](https://github.com/SSSD/sssd/issues/4389) - Allow to disable krb5 locator plugin selectively
- [\#4388](https://github.com/SSSD/sssd/issues/4388) - [abrt] [faf] sssd: vfprintf(): /usr/libexec/sssd/sssd_be killed by 11
- [\#4384](https://github.com/SSSD/sssd/issues/4384) - ifp: Users.FindByCertificate fails when certificate contains data before encapsilation boundary
- [\#4375](https://github.com/SSSD/sssd/issues/4375) - Include sssd-secrets in SEE ALSO section of sssd.conf man page
- [\#4374](https://github.com/SSSD/sssd/issues/4374) - Properly fall back to local Smartcard authentication
- [\#4371](https://github.com/SSSD/sssd/issues/4371) - The option enable_files_domain does not work if sssd is not compiled with --enable-files-domain
- [\#4370](https://github.com/SSSD/sssd/issues/4370) - sssd failed to start with missing /etc/sssd/sssd.conf if compiled without --enable-files-domain
- [\#4363](https://github.com/SSSD/sssd/issues/4363) - Issue processing ssh keys from certificates in ssh respoder
- [\#4475](https://github.com/SSSD/sssd/issues/4475) - Idle nss file descriptors should be closed
- [\#4455](https://github.com/SSSD/sssd/issues/4455) - getent failed to fetch netgroup information after changing default_domain_suffix to ADdomin in /etc/sssd/sssd.conf
- [\#4386](https://github.com/SSSD/sssd/issues/4386) - Config file validator doesn't process entries from application domain
- [\#4362](https://github.com/SSSD/sssd/issues/4362) - Wrong pam return code for user from subdomain with
- [\#4360](https://github.com/SSSD/sssd/issues/4360) - Wrong principal found with ad provider and long host name
- [\#4448](https://github.com/SSSD/sssd/issues/4448) - Wrong search base used when SSSD is directly connected to AD child domain
- [\#4433](https://github.com/SSSD/sssd/issues/4433) - sssd goes offline when renewing expired ticket
- [\#4421](https://github.com/SSSD/sssd/issues/4421) - LDAP to IPA migration doesn't work in master
- [\#4419](https://github.com/SSSD/sssd/issues/4419) - org.freedesktop.sssd.infopipe.GetUserGroups does not resolve groups into names with AD
- [\#4410](https://github.com/SSSD/sssd/issues/4410) - SSSD should use memberOf, not originalMemberOf to evaluate group membership for HBAC rules
- [\#4409](https://github.com/SSSD/sssd/issues/4409) - Per-subdomain LDAP filter is not applied for subsequent subdomains
- [\#4403](https://github.com/SSSD/sssd/issues/4403) - Infopipe method ListByCertificate does not return the users with overrides
- [\#4402](https://github.com/SSSD/sssd/issues/4402) - crash in sssd-kcm due to a race-condition between two concurrent requests
- [\#4399](https://github.com/SSSD/sssd/issues/4399) - ldap_purge_cache_timeout in RHEL7.3 invalidate most of the entries once the cleanup task kicks in
- [\#4392](https://github.com/SSSD/sssd/issues/4392) - fiter_users and filter_groups stop working properly in v 1.15
- [\#4381](https://github.com/SSSD/sssd/issues/4381) - User lookup failure due to search-base handling
- [\#4377](https://github.com/SSSD/sssd/issues/4377) - gpo_child fails when log is enabled in smb
- [\#4351](https://github.com/SSSD/sssd/issues/4351) - SSSD in server mode iterates over all domains for group-by-GID requests, causing unnecessary searches
- [\#4343](https://github.com/SSSD/sssd/issues/4343) - Support delivering non-POSIX users and groups through the IFP and PAM interfaces
- [\#4083](https://github.com/SSSD/sssd/issues/4083) - [RFE] Use one smartcard and certificate for authentication to distinct logon accounts
- [\#4042](https://github.com/SSSD/sssd/issues/4042) - [RFE] Short name input format with SSSD for users from all domains when domain autodiscovery is used or when SSSD acts as an IPA client for server with IPA-AD trusts
- [\#3928](https://github.com/SSSD/sssd/issues/3928) - [RFE] KCM ccache daemon in SSSD
- [\#4446](https://github.com/SSSD/sssd/issues/4446) - krb5: properly handle 'password expired' information retured by the KDC during PKINIT/Smartcard authentication
- [\#4434](https://github.com/SSSD/sssd/issues/4434) - IPA: do not lookup IPA users via extdom plugin
- [\#4432](https://github.com/SSSD/sssd/issues/4432) - Handle certmap errors gracefully during user lookups
- [\#4422](https://github.com/SSSD/sssd/issues/4422) - Properly support IPA's promptusername config option
- [\#4414](https://github.com/SSSD/sssd/issues/4414) - Dbus activate InfoPipe does not answer some initial request
- [\#4412](https://github.com/SSSD/sssd/issues/4412) - Smart card login fails if same cert mapped to IdM user and AD user
- [\#4385](https://github.com/SSSD/sssd/issues/4385) - application domain requires inherit_from and cannot be used separately
- [\#4358](https://github.com/SSSD/sssd/issues/4358) - expect sss_ssh_authorizedkeys and sss_ssh_knownhostsproxy manuals to be packaged into sssd-common package
- [\#4330](https://github.com/SSSD/sssd/issues/4330) - selinux_provider fails in a container if libsemanage is not available
- [\#4301](https://github.com/SSSD/sssd/issues/4301) - D-Bus GetUserGroups method of sssd is always qualifying all group names
- [\#4273](https://github.com/SSSD/sssd/issues/4273) - Smartcard authentication with UPN as logon name might fail
- [\#4243](https://github.com/SSSD/sssd/issues/4243) - [RFE] Read prioritized list of trusted domains for unqualified ID resolution from IDM server
- [\#4225](https://github.com/SSSD/sssd/issues/4225) - [sssd-secrets] https proxy talks plain http
- [\#4215](https://github.com/SSSD/sssd/issues/4215) - sssd does not refresh expired cache entries with enumerate=true
- [\#4098](https://github.com/SSSD/sssd/issues/4098) - sssctl: distinguish between autodiscovered and joined domains
- [\#3981](https://github.com/SSSD/sssd/issues/3981) - The member link is not removed when the last group's nested member goes away
- [\#3755](https://github.com/SSSD/sssd/issues/3755) - Add SSSD domain as property to user on D-Bus
- [\#2540](https://github.com/SSSD/sssd/issues/2540) - sss_ssh_knownhostsproxy prevents connection if the network is unreachable via one IP address
- [\#4361](https://github.com/SSSD/sssd/issues/4361) - sssctl config-check does not give any error when default configuration file is not present
- [\#4325](https://github.com/SSSD/sssd/issues/4325) - RFE: Create troubleshooting tool to check authentication, authorization and extended attribute lookup
- [\#4166](https://github.com/SSSD/sssd/issues/4166) - RFE to add option of check user access in SSSD

Detailed Changelog
------------------

- AmitKumar (2):

  - MAN: The timeout option doesn't say after how many heartbeats will the process be killed
  - MAN: Updating option ipa_server_mode in man sssd-ipa

- David Kupka (1):

  - libsss_certmap: Accept certificate with data before header

- Fabiano Fidêncio (40):

  - CACHE_REQ: Descend into subdomains on lookups
  - NSS/TESTS: Improve setup/teardown for subdomains tests
  - NSS/TESTS: Include searches for non-fqnames members of a subdomain
  - SYSDB: Add methods to deal with the domain's resolution order
  - SYSDB/TESTS: Add tests for the domain's resolution order methods
  - IPA: Get ipaDomainsResolutionOrder from ipaConfig
  - IPA_SUBDOMAINS: Rename _refresh_view() to _refresh_view_name()
  - IPA: Get ipaDomainsResolutionOrder from IPA ID View
  - DLINKLIST: Add DLIST_FOR_EACH_SAFE macro
  - CACHE_REQ: Make use of domainResolutionOrder
  - UTIL: Expose replace_char() as sss_replace_char()
  - Add domain_resolution_order config option
  - RESPONDER: Fallback to global domain resolution order in case the view doesn't have this option set
  - NSS/TESTS: Improve non-fqnames tests
  - CACHE_REQ: Allow configurationless shortname lookups
  - CACHE_REQ_DOMAIN: Add some comments to cache_req_domain_new_list_from_string_list()
  - RESPONDER_COMMON: Improve domaiN_resolution_order debug messages
  - CACHE_REQ_DOMAIN: debug the set domain resolution order
  - NSS: Fix typo inigroups -&gt; initgroups
  - LDAP: Remove duplicated debug message
  - CONTRIB: Force single-thread install to workaround concurrency issues
  - LDAP/AD: Do not fail in case rfc2307bis_nested_groups_recv() returns ENOENT
  - CACHE_REQ: Add a new cache_req_ncache_filter_fn() plugin function
  - CACHE_REQ_RESULT: Introduce cache_req_create_ldb_result_from_msg_list()
  - CACHE_REQ: Make use of cache_req_ncache_filter_fn()
  - CACHE_REQ: Avoid using of uninitialized value
  - CACHE_REQ: Ensure the domains are updated for "filter" related calls
  - CACHE_REQ: Simplify _search_ncache_filter()
  - CACHE_REQ_SEARCH: Check for filtered users/groups also on cache_req_send()
  - INTG_TESTS: Add one more test for filtered out users/groups
  - SYSDB: Return ERR_NO_TS when there's no timestamp cache present
  - SYSDB: Internally expose sysdb_search_ts_matches()
  - SYSDB: Make the usage of the filter more generic for search_ts_matches()
  - SYSDB_OPS: Mark an entry as expired also in the timestamp cache
  - SYSDB_OPS: Invalidate a cache entry also in the ts_cache
  - SYSDB: Introduce _`search()`{users,groups}_by_timestamp()
  - LDAP_ID_CLEANUP: Use `sysdb_search*()`_by_timestamp()
  - RESPONDER: Use fqnames as output when needed
  - DOMAIN: Add `sss_domain_info()`{get,set}_output_fqnames()
  - INTG/FILES_PROVIDER: Test user and group override

- Jakub Hrozek (70):

  - Updating the version for the 1.15.3 release
  - UTIL: iobuf: Make input parameter for the readonly operation const
  - UTIL: Fix a typo in the tcurl test tool
  - UTIL: Add SAFEALIGN_COPY_UINT8_CHECK
  - UTIL: Add utility macro cli_creds_get_gid()
  - UTIL: Add type-specific getsetters to sss_iobuf
  - UTIL: krb5 principal (un)marshalling
  - KCM: Initial responder build and packaging
  - KCM: request parsing and sending a reply
  - KCM: Implement an internal ccache storage and retrieval API
  - KCM: Add a in-memory credential storage
  - KCM: Implement KCM server operations
  - MAN: Add a manual page for sssd-kcm
  - TESTS: Add integration tests for the KCM responder
  - SECRETS: Create DB path before the operation itself
  - SECRETS: Return a nicer error message on request with no PUT data
  - SECRETS: Store ccaches in secrets for the KCM responder
  - TCURL: Support HTTP POST for creating containers
  - KCM: Store ccaches in secrets
  - KCM: Make the secrets ccache back end configurable, make secrets the default
  - KCM: Queue requests by the same UID
  - KCM: Idle-terminate the responder if the secrets back end is used
  - CONFDB: Introduce SSSD domain type to distinguish POSIX and application domains
  - CONFDB: Allow configuring [application] sections as non-POSIX domains
  - CACHE_REQ: Domain type selection in cache_req
  - IFP: Search both POSIX and non-POSIX domains
  - IFP: ListByName: Don't crash when no results are found
  - PAM: Remove unneeded memory context
  - PAM: Add application services
  - SYSDB: Allow storing non-POSIX users
  - SYSDB: Only generate new UID in local domain
  - LDAP: save non-POSIX users in application domains
  - LDAP: Relax search filters in application domains
  - KRB5: Authenticate users in a non-POSIX domain using a MEMORY ccache
  - KCM: Fix off-by-one error in secrets key parsing
  - Move sized_output_name() and sized_domain_name() into responder common code
  - IFP: Use sized_domain_name to format the groups the user is a member of
  - IPA: Improve DEBUG message if a group has no ipaNTSecurityIdentifier
  - LDAP: Allow passing a NULL map to sdap_search_bases_ex_send
  - IPA: Use search bases instead of domain_to_basedn when fetching external groups
  - CONFDB: Fix standalone application domains
  - AD: Make ad_account_can_shortcut() reusable by SSSD on an IPA server
  - KRB5: Advise the user to inspect the krb5_child.log if the child doesn't return a valid response
  - KCM: Fix the per-client serialization queue
  - TESTS: Add a test for parallel execution of klist
  - IPA: Avoid using uninitialized ret value when skipping entries from the joined domain
  - IPA: Return from function after marking a request as finished
  - HBAC: Do not rely on originalMemberOf, use the sysdb memberof links instead
  - test_kcm: Remove commented code
  - TESTS: Fix pep8 errors in test_kcm.py
  - TESTS: Fix pep8 errors in test_secrets.py
  - TESTS: Fix pep8 errors in test_ts_cache.py
  - RESP: Provide a reusable request to fully resolve incomplete groups
  - IFP: Only format the output name to the short version before output
  - IFP: Resolve group names from GIDs if required
  - KRB5: Fix access_provider=krb5
  - IFP: Fix error handling in ifp_user_get_attr_handle_reply()
  - IPA: Enable enterprise principals even if there are no changes to subdomains
  - README: Add a hint on how to submit bugs
  - README: Add social network links
  - Fix fedorahosted links in BUILD.txt
  - README.md: Point to our releases on pagure
  - RESPONDERS: Fix terminating idle connections
  - TESTS: Integration test for idle timeout
  - MAN: Document that client_idle_timeout can't be shorter than 10 seconds
  - CRYPTO: Do not call NSS_Shutdown after every operation
  - KRB5: Return invalid credentials internally when attempting to renew an expired TGT
  - KCM: Fix Description of sssd-kcm.socket
  - Remove the locale tag from zanata.xml
  - Updating translations for the 1.15.3 release

- Justin Stephenson (9):

  - IPA: Add s2n request to string function
  - IPA: Enhance debug logging for ipa s2n operations
  - IPA: Improve s2n debug message for missing ipaNTSecurityIdentifier
  - MAN: AD Provider GSSAPI clarification
  - DP: Reduce Data Provider log level noise
  - CONFIG: Add subdomain_homedir to config locations
  - SSSCTL: Add parent or trusted domain type
  - LDAP: Fix nesting level comparison
  - TESTS: Update zero nesting level test

- Lukas Slebodnik (57):

  - MAN: Mention sssd-secrets in "SEE ALSO" section
  - CONFIGURE: Fix fallback if pkg-config for uuid is missing
  - intg: fix configure failure with strict cflags
  - intg: Remove bashism from intgcheck-prepare
  - BUILD: Fix compilation of libsss_certmap with libcrypto
  - CONFDB: Fix handling of enable_files_domain
  - UTIL: Use max 15 characters for AD host UPN
  - SPEC: Drop conditional build for krb5_local_auth_plugin
  - README: Update links to mailing lists
  - SECRETS: remove unused variable
  - cache_req: Avoid bool in switch/case
  - SPEC: Update processing of translation in %install
  - SPEC: Move systemd service sssd-ifp.service to right package
  - SPEC: Add missing scriptlets for package sssd-dbus
  - SPEC: Use correct package for translated sssd-ifp man page
  - SPEC: Move man page for sss_rpcidmapd to the right package
  - SPEC: Use correct package for translated sss_ssh\* man pages
  - SPEC: Use correct package for translated sssctl man pages
  - SPEC: Use correct package for translated idmap_sss man pages
  - SPEC: Use correct package for translated sss_certmap man pages
  - SPEC: Use correct package for translated sssd-kcm man pages
  - SPEC: Move files provider files within package
  - SPEC: Move kcm scriptlets to systemd section
  - SPEC: Call ldconfig in libsss_certmap scriptlets
  - SPEC: Use macro python_provide conditionally
  - SPEC: Use %license macro
  - KCM: include missing header file
  - test_ldap.py: Add test for `filter()`{users,groups}
  - CONFDB: Use default configuration with missing sssd.conf
  - UTIL: Drop unused error code ERR_MISSING_CONF
  - INTG: Do not use configure time option enable-files-domain
  - BUILD: Link libwbclient with libdl
  - BUILD: Fix build without ssh
  - SSSDConfig: Handle integer parsing more leniently
  - SSSDConfig: Fix saving of debug_level
  - SECRETS: Fix warning Wpointer-bool-conversion
  - BUILD: Improve error messages for optional dependencies
  - VALIDATOR: prevent duplicite report from subdomain sections
  - test_config_check: Fix few issues
  - pam_sss: Fix checking of empty string cert_user
  - codegen: Remove util.h from generated files
  - UTIL: Remove few unused headed files
  - UTIL: Remove signal.h from util/util.h
  - UTIL: Remove signal.h from util/util.h
  - UTIL: Remove fcntl.h from util/util.h
  - Remove string{,s}.h
  - UTIL: Remove ctype.h from util/util.h
  - UTIL: Remove limits.h from util/util.h
  - Remove unnecessary sys/param.h
  - certmap: Remove unnecessary included files
  - cache_req: Do not use default_domain_suffix with netgroups
  - pam_sss: Fix leaking of memory in case of failures
  - CI: Do not use valgrind for dummy-child
  - Revert "CI: Use /bin/sh as a CONFIG SHELL"
  - Revert "LDAP: Fix nesting level comparison"
  - KCM: temporary increase hardcoded buffers
  - KCM: Modify krb5 snippet file kcm_default_ccache

- Michal Židek (20):

  - UTIL: Typo in comment
  - UTIL: Introduce subdomain_create_conf_path()
  - SUBDOMAINS: Allow use_fully_qualified_names for subdomains
  - selinux: Do not fail if SELinux is not managed
  - config-check: Message when sssd.conf is missing
  - SDAP: Fix handling of search bases
  - SERVER_MODE: Update sdap lists for each ad_ctx
  - AD: Add debug messages
  - AD SUBDOMAINS: Fix search bases for child domains
  - VALIDATORS: Add subdomain section
  - VALIDATORS: Remove application section domain
  - VALIDATORS: Escape special regex chars
  - TESTS: Add unit tests for cfg validation
  - MAN: Fix typo in trusted domain section
  - VALIDATORS: Change regex for app domains
  - VALIDATORS: Detect inherit_from in normal domain
  - TESTS: Add one config-check test case
  - GPO: Fix typo in DEBUG message
  - SDAP: Update parent sdap_list
  - SDAP: Add sdap_domain_copy_search_bases

- Nikolai Kondrashov (1):

  - NSS: Move output name formatting to utils

- Pavel Březina (22):

  - NSS/TESTS: Fix subdomains attribution
  - tcurl: add support for ssl and raw output
  - tcurl test: refactor so new options can be added more easily
  - tcurl test: add support for raw output
  - tcurl test: add support for tls settings
  - tcurl: add support for http basic auth
  - tcurl test: allow to set custom headers
  - tcurl test: add support for client certificate
  - ci: do not build secrets on rhel6
  - build: make curl required by secrets
  - secrets: use tcurl in proxy provider
  - secrets: remove http-parser code in proxy provider
  - secrets: allow to configure certificate check
  - secrets: support HTTP basic authentication with proxy provider
  - secrets: fix debug message
  - secrets: always add Content-Length header
  - sss_iobuf: fix 'read' shadows a global declaration
  - configure: fix typo
  - responders: do not leak selinux context on clients destruction
  - ipa_s2n_get_acct_info_send: provide correct req_input name
  - DP: Fix typo
  - IFP: Add domain and domainname attributes to the user

- René Genz (2):

  - minor typo fixes
  - Use correct spelling of override

- Simo Sorce (3):

  - ssh tools: The ai structure is not an array,
  - ssh tools: Fix issues with multiple IP addresses
  - ssh tools: Split connect and communication phases

- Sumit Bose (53):

  - split_on_separator: move to a separate file
  - util: move string_in_list to util_ext
  - certmap: add new library libsss_certmap
  - certmap: add placeholder for OpenSSL implementation
  - sysdb: add sysdb_attrs_copy()
  - sdap_get_users_send(): new argument mapped_attrs
  - LDAP: always store the certificate from the request
  - sss_cert_derb64_to_ldap_filter: add sss_certmap support
  - sysdb: add certmap related calls
  - IPA: add certmap support
  - nss-idmap: add sss_nss_getlistbycert()
  - nss: allow larger buffer for certificate based requests
  - ssh: handle binary keys correctly
  - ssh: add support for certificates from non-default views
  - krb5: return to responder that pkinit is not available
  - IPA: add mapped attributes to user from trusted domains
  - IPA: lookup AD users by certificates on IPA clients
  - IPA: enable AD user lookup by certificate
  - pam_test_client: add service and environment to PAM test client
  - pam_test_client: add SSSD getpwnam lookup
  - sss_sifp: update method names
  - pam_test_client: add InfoPipe user lookup
  - sssctl: integrate pam_test_client into sssctl
  - i18n: adding sssctl files
  - KRB5_LOCATOR: add env variable to disable plugin
  - sbus: check connection for NULL before unregister it
  - utils: add sss_domain_is_forest_root()
  - ad: handle forest root not listed in ad_enabled_domains
  - overrides: add certificates to mapped attribute
  - PAM: check matching certificates from all domains
  - sss_nss_getlistbycert: return results from multiple domains
  - cache_req: use the right negative cache for initgroups by upn
  - test: make sure p11_child is build for pam-srv-tests
  - pam: properly support UPN logon names
  - ipa: filter IPA users from extdom lookups by certificate
  - krb5: accept changed principal if krb5_canonicalize=True
  - ldap: handle certmap errors gracefully
  - RESPONDER_COMMON: update certmaps in responders
  - tests: fix test_pam_preauth_cert_no_logon_name()
  - pam_sss: add support for SSS_PAM_CERT_INFO_WITH_HINT
  - add_pam_cert_response: add support for SSS_PAM_CERT_INFO_WITH_HINT
  - PAM: send user name hint response when needed
  - sysdb: sysdb_get_certmap() allow empty certmap
  - sssctl: show user name used for authentication in user-checks
  - IPA: Fix the PAM error code that auth code expects to start migration
  - krb5: disable enterprise principals during password changes
  - krb5: use plain principal if password is expired
  - tests: update expired certificate
  - files: refresh override attributes after re-read
  - responders: update domain even for local and files provider
  - PAM: make sure the files provider uses the right auth provider
  - idmap_error_string: add missing descriptions
  - ad_account_can_shortcut: shortcut if ID is unknown

- Ville Skyttä (1):

  - SSSDConfig: Python 3.6 invalid escape sequence deprecation fix
