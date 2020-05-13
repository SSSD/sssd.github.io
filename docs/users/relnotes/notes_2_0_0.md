SSSD 2.0.0
==========

Highlights
----------

This release removes or deprecates functionality from SSSD, therefore the SSSD team decided it was time to bump the major version number. The sssd-1-16 branch will be still supported (most probably even as a LTM branch) so that users who rely on any of the removed features can either migrate or ask for the features to be readded.

Except for the removed features, this release contains a reworked internal IPC and a new default storage back end for the KCM responder.

### Platform support removal

- Starting with SSSD 2.0, upstream no longer supports RHEL-6 and its derivatives. Users of RHEL-6 are encouraged to stick with the sssd-1-16 branch.

### Removed features

- The Python API for managing users and groups in local domains (`id_provider=local`) was removed completely. The interface had been packaged as module called `pysss.local`
- The LDAP provider had a special-case branch for evaluating group memberships with the RFC2307bis schema when group nesting was explicitly disabled. This codepath was adding needless additional complexity for little performance gain and was rarely used.
- The `ldap_groups_use_matching_rule_in_chain` and `ldap_initgroups_use_matching_rule_in_chain` options and the code that evaluated them was removed. Neither of these options provided a significant performance benefit and the code implementing these options was complex and rarely used.

### Deprecated features

- The local provider (`id_provider=local`) and the command line tools to manage users and groups in the local domains, such as `sss_useradd` is not built by default anymore. There is a configure-time switch `--enable-local-domain` you can use to re-enable the local domain support. However, upstream would like to remove the local domain completely in a future release.
- The `sssd_secrets` responder is not packaged by default. The responder was meant to provide a REST API to access user secrets as well as a proxy to Custodia servers, but as Custodia development all but stopped and the local secrets handling so far didn't gain traction, we decided to not enable this code by default. This also means that the default SSSD configuration no longer requires libcurl and http-parser.

### Changed default settings

- The `ldap_sudo_include_regexp` option changed its default value from `true` to `false`. This means that wild cards in the `sudoHost` LDAP attribute are no longer supported by default. The reason we changed the default was that the wildcard was costly to evaluate on the LDAP server side and at the same time rarely used.

### New features

- The KCM responder has a new back end to store credential caches in a local database. This new back end is enabled by default and actually uses the same storage as the `sssd-secrets` responder had used, so the switch from sssd-secrets to this new back end should be completely seamless. The `sssd-secrets` socket is no longer required for KCM to operate.
- The list of PAM services which are allowed to authenticate using a Smart Card is now configurable using a new option `pam_p11_allowed_services`.

Packaging Changes
-----------------

- The `sss_useradd`, `sss_userdel`, `sss_usermod`, `sss_groupadd`, `sss_groupdel`, `sss_groupshow` and `sss_groupmod` binaries and their manual pages are no longer packaged by default unless `--enable-local-provider` is selected.
- The sssd_secrets responder is no longer packaged by default unless `--enable-secrets-responder` is selected.
- The new internal IPC mechanism uses several private libraries that need to be packaged - `libsss_sbus.so`, `libsss_sbus_sync.so`, `libsss_iface.so`, `libsss_iface_sync.so`, `libifp_iface.so` and `libifp_iface_sync.so`
- The new KCM ccache back end relies on a private library `libsss_secrets.so` that must be packaged in case either the KCM responder or the secrets responder are enabled.

Documentation Changes
---------------------

- The `ldap_groups_use_matching_rule_in_chain` and `ldap_initgroups_use_matching_rule_in_chain` options were removed.
- The `ldap_sudo_include_regexp` option changed its default value from `true` to `false`.

Known issues
------------

- <https://pagure.io/SSSD/sssd/issue/3807- The sbus codegen script relies on "python" which might not be available on all distributions
>
  - There is a script that autogenerates code for the internal SSSD IPC. The script happens to call "python" which is not available on all distributions. Patching the `sbus_generate.sh` file to call e.g. python3 explicitly works around the issue
>
Tickets Fixed
-------------

