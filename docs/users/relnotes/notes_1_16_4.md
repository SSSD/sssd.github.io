SSSD 1.16.4
===========

Highlights
----------

### New Features

- The list of PAM services which are allowed to authenticate using a Smart Card is now configurable using a new option `pam_p11_allowed_services`. (\#2926)
- A new configuration option `ad_gpo_implicit_deny` was added. This option (when set to True) can be used to deny access to users even if there is not applicable GPO. Normally users are allowed access in this situation. (\#3701)
- The LDAP authentication provider now allows to use a different method of changing LDAP passwords using a modify operation in addition to the default extended operation. This is meant to support old LDAP servers that do not implement the extended operation. The password change using the modification operation can be selected with `ldap_pwmodify_mode = "ldap_modify"` (\#1314)
- The `auto_private_groups` configuration option now takes a new value `hybrid`. This mode autogenerates private groups for user entries where the UID and GID values have the same value and at the same time the GID value does not correspond to a real group entry in LDAP (\#3822)

### Security issues fixed

- CVE-2019-3811: SSSD used to return "/" in case a user entry had no home directory. This was deemed a security issue because this flaw could impact services that restrict the user's filesystem access to within their home directory. An empty home directory field would indicate "no filesystem access", where sssd reporting it as "/" would grant full access (though still confined by unix permissions, SELinux etc).

### Notable bug fixes

- The IPA provider, in a setup with a trusted Active Directory domain, did not remove cached entries that were no longer present on the AD side (\#3984)
- The Active Directory provider now fetches the user information from the LDAP port and switches to using the Global Catalog port, if available for the group membership. This fixes an issue where some attributes which are not available in the Global Catalog, typically the home directory, would be removed from the user entry. (\#2474)
- The IPA SELinux provider now sets the user login context even if it is the same as the system default. This is important in case the user has a non-standard home directory, because then only adding the user to the SELinux database ensures the home directory will be labeled properly. However, this fix causes a performance hit during the first login as the context must be written into the semanage database.
- The sudo responder did not reflect the case_sensitive domain option (\#3820)
- A memory leak when requesting netgroups repeatedly was fixed (\#3870)
- An issue that caused SSSD to sometimes switch to offline mode in case not all domains in the forest ran the Global Catalog service was fixed (\#3902)
- The SSH responder no longer fails completely if the `p11_child` times out when deriving SSH keys from a certificate (\#3937)
- The negative cache was not reloaded after new sub domains were discovered which could have lead to a high SSSD load (\#3683)
- The negative cache did not work properly for in case a lookup fell back to trying a UPN instead of a name (\#3978)
- If any of the SSSD responders was too busy, that responder wouldn't have refreshed the trusted domain list (\#3967)
- A potential crash due to a race condition between the fail over code refreshing a SRV lookup and back end using its results (\#3976)
- Sudo's runAsUser and runAsGroup attributes did not match properly when used in setups with domain_resolution_order
- Processing of the values from the `filter_users` or `filter_groups` options could trigger calls to blocking NSS API functions which could in turn prevent the startup of SSSD services in case nsswitch.conf contained other modules than `sss` or `files` (\#3963)

Tickets Fixed
-------------

- [\#4940](https://github.com/SSSD/sssd/issues/4940) - NSS responder does no refresh domain list when busy
- [\#3967](https://github.com/SSSD/sssd/issues/3967) - Make list of local PAM services allowed for Smartcard authentication configurable
- [\#4813](https://github.com/SSSD/sssd/issues/4813) - sssd only sets the SELinux login context if it differs from the default
- [\#4814](https://github.com/SSSD/sssd/issues/4814) - sudo: search with lower cased name for case insensitive domains
- [\#4860](https://github.com/SSSD/sssd/issues/4860) - nss: memory leak in netgroups
- [\#4478](https://github.com/SSSD/sssd/issues/4478) - When sssd is configured with id_provider proxy and auth_provider ldap, login fails if the LDAP server is not allowing anonymous binds.
- [\#4865](https://github.com/SSSD/sssd/issues/4865) - CURLE_SSL_CACERT is deprecated in recent curl versions
- [\#4887](https://github.com/SSSD/sssd/issues/4887) - SSSD must be cleared/restarted periodically in order to retrieve AD users through IPA Trust
- [\#4886](https://github.com/SSSD/sssd/issues/4886) - sssd returns '/' for emtpy home directories
- [\#4904](https://github.com/SSSD/sssd/issues/4904) - sss_cache prints spurious error messages when invoked from shadow-utils on package install
- [\#4839](https://github.com/SSSD/sssd/issues/4839) - The config file validator says that certmap options are not allowed
- [\#4917](https://github.com/SSSD/sssd/issues/4917) - If p11_child spawned from sssd_ssh times out, sssd_ssh fails completely
- [\#4934](https://github.com/SSSD/sssd/issues/4934) - sssd config-check reports an error for a valid configuration option
- [\#4715](https://github.com/SSSD/sssd/issues/4715) - [RFE] Allow changing default behavior of SSSD from an allow-any default to a deny-any default when it can't find any GPOs to apply to a user login.
- [\#3516](https://github.com/SSSD/sssd/issues/3516) - AD: do not override existing home-dir or shell if they are not available in the global catalog
- [\#4932](https://github.com/SSSD/sssd/issues/4932) - sssd_krb5_locator_plugin introduces delay in cifs.upcall krb5 calls
- [\#4876](https://github.com/SSSD/sssd/issues/4876) - SSSD changes the memory cache file ownership away from the SSSD user when running as root
- [\#4920](https://github.com/SSSD/sssd/issues/4920) - RemovedInPytest4Warning: Fixture "passwd_ops_setup" called directly
- [\#4309](https://github.com/SSSD/sssd/issues/4309) - Revert workaround in CI for bug in python-{request,urllib3}
- [\#4950](https://github.com/SSSD/sssd/issues/4950) - UPN negative cache does not use values from 'filter_users' config option
- [\#4955](https://github.com/SSSD/sssd/issues/4955) - filter_users option is not applied to sub-domains if SSSD starts offline
- [\#4925](https://github.com/SSSD/sssd/issues/4925) - SSSD netgroups do not honor entry_cache_nowait_percentage
- [\#4956](https://github.com/SSSD/sssd/issues/4956) - IPA: Deleted user from trusted domain is not removed properly from the cache on IPA clients
- [\#4949](https://github.com/SSSD/sssd/issues/4949) - crash in dp_failover_active_server
- [\#4931](https://github.com/SSSD/sssd/issues/4931) - sudo: runAsUser/Group does not work with domain_resolution_order
- [\#2356](https://github.com/SSSD/sssd/issues/2356) - RFE Request for allowing password changes using SSSD in DS which dont follow OID's from RFC 3062
- [\#4816](https://github.com/SSSD/sssd/issues/4816) - Enable generating user private groups only for users with no primary GID
- [\#4936](https://github.com/SSSD/sssd/issues/4936) - Responders: processing of `filter_users</span>/<span class="title-ref">filter_groups` should avoid calling blocking NSS API

Packaging Changes
-----------------

- Several files in the reference specfile changed permissions to avoid issues with verifying the file integrity with `rpm -V` in case SSSD runs as a different user than the default user it is configured with (\#3890)

Documentation Changes
---------------------

- The AD provider default value of `fallback_homedir` was changed to `fallback_homedir = /home/%d/%u` to provide home directories for users without the `homeDirectory` attribute.
- A new option `ad_gpo_implicit_deny`, defaulting to False (\#3701)
- A new option `ldap_pwmodify_mode` (\#1314)
- A new option `pam_p11_allowed_services` (\#2926)
- The `auto_private_groups` accepts a new option value `hybrid` (\#3822)
- Improved documentation of the Kerberos locator plugin

Detailed Changelog
------------------

- Alexey Tikhonov (5):

  - Fix error in hostname retrieval
  - lib/cifs_idmap_sss: fixed unaligned mem access
  - ci/sssd.supp: fixed c-ares-suppress-leak-from-init
  - negcache: avoid "`is*()`_local" calls in some cases
  - Monitor: changed provider startup timeout

- Fabiano Fidêncio (1):

  - man/sss_ssh_knownhostsproxy: fix typo pubkeys -&gt; pubkey

- Jakub Hrozek (54):

  - Updating the version to track 1.16.4 development
  - src/tests/python-test.py is GPLv3+
  - src/tests/intg/util.py is licensed under GPLv3+
  - src/tests/intg/test_ts_cache.py is licensed under GPLv3+
  - src/tests/intg/test_sudo.py is licensed under GPLv3+
  - src/tests/intg/test_sssctl.py is licensed under GPLv3+
  - src/tests/intg/test_ssh_pubkey.py is licensed under GPLv3+
  - src/tests/intg/test_session_recording.py is licensed under GPLv3+
  - src/tests/intg/test_secrets.py is licensed under GPLv3+
  - src/tests/intg/test_pysss_nss_idmap.py is licensed under GPLv3+
  - src/tests/intg/test_pam_responder.py is licensed under GPLv3+
  - src/tests/intg/test_pac_responder.py is licensed under GPLv3+
  - src/tests/intg/test_netgroup.py is licensed under GPLv3+
  - src/tests/intg/test_memory_cache.py is licensed under GPLv3+
  - src/tests/intg/test_local_domain.py is licensed under GPLv3+
  - src/tests/intg/test_ldap.py is licensed under GPLv3+
  - src/tests/intg/test_kcm.py is licensed under GPLv3+
  - src/tests/intg/test_infopipe.py is licensed under GPLv3+
  - src/tests/intg/test_files_provider.py is licensed under GPLv3+
  - src/tests/intg/test_files_ops.py is licensed under GPLv3+
  - src/tests/intg/test_enumeration.py is licensed under GPLv3+
  - src/tests/intg/sssd_passwd.py is licensed under GPLv3+
  - src/tests/intg/sssd_nss.py is licensed under GPLv3+
  - src/tests/intg/sssd_netgroup.py is licensed under GPLv3+
  - src/tests/intg/sssd_ldb.py is licensed under GPLv3+
  - src/tests/intg/sssd_id.py is licensed under GPLv3+
  - src/tests/intg/sssd_group.py is licensed under GPLv3+
  - src/tests/intg/secrets.py is licensed under GPLv3+
  - src/tests/intg/ldap_local_override_test.py is licensed under GPLv3+
  - src/tests/intg/ldap_ent.py is licensed under GPLv3+
  - src/tests/intg/krb5utils.py is licensed under GPLv3+
  - src/tests/intg/kdc.py is licensed under GPLv3+
  - src/tests/intg/files_ops.py is licensed under GPLv3+
  - src/tests/intg/ent_test.py is licensed under GPLv3+
  - src/tests/intg/ent.py is licensed under GPLv3+
  - src/tests/intg/ds_openldap.py is licensed under GPLv3+
  - src/tests/intg/ds.py is licensed under GPLv3+
  - src/config/setup.py.in is licensed under GPLv3+
  - src/config/SSSDConfig/ipachangeconf.py is licensed under GPLv3+
  - Explicitly add GPLv3+ license blob to several files
  - SELINUX: Always add SELinux user to the semanage database if it doesn't exist
  - pep8: Ignore W504 and W605 to silence warnings on Debian
  - LDAP: minor refactoring in auth_send() to conform to our coding style
  - LDAP: Only authenticate the auth connection if we need to look up user information
  - NSS: Avoid changing the memory cache ownership away from the sssd user
  - TESTS: Only use __wrap_sss_ncache_reset_repopulate_permanent to finish test if needed
  - UTIL: Add a is_domain_mpg shorthand
  - UTIL: Convert bool mpg to an enum mpg_mode
  - CONFDB: Read auto_private_groups as string, not bool
  - CONFDB/SYSDB: Add the hybrid MPG mode
  - CACHE_REQ: Add cache_req_data_get_type()
  - NSS: Add the hybrid-MPG mode
  - TESTS: Add integration tests for auto_private_groups=hybrid
  - Updating the translations for the 1.16.4 release

- Lukas Slebodnik (26):

  - krb5_locator: Make debug function internal
  - krb5_locator: Simplify usage of macro PLUGIN_DEBUG
  - krb5_locator: Fix typo in debug message
  - krb5_locator: Fix formatting of the variable port
  - krb5_locator: Use format string checking for debug function
  - PAM: Allow to configure pam services for Smartcards
  - UTIL: Fix compilation with curl 7.62.0
  - test_pac_responder: Skip test if pac responder is not installed
  - INTG: Show extra test summary info with pytest
  - CI: Modify suppression file for c-ares-1.15.0
  - sss_cache: Do not fail for missing domains
  - intg: Add test for sss_cache & shadow-utils use-case
  - sss_cache: Do not fail if noting was cached
  - test_sss_cache: Add test case for invalidating missing entries
  - pyhbac-test: Do not use assertEquals
  - SSSDConfigTest: Do not use assertEquals
  - SSSDConfig: Fix ResourceWarning unclosed file
  - SSSDConfigTest: Remove usage of failUnless
  - BUILD: Fix condition for building sssd-kcm man page
  - NSS: Do not use deprecated header files
  - sss_cache: Fail if unknown domain is passed in parameter
  - test_sss_cache: Add test case for wrong domain in parameter
  - test_files_provider: Do not use pytest fixtures as functions
  - test_ldap: Do not uses pytest fixtures as functions
  - Revert "intg: Generate tmp dir with lowercase"
  - ent_test: Update assertions for python 3.7.2

- Michal Židek (1):

  - GPO: Add gpo_implicit_deny option

- Pavel Březina (9):

  - sudo: respect case sensitivity in sudo responder
  - nss: use enumeration context as talloc parent for cache req result
  - netgroups: honor cache_refresh_percent
  - sdap: add sdap_modify_passwd_send
  - sdap: add ldap_pwmodify_mode option
  - sdap: split password change to separate request
  - sdap: use ldap_pwmodify_mode to change password
  - sudo ipa: do not store rules without sudoHost attribute
  - be: remember last good server's name instead of fo_server structure

- Sumit Bose (22):

  - intg: flush the SSSD caches to sync with files
  - LDAP: Log the encryption used during LDAP authentication
  - BUILD: Accept krb5 1.17 for building the PAC plugin
  - tests: fix mocking krb5_creds in test_copy_ccache
  - tests: increase p11_child_timeout
  - Revert "IPA: use forest name when looking up the Global Catalog"
  - ipa: use only the global catalog service of the forest root
  - utils: make N_ELEMENTS public
  - ad: replace ARRAY_SIZE with N_ELEMENTS
  - responder: fix domain lookup refresh timeout
  - ldap: add get_ldap_conn_from_sdom_pvt
  - ldap: prefer LDAP port during initgroups user lookup
  - ldap: user get_ldap_conn_from_sdom_pvt() where possible
  - krb5_locator: always use port 88 for master KDC
  - NEGCACHE: initialize UPN negative cache as well
  - NEGCACHE: fix typo in debug message
  - NEGCACHE: repopulate negative cache after get_domains
  - ldap: add users_get_handle_no_user()
  - ldap: make groups_get_handle_no_group() public
  - ipa s2n: fix typo
  - ipa s2n: do not add UPG member
  - ipa s2n: try to remove objects not found on the server

- Thorsten Scherf (1):

  - CONFIG: add missing ldap attributes for validation

- Tomas Halman (4):

  - nss: sssd returns '/' for emtpy home directories
  - ssh: sssd_ssh fails completely on p11_child timeout
  - ssh: p11_child error message is too generic
  - krb5_locator: Allow hostname in kdcinfo files

- Victor Tapia (1):

  - GPO: Allow customization of GPO_CROND per OS

- mateusz (1):

  - Added note about default value of ad_gpo_map_batch parameter
