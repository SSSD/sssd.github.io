SSSD 1.16.5
===========

Highlights
----------

### New Features

- New option ad_gpo_ignore_unreadable was added that allows SSSD to ignore unreadable GPO containers in AD.
- It is possible to configure auto_private_groups per subdomain or with subdomain_inherit.

### Security issues fixed

- A flaw was found in sssd Group Policy Objects implementation. When the GPO is not readable by SSSD due to a too strict permission settings on the server side, SSSD will allow all authenticated users to login instead of denying access. (CVE-2018-16838)

### Notable bug fixes

- Multiple URI specified in ldap_uri did not work properly if they differed only in port number.
- Several issues with SUDO rules processing have been fixed.
- SSSD sometimes incorrectly started in offline mode. This was fixed.
- Issue with missing nested groups after add/remove operation on the sever was fixed.
- A use-after-free error causing SSSD service to crash was fixed.

Tickets Fixed
-------------

- [3960](https://pagure.io/SSSD/sssd/issue/3960) - cached_auth_timeout not honored for AD users authenticated via trust with FreeIPA
- [3974](https://pagure.io/SSSD/sssd/issue/3974) - Write a list of host names up to a configurable limit to the kdcinfo files
- [3867](https://pagure.io/SSSD/sssd/issue/3867) - [RFE] Need an option in SSSD so that it will skip GPOs that have groupPolicyContainers, unreadable by SSSD
- [3965](https://pagure.io/SSSD/sssd/issue/3965) - [RFE]: Optionally disable generating auto private groups for subdomains of an AD provider
- [3957](https://pagure.io/SSSD/sssd/issue/3957) - sudo: runAsUser/Group does not work with domain_resolution_order
- [3838](https://pagure.io/SSSD/sssd/issue/3838) - KCM: If the default ccache cannot be found, fall back to the first one
- [3467](https://pagure.io/SSSD/sssd/issue/3467) - online detection in case sssd starts before network does appears to be broken
- [3964](https://pagure.io/SSSD/sssd/issue/3964) - Responders: `is_user_local_by_name()` should avoid calling nss API entirely
- [3975](https://pagure.io/SSSD/sssd/issue/3975) - Lookahead resolving of host names to provide names for the kdcinfo plugin
- [4015](https://pagure.io/SSSD/sssd/issue/4015) - The server error message is not returned if password change fails
- [3917](https://pagure.io/SSSD/sssd/issue/3917) - Double free error in tev_curl
- [3905](https://pagure.io/SSSD/sssd/issue/3905) - SSSD doesn't clear cache entries for IDs below min_id.
- [2854](https://pagure.io/SSSD/sssd/issue/2854) - FAIL test-find-uid
- [2878](https://pagure.io/SSSD/sssd/issue/2878) - sssd failover does not work on connecting to non-responsive <ldaps://server
- [4050](https://pagure.io/SSSD/sssd/issue/4050) - nss_cmd_endservent resets the wrong index
- [4009](https://pagure.io/SSSD/sssd/issue/4009) - Removing domain from ad_enabled_domains is not reflected in cache
- [4058](https://pagure.io/SSSD/sssd/issue/4058) - Paging not enabled when fetching external groups, limits the number of external groups to 2000
- [2607](https://pagure.io/SSSD/sssd/issue/2607) - sssd should not always read entire autofs map from ldap
- [4065](https://pagure.io/SSSD/sssd/issue/4065) - IFP: GetUserAttr does not search by UPN
- [4078](https://pagure.io/SSSD/sssd/issue/4078) - Trusted domain user logins succeed after using ipa trustdomain-disable
- [4074](https://pagure.io/SSSD/sssd/issue/4074) - Integration tests use python2 unconditionally
- [4116](https://pagure.io/SSSD/sssd/issue/4116) - autofs: delete possible duplicate of an autofs entry
- [2660](https://pagure.io/SSSD/sssd/issue/2660) - SSSD service is crashing: dbus_watch_handle() is invoked with corrupted 'watch' value
- [3996](https://pagure.io/SSSD/sssd/issue/3996) - sudo: do not update last usn when updating expired rules
- [3997](https://pagure.io/SSSD/sssd/issue/3997) - sudo: always use server highest usn for smart refresh
- [4046](https://pagure.io/SSSD/sssd/issue/4046) - sudo: incorrect usn value for openldap
- [4085](https://pagure.io/SSSD/sssd/issue/4085) - support for defaults entry is failing in sssd sudo against Openldap server
- [4124](https://pagure.io/SSSD/sssd/issue/4124) - Impossible to enforce GID on the AD's "domain users" group in the IPA-AD trust setup
- [3463](https://pagure.io/SSSD/sssd/issue/3463) - TESTS: make intgcheck is not always passing in the internal CI (enumeration tests)
- [4131](https://pagure.io/SSSD/sssd/issue/4131) - Force LDAPS over 636 with AD Provider
- [4089](https://pagure.io/SSSD/sssd/issue/4089) - Watchdog implementation or usage is incorrect
- [3636](https://pagure.io/SSSD/sssd/issue/3636) - nested group missing after updates on provider
- [4112](https://pagure.io/SSSD/sssd/issue/4112) - ldap_uri failover doesn't work with different ports
- [4148](https://pagure.io/SSSD/sssd/issue/4148) - Expecting appropriate error message when new password length is less than 8 characters when ldap_pwmodify_mode = ldap_modify in sssd.conf
- [4168](https://pagure.io/SSSD/sssd/issue/4168) - SSSD-1-16: sbus_auto_reconnect(): "off-by-one error" in `reconnection_retries` interpretation \`

Packaging Changes
-----------------

- None.

Documentation Changes
---------------------

- Added new option ldap_sasl_maxssf
- Added new option ad_gpo_ignore_unreadable

Detailed Changelog
------------------

- Alexey Tikhonov (13):  
  - Util: added facility to load nss lib syms
  - responder/negcache: avoid calling nsswitch NSS API
  - negcache_files: got rid of large array on stack
  - TESTS: moved cwrap/test_negcache to cmocka tests
  - ci/sssd.supp: getpwuid() leak suppression
  - util/tev_curl: Fix double free error in schedule_fd_processing()
  - util/find_uid.c: fixed debug message
  - util/find_uid.c: fixed race condition bug
  - providers/ipa/: add_v1_user_data() amended
  - SBUS: defer deallocation of sbus_watch_ctx
  - util/watchdog: fixed watchdog implementation
  - TESTS: added sss_ptr_hash unit test
  - SBUS: fixed off-by-one error" in sbus_auto_reconnect()

- Branen Salmon (1):  
  - knownhostsproxy: friendly error msg for NXDOMAIN

- Fabiano Fidêncio (1):  
  - INTG: Increase the sleep() time so the changes are reflected on SSSD

- Jakub Hrozek (34):  
  - Updating the version for 1.16.5
  - SYSDB: Inherit cached_auth_timeout from the main domain
  - AD: Allow configuring auto_private_groups per subdomain or with subdomain_inherit
  - SDAP: Add sdap_has_deref_support_ex()
  - IPA: Use dereference for host groups even if the configuration disables dereference
  - KCM: Fall back to using the first ccache if the default does not exist
  - krb5: Do not use unindexed objectCategory in a search filter
  - SYSDB: Index the ccacheFile attribute
  - krb5: Silence an error message if no cache entries have ccache stored but renewal is enabled
  - PAM: Also cache SSS_PAM_PREAUTH
  - LDAP: Return the error message from the extended operation password change also on failure
  - TESTS: Add a unit test for UPNs stored by sss_ncache_prepopulate
  - IPA: Allow paging when fetching external groups
  - SYSDB: Add sysdb_search_with_ts_attr
  - BE: search with sysdb_search_with_ts_attr
  - BE: Enable refresh for multiple domains
  - BE: Make be_refresh_ctx_init set up the periodical task, too
  - BE/LDAP: Call be_refresh_ctx_init() in the provider libraries, not in back end
  - BE: Pass in attribute to look up with instead of hardcoding SYSDB_NAME
  - BE: Change be_refresh_ctx_init to return errno and set be_ctx-&gt;refresh_ctx
  - BE/LDAP: Split out a helper function from sdap_refresh for later reuse
  - BE: Pass in filter_type when creating the refresh account request
  - BE: Send refresh requests in batches
  - BE: Extend be_ptask_create() with control when to schedule next run after success
  - BE: Schedule the refresh interval from the finish time of the last run
  - AD: Implement background refresh for AD domains
  - IPA: Implement background refresh for IPA domains
  - BE/IPA/AD/LDAP: Add inigroups refresh support
  - BE/IPA/AD/LDAP: Initialize the refresh callback from a list to reduce logic duplication
  - IPA/AD/SDAP/BE: Generate refresh callbacks with a macro
  - MAN: Amend the documentation for the background refresh
  - DP/SYSDB: Move the code to set initgrExpireTimestamp to a reusable function
  - IPA/AD/LDAP: Increase the initgrExpireTimestamp after finishing refresh request
  - sudo: use objectCategory instead of objectClass in ad sudo provider

- Lukas Slebodnik (16):  
  - BUILD: Add macro for checking python3 modules
  - BUILD: Fix typo of detecting python module for intgcheck
  - BUILD: Move checking of python2 modules for intgcheck
  - BUILD: Add macro for checking pytest for intgcheck
  - BUILD: Change value of variable HAVE_PYTHON2/3_BINDINGS
  - BUILD: Move python checks for intgcheck to macro
  - INTG: Do hot hardcode version of python/pytest in intgcheck
  - BUILD: Prefer python3 for intgcheck
  - intg: Install python3 dependencies for intgcheck on new distros
  - pyhbac: Fix warning Wdiscarded-qualifiers
  - SSSDConfig: Add minimal test for parse method
  - SSSDConfig: Fix SyntaxWarning "is not" with a literal
  - TESTS: Add minimal test for pysss encrypt
  - pysss: Fix DeprecationWarning PY_SSIZE_T_CLEAN
  - pysss_murmur: Fix DeprecationWarning PY_SSIZE_T_CLEAN
  - testlib: Fix SyntaxWarning "is" with a literal

- Michal Židek (3):  
  - GPO: Add option ad_gpo_ignore_unreadable
  - Updated translation files.
  - translation: Add missing new lines

- Pavel Březina (79):  
  - ipa: store sudo runas attribute with internal fqname
  - sudo: format runas attributes to correct output name
  - ci: enable sssd-ci for 1-16 branch
  - ci: switch to new tooling and remove 'Read trusted files' stage
  - ci: rebase pull request on the target branch
  - ci: print node on which the test is being run
  - ad: remove subdomain that has been disabled through ad_enabled_domains from sysdb
  - sysdb: add sysdb_domain_set_enabled()
  - ad: set enabled=false attribute for subdomains that no longer exists
  - sysdb: read and interpret domain's enabled attribute
  - sysdb: add sysdb_list_subdomains()
  - ad: remove all subdomains if only master domain is enabled
  - ad: make ad_enabled_domains case insensitive
  - sss_ptr_hash: add sss_ptr_get_value to make it useful in delete callbacks
  - sss_ptr_hash: keep value pointer when destroying spy
  - autofs: fix typo in test tool
  - sysdb: add expiration time to autofs entries
  - sysdb: add sysdb_get_autofsentry
  - sysdb: add enumerationExpireTimestamp
  - sysdb: store enumeration expiration time in autofs map
  - sysdb: store original dn in autofs map
  - sysdb: add sysdb_del_autofsentry_by_key
  - autofs: move data provider functions to responder common code
  - cache_req: add autofs map entries plugin
  - cache_req: add autofs map by name plugin
  - cache_req: add autofs entry by name plugin
  - autofs: convert code to cache_req
  - autofs: use cache_req to obtain single entry in getentrybyname
  - autofs: use cache_req to obtain map in setent
  - dp: replace autofs handler with enumerate method
  - dp: add additional autofs methods
  - ldap: add base_dn to sdap_search_bases
  - ldap: rename sdap_autofs_get_map to sdap_autofs_enumerate
  - ldap: implement autofs get map
  - ldap: implement autofs get entry
  - autofs: allow to run only setent without enumeration in test tool
  - autofs: always refresh auto.master
  - sysdb: invalidate also autofs entries
  - sss_cache: invalidate also autofs entries
  - ci: add Debian 10
  - ci: allow distribution specific supression files
  - ci: suppress Debian valgrind errors
  - ifp: let cache_req parse input name so it can fallback to upn search
  - ifp: call tevent_req_post in case of error in ifp_user_get_attr_send
  - ci: add Debian suppresion path
  - ci: use python2 version of pytest
  - ci: pep8 was renamed to pycodestyle in Fedora 31
  - ci: remove left overs from previous rebase
  - pysss: use METH_VARARGS | METH_KEYWORDS instead of just METH_KEYWORDS
  - ci: enable on demand runs
  - ci: set build name to pull request or branch name
  - ci: notify that build awaits executor
  - ci: convert to scripted pipeline
  - autofs: remove unused enum
  - autofs: delete possible duplicate of an autofs entry
  - ci: store artifacts in jenkins for on-demand runs
  - ci: allow to specify systems where tests should be run for on-demand tests
  - ci: add Fedora 31
  - ci: install python2 on Fedora 31 and RHEL 8 so python2 bindings can be built
  - ci: disable python2 bindings on Fedora 32+
  - sudo: do not update last usn value on rules refresh
  - sudo: always use server highest known usn for smart refresh
  - man: update sudo smart refresh documentation to reflect new USN behavior
  - sudo: use proper datetime for default modifyTimestamp value
  - sudo: get timezone information from previous value when constructing new usn
  - sudo: add ldap_sudorule_object_class_attr
  - nss: use real primary gid if the value is overriden
  - ci: add rhel7
  - ci: set sssd-ci notification to pending state when job is started
  - ci: archive ci-mock-result
  - tests: fix race condition in enumeration tests
  - ci: add CentOS 7
  - sss_sockets: pass pointer instead of integer
  - memberof: keep memberOf attribute for nested member
  - ci: keep system list outside repository
  - ci: remove old dependency repository
  - sss_ptr_hash: pass new hash_entry_t to custom delete callback
  - failover: make sure we switch to another server if only port differs
  - sdap: provide error message when password change fail in ldap_modify mode

- Samuel Cabrero (2):  
  - SUDO: Allow defaults sudoRole without sudoUser attribute
  - nss: Fix command 'endservent' resetting wrong struct member

- Simo Sorce (1):  
  - Add TCP level timeout to LDAP services

- Sumit Bose (30):  
  - ipa: ipa_getkeytab don't call libnss_sss
  - pam: introduce prompt_config struct
  - authtok: add dedicated type for 2fa with single string
  - pam_sss: use configured prompting
  - PAM: add initial prompting configuration
  - getsockopt_wrapper: add support for PAM clients
  - intg: add test for password prompt configuration
  - winbind idmap plugin: update struct idmap_domain to latest version
  - SDAP: allow GSS-SPNEGO for LDAP SASL bind as well
  - sdap: inherit SDAP_SASL_MECH if not set explicitly
  - DP: add NULL check to `be_ptask()`{enable|disable}
  - tests: fix enctypes in test_copy_keytab
  - CI: use python3-pep8 on Fedora 31 and later
  - BUILD: fix libpython handling in Python3.8
  - negcache: add fq-usernames of know domains to all UPN neg-caches
  - ci: add pam wrapper
  - utils: extend some `find_domain*()` calls to search disabled domain
  - ipa: support disabled domains
  - ipa: ignore objects from disabled domains on the client
  - sysdb: add sysdb_subdomain_content_delete()
  - ipa: delete content of disabled domains
  - ipa: use LDAP not extdom to lookup IPA users and groups
  - ipa: use the right context for autofs
  - ipa: add failover to override lookups
  - ipa: add failover to access checks
  - sdap: update last_usn on reconnect
  - ad: allow booleans for ad_inherit_opts_if_needed()
  - ad: add ad_use_ldaps
  - ldap: add new option ldap_sasl_maxssf
  - ad: set min and max ssf for ldaps

- Tomas Halman (7):  
  - krb5: Write multiple dnsnames into kdc info file
  - Providers: Delay online check on startup
  - krb5: Lookahead resolving of host names
  - CACHE: SSSD doesn't clear cache entries
  - LDAP: failover does not work on non-responsive ldaps
  - CONFDB: Files domain if activated without .conf
  - TESTS: adapt tests to enabled default files domain
