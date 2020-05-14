SSSD 1.16.1
===========

Highlights
----------

### New Features

- A new option `auto_private_groups` was added. If this option is enabled, SSSD will automatically create user private groups based on user's UID number. The GID number is ignored in this case. Please see <../../design_pages/auto_private_groups.mdfor more details on the feature.
- The SSSD smart card integration now supports a special type of PAM conversation implemented by GDM which allows the user to select the appropriate smrt card certificate in GDM. Please refer to <../../design_pages/smartcard_multiple_certificates.mdfor more details about this feature.
- A new API for accessing user and group information was added. This API is similar to the tradiional Name Service Switch API, but allows the consumer to talk to SSSD directly as well as to fine-tune the query with e.g. how cache should be evaluated. Please see <../../design_pages/enhanced_nss_api.mdfor more information on the new API.
- The `sssctl` command line tool gained a new command `access-report`, which can generate who can access the client machine. Currently only generating the report on an IPA client based on HBAC rules is supported. Please see <../../design_pages/attestation_report.mdfor more information about this new feature.
- The `hostid` provider was moved from the IPA specific code to the generic LDAP code. This allows SSH host keys to be access by the generic LDAP provider as well. See the `ldap_host_*` options in the `sssd-ldap` manual page for more details.
- Setting the `memcache_timeout` option to 0 disabled creating the memory cache files altogether. This can be useful in cases there is a bug in the memory cache that needs working around.

### Performance enhancements