- [3717](https://pagure.io/SSSD/sssd/issue/3717) - Don't package sssd-secrets by default
- [3685](https://pagure.io/SSSD/sssd/issue/3685) - KCM: Default to a new back end that would write to the secrets database directly
- [3530](https://pagure.io/SSSD/sssd/issue/3530) - Remove CONFDB_DOMAIN_LEGACY_PASS
- [3515](https://pagure.io/SSSD/sssd/issue/3515) - Disable host wildcards in sudoHost attribute (ldap_sudo_include_regexp=false)
- [3494](https://pagure.io/SSSD/sssd/issue/3494) - Remove the special-case for RFC2307bis with zero nesting level
- [3493](https://pagure.io/SSSD/sssd/issue/3493) - Remove the pysss.local interface
- [3492](https://pagure.io/SSSD/sssd/issue/3492) - Remove support for ldap_groups_use_matching_rule_in_chain and ldap_initgroups_use_matching_rule_in_chain
- [3304](https://pagure.io/SSSD/sssd/issue/3304) - Only build the local provider conditionally
- [2926](https://pagure.io/SSSD/sssd/issue/2926) - Make list of local PAM services allowed for Smartcard authentication configurable

Detailed Changelog
------------------

- Amit Kumar (1):

  - providers: disable ldap_sudo_include_regexp by default

- Fabiano Fidêncio (19):

  - man/sss_ssh_knownhostsproxy: fix typo pubkeys -&gt; pubkey
  - providers: drop `ldap()`{init,}groups_use_matching_rule_in_chain support
  - ldap: remove parallel requests from rfc2307bis
  - tests: adapt common_dom to files_provider
  - tests: adapt test_sysdb_views to files provider
  - tests: adapt sysdb-tests to files_provider
  - tests: adapt sysdb_ssh tests to files provider
  - tests: adapt auth-tests to files provider
  - tests: adapt tests_fqnames to files provider
  - sysdb: sanitize the dn on cleanup_dn_filter
  - sysdb: pass subfilter and ts_subfilter to `sysdb_search*()`_by_timestamp()
  - tests: adapt test_ldap_id_cleanup to files provider
  - tests: remove LOCAL_SYSDB_FILE reference from test_sysdb_certmap
  - tests: remove LOCAL_SYSDB_FILE reference from `test_sysdb_domain_resolution_order()`
  - tests: remove LOCAL_SYSDB_FILE reference from test_sysdb_subdomains
  - tests: remove LOCAL_SYSDB_FILE reference from common_dom
  - local: build local provider conditionally
  - pysss: fix typo in comment
  - pysss: remove pysss.local

- Jakub Hrozek (55):

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
  - Updating the version before the 2.0 release
  - TESTS: the sys package was used but not imported
  - TESTS: Remove tests database in teardown
  - TESTS: Properly set argv[0] when starting the secrets responder
  - KCM: Move a confusing DEBUG message
  - KCM: Fix a typo
  - UTIL: Add libsss_secrets
  - SECRETS: Use libsss_secrets
  - KCM; Hide the secret URL as implementation detail instead of exposing it in the JSON-marshalling API
  - UTIL: libsss_secrets: Add an update function
  - KCM: Add a new back end that uses libsss_secrets directly
  - TESTS: Get rid of KCM_PEER_UID
  - TESTS: Add tests for the KCM libsss_secrets back end
  - KCM: Change the default ccache storage from the secrets responder to libsecrets
  - BUILD: Do not build the secrets responder by default

- Lukas Slebodnik (6):

  - krb5_locator: Make debug function internal
  - krb5_locator: Simplify usage of macro PLUGIN_DEBUG
  - krb5_locator: Fix typo in debug message
  - krb5_locator: Fix formatting of the variable port
  - krb5_locator: Use format string checking for debug function
  - PAM: Allow to configure pam services for Smartcards

- Pavel Březina (21):

  - include stdarg.h directly in debug.h
  - pam_add_response: fix talloc context
  - sss_ptr_hash: add sss_ptr_get_value to make it useful in delete callbacks
  - sss_ptr_list: add linked list of talloc pointers
  - sbus: move sbus code to standalone library
  - sbus: add sbus sssd error codes
  - sbus: add new implementation
  - sbus: build new sbus implementation
  - sbus: disable generating old api
  - sbus: fix indirect includes in sssd
  - sbus: add sss_iface library
  - sbus: convert monitor
  - sbus: convert backend
  - sbus: convert responders
  - sbus: convert proxy provider
  - sbus: convert infopipe
  - sbus: convert sssctl
  - sbus: remove old implementation
  - sbus: add new internal libraries to specfile
  - sbus: make tests run
  - tests: disable parse_inp_call_dp, parse_inp_call_attach in responder-get-domains-tests

- amitkuma (1):

  - confdb: Remove CONFDB_DOMAIN_LEGACY_PASS
