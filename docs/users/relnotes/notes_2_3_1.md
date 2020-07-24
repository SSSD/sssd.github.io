# SSSD 2.3.1

## Highlights

### New features

- Domains can be now explicitly enabled or disabled using `enable` option in
  domain section. This can be especially used in configuration snippets.
- New configuration options `memcache_size_passwd`, `memcache_size_group`,
  `memcache_size_initgroups` that can be used to control memory cache size.

### Notable bug fixes

- Fixed several regressions in GPO processing introduced in sssd-2.3.0
- Fixed regression in PAM responder: failures in cache only lookups are no longer considered fatal
- Fixed regression in proxy provider: `pwfield=x` is now default value only for `sssd-shadowutils` target

### Packaging changes

- `libwbclient` is now deprecated and is not being built by default (use `--with-libwibclient` to build it)

### Documentation Changes

- Added option `memcache_size_passwd`
- Added option `memcache_size_group`
- Added option `memcache_size_initgroups`
- Added option `enable` in domain sections
- Minor text improvements

## Tickets Fixed

* [#1024](https://github.com/SSSD/sssd/issues/1024) - SSSD user/group filtering is failing after "files" provider rebuilds cache
* [#1031](https://github.com/SSSD/sssd/issues/1031) - When the passwd or group files are replaced, sssd stops monitoring the file for inotify events, and no updates are triggered
* [#3728](https://github.com/SSSD/sssd/issues/3728) - When sssd service fails to start due to misconfiguration, the error message would be nice in /var/log/messages as well
* [#3920](https://github.com/SSSD/sssd/issues/3920) - Add multiple domains tests to responder_cache_req-tests
* [#4578](https://github.com/SSSD/sssd/issues/4578) - sssctl: Add memcache diagnostic and inspection commands
* [#4667](https://github.com/SSSD/sssd/issues/4667) - sssd fails to release file descriptor on child logs after receiving HUP
* [#4743](https://github.com/SSSD/sssd/issues/4743) - [RFE] Add "enabled" option to domain section
* [#5075](https://github.com/SSSD/sssd/issues/5075) - sssd failover leads to delayed and failed logins
* [#5103](https://github.com/SSSD/sssd/issues/5103) - GPO: Incorrect processing / inheritance order of HBAC GPOs
* [#5115](https://github.com/SSSD/sssd/issues/5115) - mem-cache bug: only small fraction of memory allocated is actually used
* [#5129](https://github.com/SSSD/sssd/issues/5129) - id_provider = proxy proxy_lib_name = files returns * in password field, breaking PAM authentication
* [#5135](https://github.com/SSSD/sssd/issues/5135) - Certificate attributes are not sanitized prior to ldap search
* [#5142](https://github.com/SSSD/sssd/issues/5142) - RFE: Add option to specify alternate sssd config file location with "sssctl config-check" command.
* [#5151](https://github.com/SSSD/sssd/issues/5151) - sssd is failing to discover other subdomains in the forest if LDAP entries do not contain AD forest root information
* [#5153](https://github.com/SSSD/sssd/issues/5153) - Oddjob-mkhomedir fails when using NSS compat
* [#5155](https://github.com/SSSD/sssd/issues/5155) - Document how to prevent invalid selinux context for default home directories in SSSD-AD direct integration.
* [#5164](https://github.com/SSSD/sssd/issues/5164) - Change the message "Please enter smart card" to "Please insert smart card"  on GDM login with smart-card
* [#5167](https://github.com/SSSD/sssd/issues/5167) - AD: ad_access.c performs out-of memory check for wrong tevent request pointer
* [#5170](https://github.com/SSSD/sssd/issues/5170) - SSSD must be able to resolve membership involving root with files provider
* [#5181](https://github.com/SSSD/sssd/issues/5181) - system not enforcing GPO rule restriction. ad_gpo_implicit_deny = True is not working
* [#5183](https://github.com/SSSD/sssd/issues/5183) - sssd 2.3.0 breaks AD auth due to GPO parsing failure
* [#5186](https://github.com/SSSD/sssd/issues/5186) - sssd 2.3.0 buld errors due to issue with sv translation of man page
* [#5190](https://github.com/SSSD/sssd/issues/5190) - GDM password prompt when cert mapped to multiple users and promptusername is False
* [#5199](https://github.com/SSSD/sssd/issues/5199) - do not add fully-qualified suffix to already fully-qualified externalUser values in sudoers for IPA provider
* [#5201](https://github.com/SSSD/sssd/issues/5201) - sssd-common: missing comma in file sssd_functions.stp
* [#5217](https://github.com/SSSD/sssd/issues/5217) - NULL dereference in `rotate_debug_files()`
* [#5230](https://github.com/SSSD/sssd/issues/5230) - Deprecate SSSD's version of libwbclient
* [#5236](https://github.com/SSSD/sssd/issues/5236) - sss_ssh_knownhostsproxy leads to silent failure for non-existent or non-co-operative hosts

## Detailed changelog

- Alejandro Visiedo (2):
  - systemtap: Missing a comma
  - config: [RFE] Add "enabled" option to domain section

- Alexander Bokovoy (1):
  - ipa: Do not qualify already qualified users in sudo rules

- Alexey Tikhonov (30):
  - DEBUG: only open child process log files when required
  - CLIENT: fixed few CHECKED_RETURN (CWE-252) warnings
  - NSS: fixed FORWARD_NULL (CWE-476)
  - KCM: fixed NO_EFFECT (CWE-398)
  - PROXY: suppress CPPCHECK_WARNING (CWE-456)
  - MC: fixed CPPCHECK_WARNING
  - CLIENT: fixed CPPCHECK_WARNING (CWE-476)
  - util/inotify: fixed CLANG_WARNING
  - util/inotify: fixed bug in inotify event processing
  - TOOLS: fixed CLANG_WARNING
  - TOOLS: fixed a couple of CLANG_WARNINGs
  - CLIENT: fixed "Dereference of null pointer" warning
  - RESPONDER/SUDO: fixed CLANG_WARNING
  - RESPONDER/NSS: fixed few CLANG_WARNINGs
  - CACHE_REQ: fixed CLANG_WARNING
  - PROVIDERS/LDAP: fixed CLANG_WARNING
  - PROVIDERS/LDAP: fixed CLANG_WARNING
  - PROVIDERS/IPA: fixed few CLANG_WARNINGs
  - DEBUG: fixed potential NULL dereference
  - TRANSLATIONS: updated translations to include new source file
  - NEGCACHE: skip permanent entries in [users/groups] reset
  - NSS: fixed UNINIT (CWE-457)
  - mem-cache: sizes of free and data tables were made consistent
  - NSS: avoid excessive log messages
  - NSS: enhanced debug during mem-cache initialization
  - mem-cache: added log message in case cache is full
  - NSS: make memcache size configurable in megabytes
  - mem-cache: comment added
  - mem-cache: always cleanup old content
  - Updated translation files: Japanese, Chinese (China), French

- David Ward (1):
  - failover: fix documentation of default timeouts

- Lukas Slebodnik (2):
  - python-test.py: Do not use letter similar to numbers
  - INTG: Do not use letter similar to numbers in python code

- Michal Židek (1):
  - NSS: make memcache size configurable

- Niranjan M.R (1):
  - pytest/testlib: Remove explcit encryption types from kdc.conf

- Pavel Březina (12):
  - Update version in version.m4 to track the next release.
  - test: avoid endian issues in network tests
  - Provide new link for documentation: change sssd.github.io to sssd.io
  - pam_sss: fix missing initializer
  - files: allow root membership
  - proxy: use 'x' as default pwfield only for sssd-shadowutils target
  - monitor: log to syslog when service fails to start
  - po: fix sv translation
  - sss_ssh_knownhostsproxy: print error when unable to connect
  - sss_ssh_knownhostsproxy: print error when unable to proxy data
  - Update the translations for the 2.3.1 release
  - tests: discard const in test_confdb_get_enabled_domain_list

- Paweł Poławski (1):
  - AD: Enforcing GPO rule restriction on user

- Sumit Bose (19):
  - NSS client: preserve errno during _nss_sss_end* calls
  - ad: remove unused libsbmclient form libsss_ad.so
  - pam_sss: add SERVICE_IS_GDM_SMARTCARD
  - pam_sss: special handling for gdm-smartcard
  - ad_gpo_ndr.c: more ndr updates
  - GPO: fix link order in a SOM
  - sysdb: make sysdb_update_subdomains() more robust
  - ad: rename ad_master_domain_* to ad_domain_info_*
  - sysdb: make new_subdomain() public
  - ad: rename ads_get_root_id_ctx() to ads_get_dom_id_ctx
  - ad: remove unused trust_type from ad_subdom_store()
  - ad: add ad_check_domain_{send|recv}
  - ad: check forest root directly if not present on local DC
  - DEBUG: use new exec_child(_ex) interface in tests
  - ipa: add failover to subdomain override lookups
  - pam_sss: make sure old certificate data is removed before retry
  - PAM: do not treat error for cache-only lookups as fatal
  - libwbclient-sssd: deprecate libwbclient-sssd
  - certmap: sanitize LDAP search filter

- Thomas Reim (1):
  - Minor fix in ad_access.c out of memory check

- Tomas Halman (3):
  - sssctl: sssctl config-check alternative config file
  - man: Document invalid selinux context for homedirs
  - sssctl: sssctl config-check alternative snippet dir

- Yuri Chornoivan (1):
  - general: fix minor typos

- ikerexxe (7):
  - db/sysdb.c: remove unused variable
  - data_provider/dp_target_id: remove store statement from a never read variable
  - p11_child/p11_child_common: remove store statement from a never read variable
  - autofs_test_client and sss_tools: remove store statements from never read variables
  - responder/common/responder_packet: get packet length only once
  - Test: Add users_by_filter_multiple_domains_valid
  - Test: Add groups_by_filter_multiple_domains_valid

- vinay mishra (1):
  - Replaced 'enter' with 'insert'
