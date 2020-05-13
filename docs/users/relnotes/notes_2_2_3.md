SSSD 2.2.3
==========

Highlights
----------

### New features

- allow_missing_name now treats empty strings the same as missing names.
- 'soft_ocsp' and 'soft_crl options have been added to make the checks for revoked certificates more flexible if the system is offline.
- Smart card authentication in polkit is now allowed by default.
- ssh_use_certificate_matching_rules now allows no_rules and all_rules values (see man page for description).

### Notable bug fixes

- Fixed several memory management errors that caused SSSD to crash under some circumstances.
- Handling of FreeIPA users and groups containing '@' sign now works.
- Issue when autofs was unable to mount shares was fixed.
- SSSD was unable to hande ldap_uri containing URIs with different port numbers. This was fixed.

Packaging Changes
-----------------

- Added sssd-ldap-attributes man page.

Documentation Changes
---------------------

- Added new sssd-ldap-attributes man page.
- Added option monitor_resolv_conf.
- Added option ssh_use_certificate_matching_rules
- Improved AD GPO options man page.
- Improved sssd-systemtap man page.

Tickets Fixed
-------------

- [2607](https://pagure.io/SSSD/sssd/issue/2607) - sssd should not always read entire autofs map from ldap
- [2660](https://pagure.io/SSSD/sssd/issue/2660) - SSSD service is crashing: dbus_watch_handle() is invoked with corrupted 'watch' value
- [2710](https://pagure.io/SSSD/sssd/issue/2710) - Propagate error about multiple entries found from cache_req to responder
- [3078](https://pagure.io/SSSD/sssd/issue/3078) - use the ERROR and PRINT macros consistently
- [3219](https://pagure.io/SSSD/sssd/issue/3219) - [RFE] Regular expression used in sssd.conf not being able to consume an @-sign in the user/group name.
- [3583](https://pagure.io/SSSD/sssd/issue/3583) - Stop calling umask(0) in selinux_child now that libsemanage has been fixed
- [3677](https://pagure.io/SSSD/sssd/issue/3677) - [RFE] SSSD smart smard card, configure to soft fail when CRL not available
- [3864](https://pagure.io/SSSD/sssd/issue/3864) - sss_ssh_authorizedkeys: no output when attribute value contains trailing whitespace
- [3914](https://pagure.io/SSSD/sssd/issue/3914) - test_pam_responder.py needs improvement
- [3938](https://pagure.io/SSSD/sssd/issue/3938) - sssctl config-check giving the wrong error message when there are only snippet files and no sssd. conf
- [3995](https://pagure.io/SSSD/sssd/issue/3995) - SSSDConfig: some options are unknown
- [4024](https://pagure.io/SSSD/sssd/issue/4024) - Non FIPS140 compliant usage of PRNG
- [4030](https://pagure.io/SSSD/sssd/issue/4030) - sss_obfuscate fails to rewriting comments
- [4073](https://pagure.io/SSSD/sssd/issue/4073) - Let IPA client read IPA objects via LDAP and not via extdom plugin when resolving trusted users and groups
- [4078](https://pagure.io/SSSD/sssd/issue/4078) - Trusted domain user logins succeed after using ipa trustdomain-disable
- [4080](https://pagure.io/SSSD/sssd/issue/4080) - Improve `sssd_nss` debug messages
- [4081](https://pagure.io/SSSD/sssd/issue/4081) - systemctl status sssd says No such file or directory about "default" when keytab exists but is empty file
- [4085](https://pagure.io/SSSD/sssd/issue/4085) - support for defaults entry is failing in sssd sudo against Openldap server
- [4094](https://pagure.io/SSSD/sssd/issue/4094) - sss_client: usage of srand()/rand() may be disruptive for the user of lib
- [4100](https://pagure.io/SSSD/sssd/issue/4100) - KCM: ccache is created with kdc_offset=INT32_MAX
- [4101](https://pagure.io/SSSD/sssd/issue/4101) - [RFE] pam_sss allow_missing_name should allow whitespace-only string
- [4102](https://pagure.io/SSSD/sssd/issue/4102) - Null dereference in sssctl/sssctl_domains.c:sssctl_domain_status_active_server()
- [4111](https://pagure.io/SSSD/sssd/issue/4111) - automount on RHEL7 gives the message 'lookup(sss): setautomntent: No such file or directory'
- [4112](https://pagure.io/SSSD/sssd/issue/4112) - ldap_uri failover doesn't work with different ports
- [4114](https://pagure.io/SSSD/sssd/issue/4114) - sssd failover leads to delayed and failed logins
- [4115](https://pagure.io/SSSD/sssd/issue/4115) - Smart Card authentication in polkit
- [4116](https://pagure.io/SSSD/sssd/issue/4116) - autofs: delete possible duplicate of an autofs entry
- [689](https://pagure.io/SSSD/sssd/issue/689) - Split sssd-ldap man page

Detailed changelog
------------------

- Alex Rodin (7):  
  - Added ERROR and PRINT macros to the tools
  - Update sss_ssh.c
  - Update __init__.py.in
  - Added PRINT macro in the sssctl tool
  - Update README.md
  - Updated test_pam_responder.py
  - Created a new sssd-ldap-attributes.5 man page

- Alexey Tikhonov (39):  
  - providers/ipa/: add_v1_user_data() amended
  - responder/cache_req: added debug helper function
  - responder/nss: improved debug messages
  - responder/nss: DCE
  - responder: log cmdline of client pid
  - SSS_CLIENT: got rid of using PRNG
  - util/server: amended close_low_fds()
  - util/sss_krb5.c: elimination of unreachable code
  - util/sss_krb5: find_principal_in_keytab() was amended
  - util/sss_krb5: fixed few memory handling issues
  - util/sss_krb5: debug messages fixes
  - sssctl/sssctl_domains.c: null dereference fixed
  - MMAP_CACHE: use CSPRNG to init hash table seed
  - Moved unsecure sss_rand() out of crypto lib
  - Reduces code duplication
  - sss_ssh_knownhostsproxy: relocated O_NONBLOCK setting
  - sss_ssh_knownhostsproxy: fixed Coverity issue
  - util/sss_krb5: amended sss_krb5_get_error_message()
  - Amended sss_krb5_get_error_message() usage.
  - ldap_child: sanitization of error handling
  - KEYTAB_CLEAN_NAME macro was replaced
  - SBUS: defer deallocation of sbus_watch_ctx
  - util/server.c: become_daemon() made static
  - server:become_daemon(): got rid of unused codepath
  - server:become_daemon(): handle fail of fork()
  - server:become_daemon(): fixed waitpid()-loop
  - server:become_daemon(): fix read of uninitialized value
  - server:become_daemon(): change handling of chdir() fail
  - server:become_daemon(): handle fail of setsid()
  - util/memory: sanitization
  - util/memory: helper(s) to securely erase mem was reworked
  - tools/sss_seed: proper zeroization of sensitive data
  - util: fixed potential mem leak in s3crypt_gen_salt()
  - util/sha512_crypt_r: got rid of redundant mem align
  - util/sha512_crypt_r: removed misleading comments
  - util/sha512_crypt_r: proper zeroization of sensitive data
  - db/sysdb_ops: proper zeroization of sensitive data
  - util/authtok: set destructor in sss_authtok_new()
  - LDAP: proper handling of master password

- Ariel O. Barria (1):  
  - sss_obfuscate: do not fail if sssd.conf contains non-ascii characters

- Fabiano Fidêncio (1):  
  - TESTS: Re-add tests for `kdestroy -A`

- Jakub Hrozek (3):  
  - KCM: Fix typo in allocation check
  - KCM: Set kdc_offset to zero initially
  - sudo: use objectCategory instead of objectClass in ad sudo provider

- Jakub Jelen (1):  
  - Allow smart card authentication in polkit

- Lukas Slebodnik (1):  
  - IFP: Fix talloc hierarchy for members of struct ifp_list_domains_state

- MIZUTA Takeshi (4):  
  - sss_client/idmap/common_ex.c: fix sss_nss_timedlock() to return errno
  - util/server.c: fix handling when error occurs in waitpid()
  - Fix timing to save errno
  - Add processing to save errno before outputting DEBUG

- Michal Židek (8):  
  - Bumping the version to track the 2.2.3 development
  - SPECFILE: Add 'make' as build dependency
  - memcache: Stop using the word fastcache for memcache
  - MAN: GPO and built-in groups
  - bash_rc: Build with systemtap
  - MAN: Missing man pages in src/man/po/po4a.cfg
  - MAN: Fix errors in Japanese translation
  - Update the translations for the 2.2.3 release

- Niranjan M.R (4):  
  - pytest: Use idm:DL1 module to install 389-ds
  - pytest: Update README with instructions to execute tests
  - pytest/testlib: Add python-ldap as dependency
  - Makefile.am: Use README.md instead of README

- Pavel Březina (49):  
  - sss_ptr_hash: keep value pointer when destroying spy
  - autofs: fix typo in test tool
  - sysdb: add expiration time to autofs entries
  - sysdb: add sysdb_get_autofsentry
  - sysdb: add enumerationExpireTimestamp
  - sysdb: store enumeration expiration time in autofs map
  - sysdb: store original dn in autofs map
  - sysdb: add sysdb_del_autofsentry_by_key
  - cache_req: add autofs map entries plugin
  - cache_req: add autofs map by name plugin
  - cache_req: add autofs entry by name plugin
  - autofs: convert code to cache_req
  - autofs: use cache_req to obtain single entry in getentrybyname
  - autofs: use cache_req to obtain map in setent
  - dp: add dp_error_to_ret
  - dp: add dp_no_output type to be used in dp_set_method
  - dp: add additional autofs methods
  - dp: replace autofs handler with enumerate method
  - ldap: add base_dn to sdap_search_bases
  - ldap: rename sdap_autofs_get_map to sdap_autofs_enumerate
  - ldap: implement autofs get map
  - ldap: implement autofs get entry
  - autofs: allow to run only setent without enumeration in test tool
  - autofs: always refresh auto.master
  - sysdb: invalidate also autofs entries
  - sss_cache: invalidate also autofs entries
  - ci: allow distribution specific supression files
  - ci: suppress Debian valgrind errors
  - ci: add Debian 10
  - ifp: call tevent_req_post in case of error in ifp_user_get_attr_send
  - sudo: get timezone information from previous value when constructing new usn
  - ci: enable on demand runs
  - ci: set build name to pull request or branch name
  - ci: notify that build awaits executor
  - ci: convert to scripted pipeline
  - db: fix potential memory leak in sysdb_store_selinux_config
  - ldap: do not store empty attribute with ldap_rfc2307_fallback_to_local_users = true
  - sss_ptr_hash: pass new hash_entry_t to custom delete callback
  - failover: make sure we switch to anoter server if only port differs
  - autofs: remove unused enum
  - autofs: delete possible duplicate of an autofs entry
  - ci: store artifacts in jenkins for on-demand runs
  - ci: allow to specify systems where tests should be run for on-demand tests
  - ci: add Fedora 31
  - ci: install python2 on Fedora 31 and RHEL 8 so python2 bindings can be built
  - ci: disable python2 bindings on Fedora 32+
  - man: add missing new line to autofs_attributes.xml
  - pam_sss: treat whitespace name as missing name if allow_missing_name is set
  - sudo: add ldap_sudorule_object_class_attr

- Paweł Poławski (2):  
  - selinux: Keep explicite umask() calls
  - files_ops: Remove unused functions parameter

- REIM THOMAS (1):  
  - MAN: Provide minimum information on GPO access control

- Samuel Cabrero (12):  
  - SYSDB: Delete linked local user overrides when deleting a user
  - SYSDB: Convert cached domain 'enumerated' attribute from bool to uint
  - SDAP: Add provider name to enumeration and cleanup tasks
  - LDAP: Return errno_t for ldap id enumeration task setup functions
  - LDAP: Rename enumeration and cleanup functions to contain the provider
  - AD: Rename enumeration functions to contain the provider name
  - LDAP: Improve ldap_id_setup_enumeration error logic
  - LDAP: Remove unnecessary task pointer
  - LDAP: Move enum fields to id provider context
  - MONITOR: Propagate error when resolv.conf does not exists in polling mode
  - MONITOR: Add a new option to control resolv.conf monitoring
  - MONITOR: Resolve symlinks setting the inotify watchers

- Sumit Bose (15):  
  - ipa: use LDAP not extdom to lookup IPA users and groups
  - utils: extend some `find_domain*()` calls to search disabled domain
  - ipa: support disabled domains
  - ipa: ignore objects from disabled domains on the client
  - sysdb: add sysdb_subdomain_content_delete()
  - ipa: delete content of disabled domains
  - ipa: use the right context for autofs
  - ssh: add ssh_use_certificate_keys option to config checks
  - ssh: apply certificate matching rules
  - ssh: add option ssh_use_certificate_matching_rules
  - ssh: enable p11_child logging
  - p11_child: allow verification with no_verification option
  - p11_child: add 'soft_ocsp' and 'soft_crl options
  - ipa: add failover to override lookups
  - ipa: add failover to access checks

- Thorsten Scherf (1):  
  - Fix option type for ldap_group_type

- Tomas Halman (9):  
  - LDAP: Systemtap ldap probes fail without filter
  - LDAP: extend LDAP systemtap probes of attr list
  - LDAP: Add probes to be able print ldap attributes
  - MAN: update systemtap man page
  - TESTS: tests have to be linked with systemtap
  - MAN: Update SystemTap man page
  - IPA: Utilize new protocol in IPA extdom plugin
  - INI: sssctl config-check giving the wrong message
  - TESTS: check "sssctl config-check" output

- pedrosam (1):  
  - cache_req: propagate multiple entries error to the caller