- Several internal changes to how objects are stored in the cache improve SSSD performance in environments with large number of objects of the same type (e.g. many users, many groups). In particular, several useless indexes were removed and the most common object types no longer use the indexed `objectClass` attribute, but use unindexed `objectCategory` instead (\#3503)
- In setups with `id_provider=ad` that use POSIX attributes which are replicated to the Global Catalog, SSSD uses the Global Catalog to determine which domain should be contacted for a by-ID lookup instead of iterating over all domains. More details about this feature can be found at <../../design_pages/uid_negative_global_catalog.md>

### Notable bug fixes

- A crash in `sssd_nss` that might have happened if a list of domains was refreshed while a NSS lookup using this request was fixed (\#3551)
- A potential crash in `sssd_nss` during netgroup lookup in case the netgroup object kept in memory was already freed (\#3523)
- Fixed a potential crash of `sssd_be` with two concurrent sudo refreshes in case one of them failed (\#3562)
- A memory growth issue in `sssd_nss` that occured when an entry was removed from the memory cache was fixed (\#3588)
- Two potential memory growth issues in the `sssd_be` process that could have hit configurations with `id_provider=ad` were fixed (\#3639)
- The `selinux_child` process no longer crashes on a system where SSSD is compiled with SELinux support, but at the same time, the SELinux policy is not even installed on the machine (\#3618)
- The memory cache consistency detection logic was fixed. This would prevent printing false positive memory cache corruption messages (\#3571)
- SSSD now remembers the last successfuly discovered AD site and use this for DNS search to lookup a site and forest during the next lookup. This prevents time outs in case SSSD was discovering the site using the global list of DCs where some of the global DCs might be unreachable. (\#3265)
- SSSD no longer starts the implicit file domain when configured with `id_provider=proxy` and `proxy_lib_name=files`. This bug prevented SSSD from being used in setups that combine identities from UNIX files together with authentication against a remote source unless a files domain was explicitly configured (\#3590)
- The IPA provider can handle switching between different ID views better (\#3579)
- Previously, the IPA provider kept SSH public keys and certificates from an ID view in its cache and returned them even if the public key or certificate was then removed from the override (\#3602, \#3603)
- FleetCommander profiles coming from IPA are applied even if they are assigned globally (to `category: ALL`), previously, only profiles assigned to a host or a hostgroup were applied (\#3449)
- It is now possible to reset an expired password for users with 2FA authentication enabled (\#3585)
- A bug in the AD provider which could have resulted in built-in AD groups being incorrectly cached was fixed (\#3610)
- The SSSD watchdog can now cope better with time drifts (\#3285)
- The `nss_sss` NSS module's return codes for invalid cases were fixed
- A bug in the LDAP provider that prevented setups with id_provider=proxy and auth_provider=ldap with LDAP servers that do not allow anonymous binds from working was fixed (\#3451)

Packaging Changes
-----------------

- The FleetCommander desktop profile path now uses stricter permissions, 751 instead of 755 (\#3621)
- A new option `--logger` was added to the `sssd(8)` binary. This option obsoletes old options such as `--debug-to-files`, although the old options are kept for backwards compatibility.
- The file `/etc/systemd/system/sssd.service.d/journal.conf` is not installed anymore In order to change logging to journald, please use the `--logger` option. The logger is set using the `Environment=DEBUG_LOGGER` directive in the systemd unit files. The default value is `Environment=DEBUG_LOGGER=--logger=files`

Documentation Changes
---------------------

There are no notable documentation changes such as options changing default values etc in this release.

Tickets Fixed
-------------

- [\#4668](https://github.com/SSSD/sssd/issues/4668) - Mention in the manpages that Fleet Commander does *not* work when SSSD is running as the unprivileged user
- [\#4660](https://github.com/SSSD/sssd/issues/4660) - sssd_be consumes more memory on RHEL 7.4 systems.
- [\#4648](https://github.com/SSSD/sssd/issues/4648) - MAN: Explain how does auto_private_groups affect subdomains
- [\#4642](https://github.com/SSSD/sssd/issues/4642) - FleetCommander integration must not require capability DAC_OVERRIDE
- [\#4639](https://github.com/SSSD/sssd/issues/4639) - selinux_child segfaults in a docker container
- [\#4636](https://github.com/SSSD/sssd/issues/4636) - Requesting an AD user's private group and then the user itself returns an emty homedir
- [\#4634](https://github.com/SSSD/sssd/issues/4634) - auto_private_groups does not work with trusted domains with direct AD integration
- [\#4632](https://github.com/SSSD/sssd/issues/4632) - AD provider - AD BUILTIN groups are cached with gidNumber = 0
- [\#4631](https://github.com/SSSD/sssd/issues/4631) - dbus-send unable to find user by CAC cert
- [\#4626](https://github.com/SSSD/sssd/issues/4626) - Certificate is not removed from cache when it's removed from the override
- [\#4625](https://github.com/SSSD/sssd/issues/4625) - SSH public key authentication keeps working after keys are removed from ID view
- [\#4624](https://github.com/SSSD/sssd/issues/4624) - race condition: sssd_be in a one-way trust accepts request before ipa-getkeytab finishes, marking the sssd offline
- [\#4622](https://github.com/SSSD/sssd/issues/4622) - getent output is not showing home directory for IPA AD trusted user
- [\#4617](https://github.com/SSSD/sssd/issues/4617) - sssd used wrong search base with wrong AD server
- [\#4615](https://github.com/SSSD/sssd/issues/4615) - Write a regression test for false possitive "corrupted" memory cache
- [\#4613](https://github.com/SSSD/sssd/issues/4613) - proxy to files does not work with implicit_files_domain
- [\#4612](https://github.com/SSSD/sssd/issues/4612) - sssd_nss consumes more memory until restarted or machine swaps
- [\#4610](https://github.com/SSSD/sssd/issues/4610) - Give a more detailed debug and system-log message if krb5_init_context() failed
- [\#4609](https://github.com/SSSD/sssd/issues/4609) - Reset password with two factor authentication fails
- [\#4603](https://github.com/SSSD/sssd/issues/4603) - SSSD fails to fetch group information after switching IPA client to a non-default view
- [\#4595](https://github.com/SSSD/sssd/issues/4595) - mmap cache: consistency check might fail if there are hash collisions
- [\#4594](https://github.com/SSSD/sssd/issues/4594) - The cache-req debug string representation uses a wrong format specifier for by-ID requests
- [\#4593](https://github.com/SSSD/sssd/issues/4593) - The cache_req code doesn't check the min_id/max_id boundaries for requests by ID
- [\#4588](https://github.com/SSSD/sssd/issues/4588) - Smartcard authentication fails if SSSD is offline and 'krb5_store_password_if_offline = True'
- [\#4587](https://github.com/SSSD/sssd/issues/4587) - Some sysdb tests fail because they expect a certain order of entries returned from ldb
- [\#4586](https://github.com/SSSD/sssd/issues/4586) - Use-after free if more sudo requests run and one of them fails, causing a fail-over to a next server
- [\#4585](https://github.com/SSSD/sssd/issues/4585) - Improve Smartcard integration if multiple certificates or multiple mapped identities are available
- [\#4577](https://github.com/SSSD/sssd/issues/4577) - Race condition between refreshing the cr_domain list and a request that is using the list can cause a segfault is sssd_nss
- [\#4573](https://github.com/SSSD/sssd/issues/4573) - data from ipa returned with id_provider=file
- [\#4571](https://github.com/SSSD/sssd/issues/4571) - SSSD creates bad override search filter due to AD Trust object with parenthesis
- [\#4565](https://github.com/SSSD/sssd/issues/4565) - Do not autostart the implicit files domain if sssd configures id_provider=proxy and proxy_target_files
- [\#4555](https://github.com/SSSD/sssd/issues/4555) - SSSD-kcm/secrets failed to restart during/after upgrade
- [\#4554](https://github.com/SSSD/sssd/issues/4554) - sssd refuses to start when pidfile is present, but the process is gone
- [\#4549](https://github.com/SSSD/sssd/issues/4549) - ABRT crash - /usr/libexec/sssd/sssd_nss in setnetgrent_result_timeout
- [\#4529](https://github.com/SSSD/sssd/issues/4529) - Do not index objectclass, add and index objectcategory instead
- [\#4522](https://github.com/SSSD/sssd/issues/4522) - [RFE] Add a configuration option to SSSD to disable the memory cache
- [\#4512](https://github.com/SSSD/sssd/issues/4512) - Improve `enumerate` documentation/troubleshooting guide
- [\#4510](https://github.com/SSSD/sssd/issues/4510) - MAN: Describe the constrains of ipa_server_mode better in the man page
- [\#4494](https://github.com/SSSD/sssd/issues/4494) - SSSD doesn't use AD global catalog for gidnumber lookup, resulting in unacceptable delay for large forests
- [\#4481](https://github.com/SSSD/sssd/issues/4481) - sssd-kcm crashes with multiple parallel requests
- [\#4478](https://github.com/SSSD/sssd/issues/4478) - When sssd is configured with id_provider proxy and auth_provider ldap, login fails if the LDAP server is not allowing anonymous binds.
- [\#4471](https://github.com/SSSD/sssd/issues/4471) - document information on why SSSD does not use host-based security filtering when processing AD GPOs
- [\#4460](https://github.com/SSSD/sssd/issues/4460) - SYSLOG_IDENTIFIER is different
- [\#4326](https://github.com/SSSD/sssd/issues/4326) - Log when SSSD authentication fails because when two IPA accounts share an email address
- [\#4318](https://github.com/SSSD/sssd/issues/4318) - SSSD needs restart after incorrect clock is corrected with AD
- [\#4298](https://github.com/SSSD/sssd/issues/4298) - [RFE] sssd should remember DNS sites from first search
- [\#4231](https://github.com/SSSD/sssd/issues/4231) - Incorrect error code returned from krb5_child for expired/locked user with id_provider AD
- [\#4017](https://github.com/SSSD/sssd/issues/4017) - sdap code can mark the whole sssd_be offline
- [\#3881](https://github.com/SSSD/sssd/issues/3881) - [RFE] Produce access control attestation report for IPA domains
- [\#3864](https://github.com/SSSD/sssd/issues/3864) - Integration tests: Use dbus-daemon in cwrap enviroment for test
- `2478](https://github.com/SSSD/sssd/issues/3520) - Provide [sss_nss*()` API to directly query SSSD instead of nsswitch.conf route
- [\#2914](https://github.com/SSSD/sssd/issues/2914) - [RFE] Support User Private Groups for main domains, too
- [\#2771](https://github.com/SSSD/sssd/issues/2771) - Enumerating large number of users makes sssd_be hog the cpu for a long time.

Detailed Changelog
------------------

- Andreas Schneider (1):

  - Avoid double semicolon warnings on older compilers

- Carlos O'Donell (1):

  - nss: Fix invalid enum nss_status return values.

- Fabiano Fidêncio (21):

  - CACHE_REQ: Copy the cr_domain list for each request
  - LDAP: Bind to the LDAP server also in the auth
  - TOOLS: Double quote array expansions in sss_debuglevel
  - TOOLS: Call "exec" for sss_debuglevel
  - LDAP: Improve error treatment from sdap_cli_connect() in ldap_auth
  - SYSDB: Remove code causing a covscan warning
  - NSS: Fix covscan warning
  - CACHE_REQ: Fix typo: cache_reg -&gt; cache_req
  - TOOLS: Fix typo: exist -&gt; exists
  - SYSDB: Return EOK in case a non-fatal issue happened
  - SYSDB_VIEWS: Remove sshPublicKey attribute when it's not set
  - IPA: Remove sshPublicKey attribute when it's not set
  - DESKPROFILE: Add checks for user and host category
  - DESKPROFILE: Harden the permission of deskprofilepath
  - DESKPROFILE: Soften umask for the domain's dir
  - DESKPROFILE: Fix the permissions and soften the umask for user's dir
  - DESKPROFILE: Use seteuid()/setegid() to create the profile
  - DESKPROFILE: Use seteuid()/setegid() to delete the profile/user's dir
  - DESKPROFILE: Set the profile permissions to read-only
  - PYSSS_MURMUR: Fix [-Wsign-compare] found by gcc
  - DESKPROFILE: Document it doesn't work when run as unprivileged user

- Hristo Venev (1):

  - providers: Move hostid from ipa to sdap, v2

- Jakub Hrozek (35):

  - Update the version number to track 1.16.1 development
  - CONFIG: Add a new option auto_private_groups
  - CONFDB: Remove the obsolete option magic_private_groups
  - SDAP: Allow the mpg flag for the main domain
  - LDAP: Turn group request into user request for MPG domains if needed
  - SYSDB: Prevent users and groups ID collision in MPG domains except for id_provider=local
  - TESTS: Add integration tests for the auto_private_groups option
  - RESP: Add some missing NULL checks
  - TOOLS: Add a new sssctl command access-report
  - SDAP: Split out utility function sdap_get_object_domain() from sdap_object_in_domain()
  - LDAP: Extract the check whether to run a POSIX check to a function
  - LDAP: Only run the POSIX check with a GC connection
  - SDAP: Search with a NULL search base when looking up an ID in the Global Catalog
  - SDAP: Rename sdap_posix_check to sdap_gc_posix_check
  - DP: Create a new handler function getAccountDomain()
  - AD: Implement a real getAccountDomain handler for the AD provider
  - RESP: Expose DP method getAccountDomain() to responders
  - NEGCACHE: Add API for setting and checking locate-account-domain requests
  - TESTS: Add tests for the object-by-id cache_req interface
  - CACHE_REQ: Export cache_req_search_ncache_add() as cache_req private interface
  - CACHE_REQ: Add plugin methods required for the domain-locator request
  - CACHE_REQ: Add a private request cache_req_locate_domain()
  - CACHE_REQ: Implement the plugin methods that utilize the domain locator API
  - CACHE_REQ: Use the domain-locator request to only search domains where the entry was found
  - MAN: Document how the Global Catalog is used currently
  - IPA: Include SYSDB_OBJECTCATEGORY, not OBJECTCLASS in cache search results
  - MAN: Document that auth and access IPA and AD providers rely on id_provider being set to the same type
  - MAN: Improve enumeration documentation
  - MAN: Describe the constrains of ipa_server_mode better in the man page
  - IPA: Delay the first periodic refresh of trusted domains
  - AD: Inherit the MPG setting from the main domain
  - SYSDB: Fix sysdb_search_by_name() for looking up groups in MPG domains
  - SYSDB: Use sysdb_domain_dn instead of raw ldb_dn_new_fmt
  - SYSDB: Read the ldb_message from loop's index counter when reading subdomain UPNs
  - AD: Use the right sdap_domain for the forest root

- Lukas Slebodnik (51):

  - KCM: Fix typo in comments
  - CI: Ignore source file generated by systemtap
  - UTIL: Add wrapper function to configure logger
  - Add parameter --logger to daemons
  - SYSTEMD: Replace parameter --debug-to-files with ${DEBUG_LOGGER}
  - SYSTEMD: Add environment file to responder service files
  - UTIL: Hide and deprecate parameter --debug-to-files
  - KCM: Fix restart during/after upgrade
  - BUILD: Properly expand variables in sssd-ifp.service
  - SYSTEMD: Clean pid file in corner cases
  - CHILD: Pass information about logger to children
  - BUILD: Disable tests with know failures
  - SPEC: Reduce build time dependencies
  - sysdb-test: Fix warning may be used uninitialized
  - responder: Fix talloc hierarchy in sized_output_name
  - test_responder: Check memory leak in sized_output_name
  - confdb: Move detection files to separate function
  - confdb: Fix starting of implicit files domain
  - confdb: Do not start implicit_files with proxy domain
  - test_files_provider: Regression test for implicit_files + proxy
  - SDAP: Fix typo in debug message
  - Revert "intg: Disable add_remove tests"
  - libnfsidmap: Use public plugin header file if available
  - dyndns_tests: Fix unit test with missing features in nsupdate
  - Remove unnecessary script for upgrading debug_levels
  - Remove legacy script for upgrading sssd.conf
  - BUILD: Add missing libs found by -Wl,-z,defs
  - BUILD: Fix using of libdlopen_test_providers.so in tests
  - SYSDB: Decrese debuglevel in sysdb_get_certmap
  - KRB5: Pass special flag to krb5_child
  - krb5_child: Distinguish between expired & disabled AD user
  - AD: Suppress warning Wincompatible-pointer-types with sasl callbacks
  - pysss: Drop unused parameter
  - pysss: Suppress warning Wincompatible-pointer-types
  - CRYPTO: Suppress warning Wstringop-truncation
  - INOTIFY: Fix warning Wstringop-truncation
  - SIFP: Suppress warning Wstringop-truncation
  - CLIENT: Fix warning Wstringop-overflow
  - pysss_murmur: Allow to have NUL character in python bindings
  - TESTS: Extend code coverage for murmurhash3
  - mmap_cache: Remove unnecessary memchr in client code
  - test_memory_cache: Regression test for \#3571
  - SPEC: Fix systemd executions/requirements
  - SPEC: Reduce changes between upstream and downstream
  - intg: Build with optimisations and debug symbols
  - intg: Do not prefer builddir in PATH
  - intg: Install configuration for dbus daemon
  - intg: Install wrapper for getsockopt
  - intg: Add sample infopipe test in cwrap env
  - IPA: Drop unused ifdef HAVE_SELINUX_LOGIN_DIR
  - IPA: Fix typo in debug message in sssm_ipa_selinux_init

- Michal Židek (9):

  - NSS: Move memcache setup to separate function
  - NSS: Specify memcache_timeout=0 semantics
  - MAN: Document memcache_timeout=0 meaning
  - MAN: GPO Security Filtering limitation
  - SYSDB: Better debugging for email conflicts
  - TESTS: Order list of entries in some lists
  - Revert "BUILD: Disable tests with know failures"
  - SELINUX: Check if SELinux is managed in selinux_child
  - util: Add sss_ prefix to some functions

- Niranjan M.R (1):

  - Initial revision of sssd pytest framework

- Pavel Březina (10):

  - sudo: document background activity
  - sudo: always use srv_opts from id context
  - AD: Remember last site discovered
  - sysdb: add functions to get/set client site
  - AD: Remember last site discovered in sysdb
  - dp: use void \* to express empty output argument list
  - dp: add method to refresh access control rules
  - ipa: implement method to refresh HBAC rules
  - ifp: add method to refresh access control rules in domain
  - sssctl: call dbus instead of pam to refresh HBAC rules

- René Genz (12):

  - Fix minor spelling mistakes
  - README: Add link to docs repo
  - Fix minor spelling mistakes
  - Fix minor spelling mistakes in providers/\*
  - Fix minor spelling mistakes in responder/\*
  - Fix minor spelling mistakes in sss_client/\*
  - Fix minor spelling mistakes in tests/cmocka/\*
  - Fix minor spelling mistakes
  - Fix minor spelling mistakes in tests/\*
  - Fix minor spelling mistakes in tests/multihost/\*
  - Fix minor spelling mistakes in PY files in tests/python/\*
  - Fix minor spelling mistakes and formatting in tests/python/\*

- Sumit Bose (48):

  - sss_client: create nss_common.h
  - nss-idmap: add nss like calls with timeout and flags
  - NSS: add \*_EX version of some requests
  - NSS: add support for SSS_NSS_EX_FLAG_NO_CACHE
  - CACHE_REQ: Add cache_req_data_set_bypass_dp()
  - nss: make memcache_delete_entry() public
  - NSS: add support for SSS_NSS_EX_FLAG_INVALIDATE_CACHE
  - NSS/TESTS: add unit tests for \*_EX requests
  - nss-idmap: add timeout version of old `sss_nss*()` calls
  - nss-idmap: allow empty buffer with SSS_NSS_EX_FLAG_INVALIDATE_CACHE
  - p11_child: return multiple certs
  - PAM: handled multiple certs in the responder
  - pam_sss: refactoring, use struct cert_auth_info
  - p11_child: use options to select certificate for authentication
  - pam: add prompt string for certificate authentication
  - PAM: allow missing logon_name during certificate authentication
  - p11_child: add descriptions for error codes to debug messages
  - pam: filter certificates in the responder not in the child
  - PAM: add certificate's label to the selection prompt
  - NSS: Use enum_ctx as memory_context in _setnetgrent_set_timeout()
  - mmap_cache: make checks independent of input size
  - sysdb: be_refresh_get_values_ex() remove unused option
  - sysdb: do not use objectClass for users and groups
  - sysdb: do not use LDB_SCOPE_ONELEVEL
  - sysdb: remove IDXONE and objectClass from users and groups
  - krb5: show error message for krb5_init_context() failures
  - UTIL: add find_domain_by_object_name_ex()
  - ipa: handle users from different domains in ipa_resolve_user_list_send()
  - overrides: fixes for sysdb_invalidate_overrides()
  - ipa: check for SYSDB_OVERRIDE_DN in process_members and get_group_dn_list
  - IPA: use cache searches in get_groups_dns()
  - ipa: compare DNs instead of group names in ipa_s2n_save_objects()
  - p11_child: make sure OCSP checks are done
  - nss-idmap: allow NULL result in \*_timeout calls
  - Revert "p11_child: make sure OCSP checks are done"
  - p11_child: properly check results of CERT_VerifyCertificateNow
  - ifp: use realloc in ifp_list_ctx_remaining_capacity()
  - SDAP: skip builtin AD groups in sdap_save_grpmem()
  - sysdb: add userMappedCertificate to the index
  - krb5_child: check preauth types if password is expired
  - pam_sss: password change with two factor authentication
  - nss-idmap: check timed muted return code
  - krb5: call krb5_auth_cache_creds() if a password is available
  - DESKPROFILE: Fix 'Improper use of negative value'
  - AD: sdap_get_ad_tokengroups_done() allocate temporary data on state
  - AD: do not allocate temporary data on long living context
  - ipa: remove SYSDB_USER_CERT from sub-domain users
  - ipa: add SYSDB_USER_MAPPED_CERT for certs in idoverrides

- Thorsten Scherf (1):

  - IPA: Fixed subdomain typo

- Victor Tapia (1):

  - WATCHDOG: Restart providers with SIGUSR2 after time drift

- amitkuma (3):

  - cache_req: Correction of cache_req debug string ID format
  - cache: Check for max_id/min_id in cache_req
  - MAN: Explain how does auto_private_groups affect subdomains
