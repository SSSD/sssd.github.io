SSSD 1.13.0
===========

Highlights
----------

- Support for separate prompts when using two-factor authentication was added
- Added support for one-way trusts between an IPA and Active Directory environment. Please note that this SSSD functionality depends on IPA code that will be released in the IPA 4.2 version
- The fast memory cache now also supports the initgroups operation.
- The PAM responder is now capable of caching authentication for configurable period, which might reduce server load in cases where accounts authenticate very frequently. Please refer to the `cached_auth_timeout` option in the `sssd.conf` manual page.
- The Active Directory provider has changed the default value of the `ad_gpo_access_control` option from `permissive` to `enforcing`. As a consequence, the GPO access control now affects all clients that set `access_provider` to `ad`. In order to restore the previous behaviour, set `ad_gpo_access_control` to `permissive` or use a different `access_provider` type.
- Group Policy objects defined in a different AD domain that the computer object is defined in are now supported.
- Credential caching and Offline authentication are also available when using two-factor authentication
- Many enhancements to the InfoPipe D-Bus API. Notably, the SSSD users and groups are now exposed as first-class objects. The users and groups can also be marked as cached and would subsequently show up in the Introspection output
- The DBus interface is now also able to look up User objects by certificate. This is a first part of work that will eventually allow smart-card authentication in SSSD.
- The LDAP cleanup task is now disabled by default, unless enumeration is enabled. Please refer to the `ldap_purge_cache_timeout` option in case your environment requires the cleanup task
- The Python bindings are now built for both Python2 and Python3
- The LDAP bind timeout, StartTLS timeout and password change timeout are now configurable using the `ldap_opt_timeout` option

Packaging Changes
-----------------

- A new directory `/var/lib/sss/keytabs` is present and owned by the `sssd-ipa` subpackage. The SSSD stores keytabs for one-way trust relationships in this directory. Downstreams should make sure that the directory is only readable to the user who runs the SSSD service.
- Several packaging changes are present in this release to support the Python3 bindings, notably new `python-sss` and `python-sss-murmur` subpackages are introduced in upstream RPM packaging
- All python bindings now have a Python3 and a Python2 version in the upstream RPM packaging scheme
- The OpenSSL development library such as `openssl-devel` on RHEL/Fedora or Debian/Ubuntu `libssl-dev` is now required to support certificate operations
- A new internal library `libsss_cert.so` is present in this release.
- The fast initgroups memcache is represented by a new file `/var/lib/sss/mc/initgroups`

Documentation Changes
---------------------

- The `ad_gpo_access_control` option default has changed from `permissive` to `enforcing`
- The default value of `ldap_purge_cache_timeout` changed to 0, thus effectivelly disabling the cleanup task.
- A new option `cache_credentials_minimal_first_factor_length` was added. This option sets constraints on the password length if One-Time passwords are used and credentials are to be cached. Please see the `sssd.conf(5)` man page for more details
- The cached authentication is controlled by new option `cached_auth_timeout`. By default the cached authentication is disabled.

Tickets Fixed
-------------

