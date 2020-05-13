SSSD 1.16.2
===========

Highlights
----------

### New Features

- The smart card authentication, or in more general certificate authentication code now supports OpenSSL in addition to previously supported NSS (\#3489). In addition, the SSH responder can now return public SSH keys derived from the public keys stored in a X.509 certificate. Please refer to the `ssh_use_certificate_keys` option in the man pages.
- The files provider now supports mirroring multiple passwd or group files. This enhancement can be used to use the SSSD files provider instead of the nss_altfiles module

### Notable bug fixes

- A memory handling issue in the `nss_ex` interface was fixed. This bug would manifest in IPA environments with a trusted AD domain as a crash of the ns-slapd process, because a `ns-slapd` plugin loads the `nss_ex` interface (\#3715)
- Several fixes for the KCM deamon were merged (see \#3687, \#3671, \#3633)
- The `ad_site` override is now honored in GPO code as well (\#3646)
- Several potential crashes in the NSS responder's netgroup code were fixed (\#3679, \#3731)
- A potential crash in the autofs responder's code was fixed (\#3752)
- The LDAP provider now supports group renaming (\#2653)
- The GPO access control code no longer returns an error if one of the relevant GPO rules contained no SIDs at all (\#3680)
- A memory leak in the IPA provider related to resolving external AD groups was fixed (\#3719)
- Setups that used multiple domains where one of the domains had its ID space limited using the `min_id/max_id` options did not resolve requests by ID properly (\#3728)
- Overriding IDs or names did not work correctly when the domain resolution order was set as well (\#3595)
- A version mismatch between certain newer Samba versions (e.g. those shipped in RHEL-7.5) and the Winbind interface provided by SSSD was fixed. To further prevent issues like this in the future, the correct interface is now detected at build time (\#3741)
- The files provider no longer returns a qualified name in case domain resolution order is used (\#3743)
- A race condition between evaluating IPA group memberships and AD group memberships in setups with IPA-AD trusts that would have manifested as randomly losing IPA group memberships assigned to an AD user was fixed (\#3744)
- Setting an SELinux login label was broken in setups where the domain resolution order was used (\#3740)
- SSSD start up issue on systems that use the libldb library with version 1.4.0 or newer was fixed.

Packaging Changes
-----------------

- Several new build requirements were added in order to support the OpenSSL certificate authentication

Documentation Changes
---------------------

- The files provider gained two new configuration options `passwd_files` and `group_files.` These can be used to specify the additional files to mirror.
- A new `ssh_use_certificate_keys` option toggles whether the SSH responder would return public SSH keys derived from X.509 certificates.
- The `local_negative_timeout` option is now enabled by default. This means that if SSSD fails to find a user in the configured domains, but is then able to find the user with an NSS call such as getpwnam, it would negatively cache the request for the duration of the local_negative_timeout option.

Tickets Fixed
-------------

- [3752](https://pagure.io/SSSD/sssd/issue/3752) - /usr/libexec/sssd/sssd_autofs SIGABRT crash daily due to a double free
- [3749](https://pagure.io/SSSD/sssd/issue/3749) - [RFE] sssd.conf should mention the FILES provider as valid config value for the 'id_provider'
- [3748](https://pagure.io/SSSD/sssd/issue/3748) - home dir disappear in sssd cache on the IPA master for AD users
- [3744](https://pagure.io/SSSD/sssd/issue/3744) - Race condition between concurrent initgroups requests can cause one of them to return incomplete information
- [3743](https://pagure.io/SSSD/sssd/issue/3743) - Weirdness when using files provider and domain resolution order
- [3742](https://pagure.io/SSSD/sssd/issue/3742) - Change of: User may not run sudo --&gt; a password is required
- [3741](https://pagure.io/SSSD/sssd/issue/3741) - Samba can not register sss idmap module because it's using an outdated SMB_IDMAP_INTERFACE_VERSION
- [3740](https://pagure.io/SSSD/sssd/issue/3740) - Utilizing domain_resolution_order in sssd.conf breaks SELinux user map
- [3733](https://pagure.io/SSSD/sssd/issue/3733) - sssd fails to download known_hosts from freeipa
- [3728](https://pagure.io/SSSD/sssd/issue/3728) - Request by ID outside the min_id/max_id limit of a first domain does not reach the second domain
- [3726](https://pagure.io/SSSD/sssd/issue/3726) - SSSD with ID provider 'ad' should give a warning in case the ldap schema is manually changed to something different than 'ad'.
- [3725](https://pagure.io/SSSD/sssd/issue/3725) - sssd not honoring dyndns_server if the DNS update process is terminated with a signal
- [3719](https://pagure.io/SSSD/sssd/issue/3719) - The SSSD IPA provider allocates information about external groups on a long lived memory context, causing memory growth of the sssd_be process
- [3715](https://pagure.io/SSSD/sssd/issue/3715) - ipa 389-ds-base crash in krb5-libs - k5_copy_etypes list out of bound?
- [3706](https://pagure.io/SSSD/sssd/issue/3706) - Hide debug message domain not found for well known sid
- [3694](https://pagure.io/SSSD/sssd/issue/3694) - externalUser sudo attribute must be fully-qualified
- [3684](https://pagure.io/SSSD/sssd/issue/3684) - A group is not updated if its member is removed with the cleanup task, but the group does not change
- [3680](https://pagure.io/SSSD/sssd/issue/3680) - GPO: SSSD fails to process GPOs If a rule is defined, but contains no SIDs
- [3679](https://pagure.io/SSSD/sssd/issue/3679) - Make nss netgroup requests more robust
- [3674](https://pagure.io/SSSD/sssd/issue/3674) - The tcurl module logs the payload
- [3671](https://pagure.io/SSSD/sssd/issue/3671) - KCM: Payload buffer is too small
- [3666](https://pagure.io/SSSD/sssd/issue/3666) - Fix usage of str.decode() in our tests
- [3664](https://pagure.io/SSSD/sssd/issue/3664) - LOGS: Improve debugging in case the PAM service is not mapped to any GPO rule
- [3660](https://pagure.io/SSSD/sssd/issue/3660) - confdb_expand_app_domains() always fails
- [3658](https://pagure.io/SSSD/sssd/issue/3658) - Application domain is not interpreted correctly
- [3656](https://pagure.io/SSSD/sssd/issue/3656) - PyErr_NewExceptionWithDoc configure check should not use cached results for different python versions
- [3646](https://pagure.io/SSSD/sssd/issue/3646) - SSSD's GPO code ignores ad_site option
- [3644](https://pagure.io/SSSD/sssd/issue/3644) - sss_groupshow no longer labels MPG groups
- [3634](https://pagure.io/SSSD/sssd/issue/3634) - sssctl COMMAND --help fails if sssd is not configured
- [3633](https://pagure.io/SSSD/sssd/issue/3633) - Reset the last_request_time when any activity happens on Secrets and KCM responders
- [3629](https://pagure.io/SSSD/sssd/issue/3629) - Implement sss_nss_getsidbyuid and sss_nss_etsidbygid for situations where customers define UID == GID
- [3619](https://pagure.io/SSSD/sssd/issue/3619) - Enable local_negative_timeout by default
- [3605](https://pagure.io/SSSD/sssd/issue/3605) - Fix pep8 issues on our python files.
- [3595](https://pagure.io/SSSD/sssd/issue/3595) - ID override GID from Default Trust View is not properly resolved in case domain resolution order is set
- [3558](https://pagure.io/SSSD/sssd/issue/3558) - sudo: report error when two rules share cn
- [3550](https://pagure.io/SSSD/sssd/issue/3550) - refresh_expired_interval does not work with netgrous in 1.15
- [3520](https://pagure.io/SSSD/sssd/issue/3520) - Files provider supports only BE_FILTER_ENUM
- [3469](https://pagure.io/SSSD/sssd/issue/3469) - extend sss-certmap man page regarding priority processing
- [3436](https://pagure.io/SSSD/sssd/issue/3436) - Certificates used in unit tests have limited lifetime
- [3402](https://pagure.io/SSSD/sssd/issue/3402) - Support alternative sources for the files provider
- [3335](https://pagure.io/SSSD/sssd/issue/3335) - GPO retrieval doesn't work if SMB1 is disabled
- [2653](https://pagure.io/SSSD/sssd/issue/2653) - Group renaming issue when "id_provider = ldap" is set.

Detailed Changelog
------------------

- Fabiano Fidêncio (77):

  - TESTS: Fix E501 pep8 issues on test_ldap.py
  - TESTS: Fix E20[12] pep8 issues on python-test.py
  - TESTS: Fix E501 pep8 issues on python-test.py
  - TESTS: Fix E251 pep8 issues on python-test.py
  - TESTS: Fix E231 pep8 issues on python-test.py
  - TESTS: Fix E265 pep8 issues on python-test.py
  - TESTS: Fix E128 pep8 issues on python-test.py
  - TESTS: Fix E302 pep8 issues on python-test.py
  - TESTS: Fix W391 pep8 issues on python-test.py
  - TESTS: Fix E228 pep8 issues on python-test.py
  - TESTS: Fix E261 pep8 issues on python-test.py
  - TESTS: Fix E701 pep8 issues on python-test.py
  - TESTS: Fix E305 pep8 issues on python-test.py
  - TESTS: Fix E20[12] pep8 issues on pysss_murmur-test.py
  - TESTS: Fix E211 pep8 issues on pysss_murmur-test.py
  - TESTS: Fix E20[12] pep8 issues on pyhbac-test.py
  - TESTS: Fix E261 pep8 issues on pyhbac-test.py
  - TESTS: Fix W391 pep8 issues on pyhbac-test.py
  - TESTS: Fix E501 pep8 issues on pyhbac-test.py
  - TESTS: Fix E302 pep8 issues on pyhbac-test.py
  - TESTS: Fix E305 pep8 issues on pyhbac-test.py
  - TESTS: Fix E711 pep8 issues on sssd_group.py
  - TESTS: Fix E305 pep8 issues on sssd_netgroup.py
  - TESTS: Fix E501 pep8 issues on utils.py
  - TESTS: Fix E305 pep8 issues on conf.py
  - CONTRIB: Fix E501 pep8 issues on sssd_gdb_plugin.py
  - CONTRIB: Fix E305 pep8 issues on sssd_gdb_plugin.py
  - TESTS: Fix E302 pep8 issues on test_enumeration.py
  - TESTS: FIX E501 pep8 issues on pysss_murmur-test.py
  - CI: Enable pep8 check
  - CI: Ignore E722 pep8 issues on debian machines
  - TESTS: Fix E501 pep8 issues on test_netgroup.py
  - NSS: Remove dead code
  - CONFDB: Start a ldb transaction from sss_ldb_modify_permissive()
  - TOOLS: Take into consideration app domains
  - TESTS: Move get_call_output() to util.py
  - TESTS: Make get_call_output() more flexible about the stderr log
  - TESTS: Add a basic test of `sssctl domain-list`
  - KCM: Use json_loadb() when dealing with sss_iobuf data
  - KCM: Remove mem_ctx from kcm_new_req()
  - KCM: Introduce kcm_input_get_payload_len()
  - KCM: Do not use 2048 as fixed size for the payload
  - KCM: Adjust REPLY_MAX to the one used in krb5
  - KCM: Fix typo in ccdb_sec_delete_list_done()
  - KCM: Only print the number of found items after we have it
  - SERVER: Tone down shutdown messages for socket-activated responders
  - MAN: Improve docs about GC detection
  - NSS: Add InvalidateGroupById handler
  - DP: Add dp_sbus_invalidate_group_memcache()
  - ERRORS: Add ERR_GID_DUPLICATED
  - SDAP: Add sdap_handle_id_collision_for_incomplete_groups()
  - SDAP: Properly handle group id-collision when renaming incomplete groups
  - SYSDB_OPS: Error out on id-collision when adding an incomplete group
  - SECRETS: reset last_request_time on any activity
  - KCM: reset last_request_time on any activity
  - RESPONDER: Add sss_client_fd_handler()
  - RESPONDER: Make use of sss_client_fd_handler()
  - SECRETS: Make use of sss_client_fd_handler()
  - KCM: Make use of sss_client_fd_handler()
  - TESTS: Rename test_idle_timeout()
  - TESTS: Add test for responder_idle_timeout
  - TESTS: Fix typo in test_sysdb_domain_resolution_order_ops()
  - SYSDB: Properly handle name/gid override when using domain resolution order
  - TESTS: Increase test_resp_idle_timeout\* timeout
  - COVERITY: Add coverity support
  - MAKE_SRPM: Add --output parameter
  - Add .copr/Makefile
  - CACHE_REQ: Don't force a fqname for files provider' output
  - cache_req: Don't force a fqname for files provider output
  - tests: Add a test for files provider + domain resolution order
  - man: Users managed by the files provider don't have their output fully-qualified
  - Revert "CACHE_REQ: Don't force a fqname for files provider' output"
  - selinux_child: workaround fqnames when using DRO
  - sudo_ldap: fix sudoHost=defaults -&gt; cn=defaults in the filter
  - Revert "sysdb custom: completely replace old object instead of merging it"
  - sysdb_sudo: completely replace old object instead of merging it
  - tlog: only log in tcurl_write_data when SSS_KCM_LOG_PRIVATE_DATA is set to YES

- Jakub Hrozek (33):

  - Bumping the version to track 1.16.2 development
  - IPA: Handle empty nisDomainName
  - TESTS: Fix E266 pep8 issues on test_ldap.py
  - TESTS: Fix E231 pep8 issues on test_session_recording.py
  - TESTS: Fix E501 pep8 issues on test_session_recording.py
  - TESTS: Fix E303 pep8 issues on test_ldap.py
  - SYSDB: When marking an entry as expired, also set the originalModifyTimestamp to 1
  - IPA: Qualify the externalUser sudo attribute
  - NSS: Adjust netgroup setnetgrent cache lifetime if midpoint refresh is used
  - TESTS: Add a test for the multiple files feature
  - SDAP: Improve a DEBUG message about GC detection
  - LDAP: Augment the sdap_opts structure with a data provider pointer
  - TESTS: Add an integration test for renaming incomplete groups during initgroups
  - SYSDB: sysdb_add_incomplete_group now returns EEXIST with a duplicate GID
  - MAN: Document which principal does the AD provider use
  - FILES: Do not overwrite and actually remove files_ctx.{pwd,grp}_watch
  - FILES: Reduce code duplication
  - FILES: Reset the domain status back even on errors
  - FILES: Skip files that are not created yet
  - FILES: Only send the request for update if the files domain is inconsistent
  - DYNDNS: Move the retry logic into a separate function
  - DYNDNS: Retry also on timeouts
  - AD: Warn if the LDAP schema is overriden with the AD provider
  - SYSDB: Only check non-POSIX groups for GID conflicts
  - Do not keep allocating external groups on a long-lived context
  - CACHE_REQ: Do not fail the domain locator plugin if ID outside the domain range is looked up
  - MAN: Fix the title of the session recording man page
  - DP/LDAP: Only increase the initgrTimestamp when the full initgroups DP request finishes
  - LDAP: Do not use signal-unsafe calls in ldap_child SIGTERM handler
  - AUTOFS: remove timed event if related object is removed
  - RESPONDERS: Enable the local negative timeout by default
  - LDAP: Suppress a loud debug message in case a built-in SID can't be resolved
  - Updating the translations for the 1.16.2 release

- Justin Stephenson (3):

  - DEBUG: Print simple allow and deny lists
  - CONFDB: Add passwd_files and group_files options
  - FILES: Handle files provider sources

- Lukas Slebodnik (21):

  - CI: Add dbus into debian dependencies
  - intg: convert results returned as bytes to strings
  - SYSDB: Remove unused parameter from sysdb_cache_connect_helper
  - SPEC: Add gcc to build dependencies
  - UTIL: Use alternative way for detecting PyErr_NewExceptionWithDoc
  - CONFIGURE: drop unused check
  - SYSDB: Return ENOENT for mpg with local provider
  - sysdb-tests: sysdb_search_group_by_name with local provider
  - selinux_child: Allow to query sssd
  - selinux_child: Fix crash with initialized key
  - BUILD: Remove unnecessary flags from test_ipa_dn
  - BUILD: Remove ldap libraries from SSSD_LIBS
  - BUILD: Remove ldap libraries from TOOL_LIBS
  - BUILD: Remove pcre libs from common _LIBS
  - BUILD: Remove pcre from krb5_child
  - BUILD: Remove libcollection form common libs
  - BUILD: Reduce dependencies of sss_signal
  - BUILD: Remove cares from sssd_secrets
  - BUILD: Remove libini_config from common libs
  - MONITOR: Do not use two configuration databases
  - CI: Prepare for python3 -&gt; python

- Michal Židek (6):

  - AD: Missing header in ad_access.h
  - GPO: Add ad_options to ad_gpo_process_som_state
  - GPO: Use AD site override if set
  - GPO: Fix bug with empty GPO rules
  - GPO: DEBUG msg when GP to PAM mappings overlap
  - GPO: Debugging default PAM service mapping

- Pavel Březina (3):

  - sudo ldap: do not store rules without sudoHost attribute
  - sysdb custom: completely replace old object instead of merging it
  - sssctl: move check for version error to correct place

- Richard Sharpe (1):

  - nss-imap: add sss_nss_getsidbyuid() and sss_nss_getsidbygid()

- Sumit Bose (38):

  - intg: enhance netgroups test
  - TESTS: simple CA to generate certificates for test
  - TESTS: replace hardcoded certificates
  - TESTS: remove NSS test databases
  - test_ca: add empty index.txt.attr file
  - nss: initialize nss_enum_index in nss_setnetgrent()
  - nss: add a netgroup counter to struct nss_enum_index
  - nss-idmap: do not set a limit
  - nss-idmap: use right group list pointer after sss_get_ex()
  - NSS: nss_clear_netgroup_hash_table() do not free data
  - winbind idmap plugin: support inferface version 6
  - winbind idmap plugin: fix detection
  - p11_child: move verification into separate functions
  - p11_child: add verification option
  - utils: add get_ssh_key_from_cert()
  - utils: move p11 child paths to util.h
  - utils: add cert_to_ssh_key request
  - tests: add test for cert_to_ssh_key request
  - ssh: use cert_to_ssh_key request to verify certifcate and get keys
  - ssh: add option ssh_use_certificate_keys and enhance man page
  - utils: remove unused code from cert utils
  - tests: add SSH responder tests
  - p11_child: split common and NSS code into separate files
  - p11_child: add OpenSSL support
  - TESTS: make some cert auth checks order independent
  - p11_child: allow tests to use OpenSSL version of p11_child
  - certmap: fix issue found by Coverity in OpenSSL version
  - SPEC/CI: enable openssl build for Debian and upcoming versions
  - certmap: allow missing empty EKU in OpenSSL version
  - KCM: be aware that size_t might have different size than other integers
  - sysdb: add sysdb_getgrgid_attrs()
  - ipa: use mpg aware group lookup in get_object_from_cache()
  - ipa: allow mpg group objects in apply_subdomain_homedir()
  - AD/LDAP: do not fall back to mpg user lookup on GC connection
  - cifs idmap plugin: use new sss_nss_idmap calls
  - winbind idmap plugin: use new sss_nss_idmap calls
  - libwbclient-sssd: use new sss_nss_idmap calls
  - pysss_nss_idmap: add python bindings for new sss_nss_idmap calls

- Thorsten Scherf (1):

  - man: Add FILES as a valid config option for 'id_provider'

- Yuri Chornoivan (1):

  - MAN: Fix minor typos

- amitkuma (1):

  - sssctl: Showing help even when sssd not configured

- amitkumar50 (2):

  - MAN: Add sss-certmap man page regarding priority processing
  - MAN: Clarify how comments work in sssd.conf