- [\#897](https://pagure.io/SSSD/sssd/issue/897) sssd should pass -d to nsupdate when running with high log level
- [\#1501](https://pagure.io/SSSD/sssd/issue/1501) Make the LDAP bind operation timeout configurable
- [\#2150](https://pagure.io/SSSD/sssd/issue/2150) [RFE] Expose listing calls over D-BUS
- [\#2224](https://pagure.io/SSSD/sssd/issue/2224) nsupdate stderr is not captured
- [\#2236](https://pagure.io/SSSD/sssd/issue/2236) The cleanup task has no DEBUG statements
- [\#2326](https://pagure.io/SSSD/sssd/issue/2326) SBUS: Flush the UID cache when we receive NameOwnerChanged
- [\#2338](https://pagure.io/SSSD/sssd/issue/2338) [RFE] Implement object caching on the bus
- [\#2339](https://pagure.io/SSSD/sssd/issue/2339) IFP: support multiple interfaces for object
- [\#2540](https://pagure.io/SSSD/sssd/issue/2540) SSSD does not update Dynamic DNS records if the IPA domain differs from machine hostname's domain
- [\#2569](https://pagure.io/SSSD/sssd/issue/2569) In ipa-ad trust, with 'default_domain_suffix' set to AD domain, IPA user are not able to log unless use_fully_qualified_names is set
- [\#2574](https://pagure.io/SSSD/sssd/issue/2574) SSSD should be able to build python2 and python3 bindings in a one build
- [\#2583](https://pagure.io/SSSD/sssd/issue/2583) [RFE] Homedir is always overwritten with subdomain_homedir value in server mode
- [\#2593](https://pagure.io/SSSD/sssd/issue/2593) Does sssd-ad use the most suitable attribute for group name?
- [\#2596](https://pagure.io/SSSD/sssd/issue/2596) Add a way to lookup users based on CAC identity certificates
- [\#2603](https://pagure.io/SSSD/sssd/issue/2603) Make SSSD's HBAC validation more permissive if deny rules are not used
- [\#2609](https://pagure.io/SSSD/sssd/issue/2609) [bug] sssd always appends default_domain_suffix when checking for host keys
- [\#2618](https://pagure.io/SSSD/sssd/issue/2618) Man sssd-ad(5) lists Group Policy Management Editor naming for some policies but not for all
- [\#2620](https://pagure.io/SSSD/sssd/issue/2620) id_provider=proxy with auth_provider=ldap does not work reliably
- [\#2625](https://pagure.io/SSSD/sssd/issue/2625) Sudo responder does not respect filter_users and filter_groups
- [\#2627](https://pagure.io/SSSD/sssd/issue/2627) Disable the cleanup task by default
- [\#2636](https://pagure.io/SSSD/sssd/issue/2636) RFE: Fetch keytabs for one-way trusts in IPA subdomain code
- [\#2638](https://pagure.io/SSSD/sssd/issue/2638) RFE: Change ad_id_ctx instantiation in the IPA subdomain code to support one-way trusts
- [\#2645](https://pagure.io/SSSD/sssd/issue/2645) [RFE] Support GPOs from different domain controllers
- [\#2661](https://pagure.io/SSSD/sssd/issue/2661) RFE: Change AD GPO default to enforcing
- [\#2666](https://pagure.io/SSSD/sssd/issue/2666) sssd with ldap backend throws error domain log
- [\#1807](https://pagure.io/SSSD/sssd/issue/1807) [RFE] authenticate against cache in SSSD
- [\#2017](https://pagure.io/SSSD/sssd/issue/2017) [RFE] Python 3 support
- [\#2485](https://pagure.io/SSSD/sssd/issue/2485) [RFE] The fast memory cache should cache initgroups
- [\#2590](https://pagure.io/SSSD/sssd/issue/2590) SSSD doesn't re-read resolv.conf if the file doesn't exist during boot
- [\#2641](https://pagure.io/SSSD/sssd/issue/2641) Add a IS_DEFAULT_VIEW macro
- [\#2701](https://pagure.io/SSSD/sssd/issue/2701) Kerberos-based providers other than krb5 do not queue requests

Detailed Changelog
------------------

Jakub Hrozek (73):

- MAN: Fix a typo
- SYSDB: Reduce code duplication in sysdb_gpo.c
- UTIL: Make two child_common.c functions static
- TESTS: Cover child_common.c with unit tests
- LDAP: Use child_io_destructor instead of child_cleanup in a custom desctructor
- UTIL: Remove child_cleanup
- UTIL: Unify the fd_nonblocking implementation
- RESOLV: Remove obsolete in-tree implementation of SRV and TXT parsing
- PAM: print the pam status as string, too
- KRB5: More debugging for create_ccache()
- SDAP: Make simple bind timeout configurable
- SDAP: Make password change timeout configurable with ldap_opt_timeout
- SDAP: Make StartTLS bind configurable with ldap_opt_timeout
- SDAP: Decorate the sdap_op functions with DEBUG messages
- IPA: Remove the ipa_hbac_treat_deny_as option
- MAN: Clarify debug_level a bit
- SSH: Ignore the default_domain_suffix
- LDAP: Set sdap handle as explicitly connected in LDAP auth
- tests: Revert strcmp condition
- ncache: Fix sss_ncache_reset_permanent
- ncache: Silence critical error from filter_users when default_domain_suffix is set
- ncache: Add sss_ncache_reset_repopulate_permanent
- responders: reset ncache after domains are discovered during startup
- NSS: Reset negcache after checking domains
- MAN: Clarify how are GPO mappings called in GPO editor
- UTIL: Add a simple function to get the fd of debug_file
- dyndns: Log nsupdate stderr with a high debug level
- nsupdate: Append -d/-D to nsupdate with a high debug level
- subdom: Remove unused function get_flat_name_from_subdomain_name
- nss: Use negcache for getbysid requests
- tests: Add NSS responder tests for bysid requests
- LDAP: disable the cleanup task by default
- TESTS: Use the right testcase
- TESTS: Add test for get_next_domain
- LDAP: Do not print verbose DEBUG messages from providers that don't set UUID
- SYSDB: Store trust direction for subdomains
- UTIL/SYSDB: Move new_subdomain() to sysdb_subdomains.c and make it private
- TESTS: Add a test for sysdb_subdomains.c
- SYSDB: Add realm to sysdb_master_domain_add_info
- SYSDB: Add a forest root attribute to sss_domain_info
- IPA: Add ipa_subdomains_handler_get_{start,cont} wrappers
- IPA: Check master domain record before subdomain records
- IPA: Fold ipa_subdom_enumerates into ipa_subdom_store
- IPA: Also update master domain when initializing subdom handler
- IPA: Move server-mode functions to a separate module
- IPA: Split two functions to new module ipa_subdomains_utils.c
- IPA: Include ipaNTTrustDirection in the attribute set for trusted domains
- IPA: Read forest name for trusted forest roots as well
- IPA: Make constructing an IPA server mode context async
- TESTS: Split off keytab creation into a common module
- TESTS: Add a common mock_be_ctx function
- TESTS: Add a common function to set up sdap_id_ctx
- TESTS: Move krb5_try_kdcip to nested group test
- TESTS: Add unit test for the subdomain_server.c module
- IPA: Fetch keytab for 1way trusts
- AD: Rename ad_set_ad_id_options to ad_set_sdap_options
- AD: Rename ad_create_default_options to ad_create_2way_trust_options
- AD: Split off ad_create_default_options
- IPA/AD: Set up AD domain in ad_create_2way_trust_options
- IPA: Do not set AD_KRB5_REALM twice
- AD: Add ad_create_1way_trust_options
- IPA: Utility function for setting up one-way trust context
- LDAP: Do not set keytab through environment variable
- LDAP: Consolidate SDAP_SASL_REALM/SDAP_KRB5_REALM behaviour
- CONFIG: Add SSS_STATEDIR as VARDIR/lib/sss
- BUILD: Store keytabs in /var/lib/sss/keytabs
- Updating the translations for the 1.13 Alpha release
- Updating the version.m4 file for the 1.13 Beta release
- tests: Reduce duplication with new function test_ev_done
- KRB5: Add and use krb5_auth_queue_send to queue requests by default
- PAM: Only cache first-factor
- Updating the translations for the 1.13.0 release
- Updating the version for the 1.13.0 release

John Dickerson (1):

- MAN: Amend the description of ignore_group_members

Lukas Slebodnik (67):

- MAN: Remove indentation in element programlistening
- Fix warning: for loop has empty body
- Bump version to track 1.13 development
- SPEC: Use libnl3 for epel6
- MAKE: Don't include autoconf generated file to tarball
- TESTS: Mock return value of sdap_get_generic_recv
- test_nested_groups: Additional unit tests
- Fix warning: equality comparison with extraneous parentheses
- LDAP: Conditional jump depends on uninitialised value
- BUILD: Remove unused libraries for pysss.so
- BUILD: Remove unused variables
- BUILD: Remove detection of type Py_ssize_t
- UTIL: Remove python wrapper sss_python_set_new
- UTIL: Remove python wrapper sss_python_set_add
- UTIL: Remove python wrapper sss_python_set_check
- UTIL: Remove compatibility macro PyModule_AddIntMacro
- UTIL: Remove python wrapper sss_python_unicode_from_string
- BUILD: Use python-config for detection \*FLAGS
- SPEC: Use new convention for python packages
- SPEC: Move python bindings to separate packages
- BUILD: Add possibility to build python{2,3} bindings
- TESTS: Run python tests with all supported python versions
- SPEC: Replace python_ macros with python2_
- SPEC: Build python3 bindings on available platforms
- BUILD: Uninstall also symbolic links to python bindings
- Remove unused argument from be_nsupdate_create_fwd_msg
- IPA: Remove unused argument from ipa_id_get_group_uuids
- Remove useless assignment to function parameter
- PAC: Fix memory leak
- responder_cache: Fix warning may be used uninitialized
- debug-tests: Fix test with new line in debug message
- BUILD: Add missing header file to tarball
- pam_client: fix casting to const pointer
- test_expire: Use right assertion macro for standard functions
- test_ldap_auth: Use right assertion for integer comparison
- test_resolv_fake: Fix alignment warning
- PAC: Remove unused function
- KRB5: Unify prototype and definition
- util-tests: Initialize boolean variable to default value
- SPEC: Drop workaround for old libtool
- SPEC: Drop workarounds for old rpmbuild
- SPEC: Remove unused option
- SPEC: Few cosmetic changes
- simple_access-tests: Simplify assertion
- sysdb-tests: Add missing assertions
- sysdb-tests: test return value before output arguments
- ad_opts: Use different default attribute for group name
- BUILD: Write hints about optional python bindings
- sss_client: Fix mixed enums
- LDAP: Remove dead assignment
- sss_client: Fix warning "_" redefined
- SSSDConfigTest: Use unique temporary directory
- util-tests: Add validation of internal error messages
- SDAP: Check return value before using output arguments
- SDAP: Log failure from sysdb_handle_original_uuid
- test_ipa_subdomains_server: Run clean-up after success
- IFP: Fix warnings with enabled optimisation
- SDAP: Remove user from cache for missing user in LDAP
- test_ipa_subdom_server: Add missing assert
- test_ipa_subdomains_server: Fix build with --coverage
- nss: Store entries in responder to initgr mmap cache
- mmap_cache: Invalidate entry in right memory cache
- nss: Invalidate entry in initgr mmap cache
- sss_client: Use initgr mmap cache in client code
- sss_cache: Clear also initgroups fast cache
- sss_client: Use unique lock for memory cache
- sss_client: Re-check memcache after acquiring the lock

Michal Zidek (5):

- Use FQDN if default domain was set
- MAN: default_domain_suffix with use_fully_qualified_names.
- views: Add is_default_view helper function
- MONITOR: Poll for resolv.conf if not available during boot
- MONITOR: Do not report missing file as fatal in monitor_config_file

Nikolai Kondrashov (3):

- BUILD: Add AM_PYTHON2_MODULE macro
- Add integration tests
- BUILD: Fix variable substitution in cwrap.m4

Pavel Březina (53):

- tests: refactor create_dom_test_ctx()
- tests: add create_multidom_test_ctx()
- tests: add test_multidom_suite_cleanup()
- tests: remove code duplication in single domain cleanup
- responders: new interface for cache request
- responders: enable views in cache request
- IFP: use new cache interface
- server-tests: use strtouint32 instead strtol
- sbus: add new iface via sbus_conn_register_iface()
- sbus: move iface and object path code to separate file
- sbus: use 'path/\*' to represent a D-Bus fallback
- sbus: support multiple interfaces on single path
- sbus: add object path to sbus request
- sbus: add sbus_opath_hash_lookup_supported()
- sbus: support org.freedesktop.DBus.Introspectable
- sbus: support org.freedesktop.DBus.Properties
- sbus: unify naming of handler data variable
- sbus: move common opath functions from ifp to sbus code
- sbus: add sbus_opath_get_object_name()
- ifp: fix potential memory leak in check_and_get_component_from_path()
- sbus: use hard coded getters instead of generated
- sbus: remove unused 'reply as' functions
- IFP: move interface definitions from ifpsrv.c into separate file
- IFP: unify generated interfaces names
- sbus codegen: do not prefix getters with iface name
- IFP: simplify object path constant names
- sbus: add constant to represent subtree
- be_refresh: get rid of callback pointers
- sysdb: use sysdb_user/group_dn
- cache_req tests: rename test_user to test_user_by_name
- cache_req tests: define user name constant
- cache_req: preparations for different input type
- cache_req: add support for user by UID
- cache_req: add support for group by name
- cache_req: remove default branch from switches
- cache_req: add support for group by id
- cmocka: include mock_parse_inp in header file
- cache_req: parse input name if needed
- cache_req: return ERR_INTERNAL if more than one entry is found
- sbus: provide custom error names
- sbus: add sbus_opath_decompose[_exact]
- sbus: add a{sas} get invoker
- IFP: add org.freedesktop.sssd.infopipe.Users
- IFP: add org.freedesktop.sssd.infopipe.Users.User
- IFP: add org.freedesktop.sssd.infopipe.Groups
- IFP: add org.freedesktop.sssd.infopipe.Groups.Group
- IFP: deprecate GetUserAttr
- IFP: Implement org.freedesktop.sssd.infopipe.Cache[.Object]
- SBUS: Use default GetAll invoker if none is set
- SBUS: Add support for &lt;node /&gt; in introspection
- IFP: Export nodes
- sbus: add support for incoming signals
- sbus: listen to NameOwnerChanged

Pavel Reichl (20):

- add missing '\\n' in debug messages
- PROXY: add missing space in debug message
- BUILD: fix chmake not to generate warning
- SDAP: log expired accounts at lower severity level
- KRB5: add debug hint
- TESTS: test expiration
- ldap: refactor check_pwexpire_kerberos to use util func
- ldap: refactor nds_check_expired to use util func
- Fix a few typos in comments
- sbus: sbus_opath_hash_add_iface free tmp talloc ctx
- krb5: remove field run_as_user
- localauth plugin: fix coverity warning
- dyndns: remove dupl declaration of ipa_dyndns_update
- dyndns: don't pass zone directive to nsupdate
- dyndns: ipa_dyndns.h missed declaration of used data
- krb: remove duplicit decl. of write_krb5info_file
- IPA: Don't override homedir with subdomain_homedir
- sysdb: new attribute lastOnlineAuthWithCurrentToken
- PAM: authenticate agains cache
- Minor code improvements

Stephen Gallagher (5):

- LDAP: Support returning referral information
- AD GPO: Support processing referrals
- AD GPO: Change default to "enforcing"
- Add Vagrant configuration for SSSD
- GPO: Fix incorrect strerror on GPO access denial

Sumit Bose (22):

- Add leak check and command line option to test_authtok
- utils: add sss_authtok_[gs]et_2fa
- pam: handle 2FA authentication token in the responder
- Add pre-auth request
- krb5-child: add preauth and split 2fa token support
- IPA: create preauth indicator file at startup
- pam_sss: add pre-auth and 2fa support
- Add cache_credentials_minimal_first_factor_length config option
- sysdb: add sysdb_cache_password_ex()
- krb5: save hash of the first authentication factor to the cache
- krb5: try delayed online authentication only for single factor auth
- 2FA offline auth
- pam_sss: move message encoding into separate file
- PAM: add PAM responder unit test
- adding ldap_user_auth_type where missing
- LDAP: add ldap_user_certificate option
- certs: add PEM/DER conversion utilities
- sysdb: add sysdb_search_user_by_cert() and sysdb_search_object_by_cert()
- LDAP/IPA: add user lookup by certificate
- ncache: add calls for certificate based searches
- utils: add get_last_x_chars()
- IFP: add FindByCertificate method for User objects
