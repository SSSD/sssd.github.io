SSSD 2.1.0
==========

Highlights
----------

### New features

- Any provider can now match and map certificates to user identities. This feature enables to log in with a smart card without having to store the full certificate blob in the directory or in user overrides. Please see [The design page](https://docs.pagure.org/SSSD.sssd/design_pages/certmaps_for_LDAP_AD_file.html) for more information (\#3500)
- `pam_sss` can now be configured to only perform Smart Card authentication or return an error if this is not possible.
- `pam_sss` can also prompt the user to insert a Smart Card if, during an authentication it is not available. SSSD would then wait for the card until it is inserted or until timeout defined by `p11_wait_for_card_timeout` passes.
- The device or reader used for Smart Card authentication can now be selected or restricted using a PKCS\#11 URI (see RFC-7512) specified in the `p11_uri` option.
- Multiple certificates are now supported for Smart Card authentication even if SSSD is built with OpenSSL
- OCSP checks were added to the OpenSSL version of certificate authentication
- A new option `crl_file` can be used to select a Certificate Revocation List (CRL) file to be used during verification of a certificate for Smart Card authentication.
- Certificates with Elliptic Curve keys are now supported (\#3887)
- It is now possible to refresh the KCM configuration without restarting the whole SSSD deamon, just by modifying the `[kcm]` section of `sssd.conf` and running `systemctl restart sssd-kcm.service`.
- A new configuration option `ad_gpo_implicit_deny` was added. This option (when set to True) can be used to deny access to users even if there is not applicable GPO. Normally users are allowed access in this situation. (\#3701)
- The dynamic DNS update can now batch DNS updates to include all address family updates in a single transaction to reduce replication traffic in complex environments (\#3829)
- Configuration file snippets can now be used even when the main `sssd.conf` file does not exist. This is mostly useful to configure e.g. the KCM responder, the implicit files provider or the session recording with setups that have no explicit domain (\#3439)
- The `sssctl user-checks` tool can now display extra attributes set with the InfoPipe `user_attributes` configuraton option (\#3866)

### Security issues fixed

- CVE-2019-3811: SSSD used to return "/" in case a user entry had no home directory. This was deemed a security issue because this flaw could impact services that restrict the user's filesystem access to within their home directory. An empty home directory field would indicate "no filesystem access", where sssd reporting it as "/" would grant full access (though still confined by unix permissions, SELinux etc).

### Notable bug fixes

- Many fixes for the internal "sbus" IPC that was rewritten in the 2.0 release including crash on reconnection (\#3821), a memory leak (\#3810), a proxy provider startup crash (\#3812), sudo responder crash (\#3854), proxy provider authentication (\#3892), accessing the `extraAttributes` InfoPipe property (\#3906) or a potential startup failure (\#3924)
- The Active Directory provider now fetches the user information from the LDAP port and switches to using the Global Catalog port, if available for the group membership. This fixes an issue where some attributes which are not available in the Global Catalog, typically the home directory, would be removed from the user entry. (\#2474)
- Session recording can now be enabled also for local users when the session recording is configured with `scope=some` and restricted to certain groups.
- Smart Card authentication did not work with the KCM credentials cache because with KCM root cannot write to arbitrary user's credential caches (\#3903)
- A KCM bug that prevented SSH Kerberos credential forwarding from functioning was fixed (\#3873)
- The KCM responder did not work with completely empty database (\#3815)
- The sudo responder did not reflect the case_sensitive domain option (\#3820)
- The SSH responder no longer fails completely if the `p11_child` times out when deriving SSH keys from a certificate (\#3937)t
- An issue that caused SSSD to sometimes switch to offline mode in case not all domains in the forest ran the Global Catalog service was fixed (\#3902)
- If any of the SSSD responders was too busy, that responder wouldn't have refreshed the trusted domain list (\#3967)
- The IPA SELinux provider now sets the user login context even if it is the same as the system default. This is important in case the user has a non-standard home directory, because then only adding the user to the SELinux database ensures the home directory will be labeled properly. However, this fix causes a performance hit during the first login as the context must be written into the semanage database.
- A memory leak when requesting netgroups repeatedly was fixed (\#3870)
- The `pysss.getgrouplist()` interface that was removed by accident in the 2.0 version was re-added (\#3493)
- Crash when requesting users with the `FindByNameAndCertificate` D-Bus method was fixed (\#3863)
- SSSD can again run as the non-privileged sssd user (\#3871)
- The cron PAM service name used for GPO access control now defaults to a different service name depending on the OS (Launchpad \#1572908)

Packaging Changes
-----------------

- The sbus code generator no longer relies on existance of the "python" binary, the python2/3 binary is used depending on which bindings are being generated (\#3807)
- Very old libini library versions are no longer supported

Documentation Changes
---------------------

- Two new `pam_sss` options `try_cert_auth` and `require_cert_auth` can restrict authentication to use a Smart Card only or wait for a Smart Card to be inserted.
- A new option `p11_wait_for_card_timeout` controls how long would SSSD wait for a Smart Card to be inserted before failing with `PAM_AUTHINFO_UNAVAIL`.
- A new option `p11_uri` is available to restrict the device or reader used for Smart Card authentication.

Tickets Fixed
-------------

- [3967](https://pagure.io/SSSD/sssd/issue/3967) - NSS responder does no refresh domain list when busy
- [3961](https://pagure.io/SSSD/sssd/issue/3961) - sssd config-check reports an error for a valid configuration option
- [3958](https://pagure.io/SSSD/sssd/issue/3958) - sssd_krb5_locator_plugin introduces delay in cifs.upcall krb5 calls
- [3949](https://pagure.io/SSSD/sssd/issue/3949) - gdm login not prompting for username when smart card maps to multiple users
- [3942](https://pagure.io/SSSD/sssd/issue/3942) - RemovedInPytest4Warning: Fixture "passwd_ops_setup" called directly
- [3937](https://pagure.io/SSSD/sssd/issue/3937) - If p11_child spawned from sssd_ssh times out, sssd_ssh fails completely
- [3936](https://pagure.io/SSSD/sssd/issue/3936) - Missing sssd-files in last section(SEE ALSO) of sssd man pages
- [3924](https://pagure.io/SSSD/sssd/issue/3924) - "Corrupted" name of "Hello" method of org.freedesktop.DBus sssd sbus interface on Fedora Rawhide
- [3921](https://pagure.io/SSSD/sssd/issue/3921) - crash when requesting extra attributes
- [3919](https://pagure.io/SSSD/sssd/issue/3919) - sss_cache prints spurious error messages when invoked from shadow-utils on package install
- [3917](https://pagure.io/SSSD/sssd/issue/3917) - Double free error in tev_curl
- [3916](https://pagure.io/SSSD/sssd/issue/3916) - Wrong spelling of method
- [3912](https://pagure.io/SSSD/sssd/issue/3912) - incorrect example in the man page of idmap_sss suggests using \* for backend sss
- [3911](https://pagure.io/SSSD/sssd/issue/3911) - Re-setting the trusted AD domain fails due to wrong subdomain service name being used
- [3910](https://pagure.io/SSSD/sssd/issue/3910) - KCM destroy operation returns KRB5_CC_NOTFOUND, should return KRB5_FCC_NOFILE if non-existing ccache is about to be destroyed
- [3909](https://pagure.io/SSSD/sssd/issue/3909) - SSSD 2.0 has drastically lower sbus timeout than 1.x, this can result in time outs
- [3906](https://pagure.io/SSSD/sssd/issue/3906) - extraAttributes is org.freedesktop.DBus.Error.UnknownProperty: Unknown property
- [3903](https://pagure.io/SSSD/sssd/issue/3903) - PKINIT with KCM does not work
- [3902](https://pagure.io/SSSD/sssd/issue/3902) - SSSD must be cleared/restarted periodically in order to retrieve AD users through IPA Trust
- [3901](https://pagure.io/SSSD/sssd/issue/3901) - sssd returns '/' for emtpy home directories
- [3896](https://pagure.io/SSSD/sssd/issue/3896) - sss_cache shouldn't return ENOENT when no entries match
- [3892](https://pagure.io/SSSD/sssd/issue/3892) - The proxy provider does not copy reply from the child
- [3890](https://pagure.io/SSSD/sssd/issue/3890) - SSSD changes the memory cache file ownership away from the SSSD user when running as root
- [3889](https://pagure.io/SSSD/sssd/issue/3889) - Abort LDAP authentication if the check_encryption function finds out the connection is not authenticated
- [3887](https://pagure.io/SSSD/sssd/issue/3887) - sssd support for for smartcards using ECC keys
- [3882](https://pagure.io/SSSD/sssd/issue/3882) - Missing concise documentation about valid options for sssd-files-provider
- [3876](https://pagure.io/SSSD/sssd/issue/3876) - Unable to su to root when logged in as a local user
- [3875](https://pagure.io/SSSD/sssd/issue/3875) - CURLE_SSL_CACERT is deprecated in recent curl versions
- [3874](https://pagure.io/SSSD/sssd/issue/3874) - RefreshRules_recv marks the wrong request as done
- [3873](https://pagure.io/SSSD/sssd/issue/3873) - Perform some basic ccache initialization as part of gen_new to avoid a subsequent switch call failure
- [3872](https://pagure.io/SSSD/sssd/issue/3872) - SSSD 2.x does not sanitize domain name properly for D-bus, resulting in a crash
- [3871](https://pagure.io/SSSD/sssd/issue/3871) - sbus: allow non-root execution
- [3866](https://pagure.io/SSSD/sssd/issue/3866) - sssctl user-checks does not show custom IFP user_attributes
- [3865](https://pagure.io/SSSD/sssd/issue/3865) - Off-by-one error in retrieving host name causes hostnames with exactly 64 characters to not work
- [3863](https://pagure.io/SSSD/sssd/issue/3863) - sssd ifp crash when trying FindByNameAndCertificate
- [3862](https://pagure.io/SSSD/sssd/issue/3862) - Restarting the sssd-kcm service should reload the configuration without having to restart the whole sssd
- [3858](https://pagure.io/SSSD/sssd/issue/3858) - sssctl user-show says that user is expired if the user comes from files provider
- [3855](https://pagure.io/SSSD/sssd/issue/3855) - session not recording for local user when groups defined
- [3854](https://pagure.io/SSSD/sssd/issue/3854) - sudo: sbus2 related crash
- [3849](https://pagure.io/SSSD/sssd/issue/3849) - Files: The files provider always enumerates which causes duplicate when running getent passwd
- [3848](https://pagure.io/SSSD/sssd/issue/3848) - pam_unix unable to match fully qualified username provided by sssd during smartcard auth using gdm
- [3845](https://pagure.io/SSSD/sssd/issue/3845) - The config file validator says that certmap options are not allowed
- [3841](https://pagure.io/SSSD/sssd/issue/3841) - The simultaneous use of strncpy and a length-check in client code is confusing Coverity
- [3830](https://pagure.io/SSSD/sssd/issue/3830) - Printing incorrect information about domain with sssctl utility
- [3829](https://pagure.io/SSSD/sssd/issue/3829) - SSSD does not batch DDNS update requests
- [3828](https://pagure.io/SSSD/sssd/issue/3828) - Invalid domain provider causes SSSD to abort startup
- [3827](https://pagure.io/SSSD/sssd/issue/3827) - SSSD should log to syslog if a domain is not started due to a misconfiguration
- [3826](https://pagure.io/SSSD/sssd/issue/3826) - Remove references of sss_user/group/add/del commands in man pages since local provider is deprecated
- [3821](https://pagure.io/SSSD/sssd/issue/3821) - crash related to sbus_router_destructor()
- [3815](https://pagure.io/SSSD/sssd/issue/3815) - KCM: The secdb back end might fail creating a new ID with a completely empty database
- [3814](https://pagure.io/SSSD/sssd/issue/3814) - [RFE] Add option to specify a Smartcard with a PKCS\#11 URI
- [3813](https://pagure.io/SSSD/sssd/issue/3813) - sssd startup issues since 1.16.2 (PID file related)
- [3812](https://pagure.io/SSSD/sssd/issue/3812) - sssd 2.0.0 segfaults on startup
- [3810](https://pagure.io/SSSD/sssd/issue/3810) - sbus2: fix memory leak in sbus_message_bound_ref
- [3807](https://pagure.io/SSSD/sssd/issue/3807) - The sbus codegen script relies on "python" which might not be available on all distributions
- [3802](https://pagure.io/SSSD/sssd/issue/3802) - Reuse sysdb_error_to_errno() outside sysdb
- [3798](https://pagure.io/SSSD/sssd/issue/3798) - When passwords are set to cache=false, userCertificate auth fails when backend is offline
- [3797](https://pagure.io/SSSD/sssd/issue/3797) - When AD provider is offline, usercertmap fails
- [3701](https://pagure.io/SSSD/sssd/issue/3701) - [RFE] Allow changing default behavior of SSSD from an allow-any default to a deny-any default when it can't find any GPOs to apply to a user login.
- [3650](https://pagure.io/SSSD/sssd/issue/3650) - RFE: Require smartcard authentication
- [3598](https://pagure.io/SSSD/sssd/issue/3598) - [RFE] Allow sssd to read the certificate attributes instead of blob look-up against the LDAP
- [3576](https://pagure.io/SSSD/sssd/issue/3576) - sssd-kcm failed to start on F-27 after installing sssd-kcm
- [3567](https://pagure.io/SSSD/sssd/issue/3567) - SYSDB: Lowercased email is stored as nameAlias
- [3500](https://pagure.io/SSSD/sssd/issue/3500) - Make sure sssd is a replacement for pam_pkcs11 also for local account authentication
- [3489](https://pagure.io/SSSD/sssd/issue/3489) - p11_child should work wit openssl1.0+
- [3451](https://pagure.io/SSSD/sssd/issue/3451) - When sssd is configured with id_provider proxy and auth_provider ldap, login fails if the LDAP server is not allowing anonymous binds.
- [3439](https://pagure.io/SSSD/sssd/issue/3439) - Snippets are not used when sssd.conf does not exist
- [3413](https://pagure.io/SSSD/sssd/issue/3413) - a bug in libkrb5 causes kdestroy -A to not work with more than 2 principals with KCM
- [3334](https://pagure.io/SSSD/sssd/issue/3334) - sssctl config-check does not check any special characters in domain name of domain section
- [3333](https://pagure.io/SSSD/sssd/issue/3333) - usermod -a -G bar foo fails due to some file providers races
- [3276](https://pagure.io/SSSD/sssd/issue/3276) - Revert workaround in CI for bug in python-{request,urllib3}
- [3263](https://pagure.io/SSSD/sssd/issue/3263) - consider adding sudo-i to the list of pam_response_filter services by default
- [2817](https://pagure.io/SSSD/sssd/issue/2817) - dynamic dns - remove detection of 'realm' keyword support
- [2474](https://pagure.io/SSSD/sssd/issue/2474) - AD: do not override existing home-dir or shell if they are not available in the global catalog
- [1944](https://pagure.io/SSSD/sssd/issue/1944) - convert dyndns timer to be_ptask

Detailed Changelog
------------------

- Adam Williamson (1):

  - sbus: use 120 second default timeout

- Alexey Tikhonov (16):

  - Fix error in hostname retrieval
  - util/tev_curl: Fix double free error in schedule_fd_processing()
  - CONFIG: validator rules & test
  - sss_client/common.c: fix Coverity issue
  - sss_client/common.c: fix off-by-one error in sizes check
  - sss_client/common.c: comment amended
  - sss_client/nss_services.c: indentation fixed
  - sss_client/nss_services.c: fixed incorrect mutex usage
  - sss_client: global unexported symbols made static
  - providers/ldap: abort unsecure authentication requests
  - providers/ldap: fixed check of ldap_get_option return value
  - providers/ldap: init sasl_ssf in specific case
  - sbus/interface: fixed interface copy helpers
  - lib/cifs_idmap_sss: fixed unaligned mem access
  - Util: fixed mistype in error string representation
  - TESTS: fixed bug in guests startup function

- George McCollister (1):

  - build: remove hardcoded samba include path

- Jakub Hrozek (38):

  - Updating the version to track 2.1 development
  - KCM: Don't error out if creating a new ID as the first step
  - SELINUX: Always add SELinux user to the semanage database if it doesn't exist
  - pep8: Ignore W504 and W605 to silence warnings on Debian
  - TESTS: Add a test for whitespace trimming in netgroup entries
  - TESTS: Add two basic multihost tests for the files provider
  - FILES: The files provider should not enumerate
  - p11: Fix two instances of -Wmaybe-uninitialized in p11_child_openssl.c
  - UTIL: Suppress Coverity warning
  - PYSSS: Re-add the pysss.getgrouplist() interface
  - IFP: Use subreq, not req when calling RefreshRules_recv
  - CI: Make the c-ares suppression file more relaxed to prevent failures on Debian
  - INI: Return errno, not -1 on failure from sss_ini_get_stat
  - MONITOR: Don't check for pidfile if SSSD is already running
  - SSSD: Allow refreshing only certain section with --genconf
  - SYSTEMD: Re-read KCM configuration on systemctl restart kcm
  - TEST: Add a multihost test for sssd --genconf
  - TESTS: Add a multihost test for changing sssd-kcm debug level by just restarting the KCM service
  - RESPONDER: Log failures from bind() and listen()
  - LDAP: minor refactoring in auth_send() to conform to our coding style
  - LDAP: Only authenticate the auth connection if we need to look up user information
  - PROXY: Copy the response to the caller
  - NSS: Avoid changing the memory cache ownership away from the sssd user
  - KCM: Deleting a non-existent ccache should not yield an error
  - TESTS: Add a test for deleting a non-existent ccache with KCM
  - MAN: Explicitly state that not all generic domain options are supported for the files provider
  - AD/IPA: Reset subdomain service name, not domain name
  - IPA: Add explicit return after tevent_req_error
  - MULTIHOST: Do not use the deprecated namespace
  - KCM: Return a valid tevent error code if a request cannot be created
  - KCM: Allow representing ccaches with a NULL principal
  - KCM: Create an empty ccache on switch to a non-existing one
  - TESTS: Add a multihost test for ssh credentials forwarding
  - MAN: Add sssd-files(5) to the See Also section
  - TESTS: Add a simple integration test for retrieving the extraAttributes property
  - TESTS: Don't fail when trying to create an OU that already exists
  - Updating translations for the 2.1 release
  - Updating the version for the 2.1.0 release

- Lukas Slebodnik (29):

  - BUILD: Fix issue with installation of libsss_secrets
  - BUILD: Add missing deps to libsss_sbus\*.so
  - BUILD: Reduce compilation of unnecessary files
  - MAN: Fix typo in ad_gpo_implicit_deny default value
  - CONFIGURE: Add minimal required version for p11-kit
  - SBUS: Silence warning maybe-uninitialized
  - UTIL: Fix compilation with curl 7.62.0
  - test_pac_responder: Skip test if pac responder is not installed
  - INTG: Show extra test summary info with pytest
  - p11_child: Fix warning cast discards ‘const’ qualifier from pointer target type
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
  - DIST: Do not use conditional include for template files
  - NSS: Do not use deprecated header files
  - sss_cache: Fail if unknown domain is passed in parameter
  - test_sss_cache: Add test case for wrong domain in parameter
  - Remove macro ZERO_STRUCT
  - test_files_provider: Do not use pytest fixtures as functions
  - test_ldap: Do not uses pytest fixtures as functions
  - Revert "intg: Generate tmp dir with lowercase"
  - ent_test: Update assertions for python 3.7.2

- Madhuri Upadhye (1):

  - pytest: Add test cases for configuration validation

- Michal Židek (4):

  - GPO: Add gpo_implicit_deny option
  - CONFDB: Skip 'local' domain if not supported
  - confdb: Always read snippet files
  - CONFDB: Remove old libini support

- Niranjan M.R (20):

  - Python3 changes to multihost tests
  - Minor fixes related to converting of ldap attributes to bytes
  - test-library: fixes related to KCM, TLS on Directory server
  - Multihost-SanityTests: New test case for ssh login with KCM as default
  - pytest: Remove installing idm module
  - pytest/testlib: Add function to create organizational Unit
  - pytest/testlib: Fix related to removing kerberos database
  - pytest: Add test for sudo: search with lower cased name for case insensitive domains
  - pytest/testlib: function to create sudorules in ldap
  - pytest/testlib: remove space in CA DN
  - pytest/conftest.py: Delete krb5.keytab as part of cleanup
  - pytest: split kcm test cases in to separate file.
  - testlib: Update update_resolv_conf() to decode str to bytes
  - testlib: Replace Generic Exception with SSSDException and LdapException
  - pytest/sudo: Modify fixture to restore sssd.conf
  - pytest/sudo: Rename create_sudorule to case_sensitive_sudorule
  - pytest/sudo: call case_sensitive_sudorule fixture instead of create_sudorule
  - pytest/sudo: Add 2 fixtures set_entry_cache_sudo_timeout and generic_sudorule
  - pytest/sudo: Add Testcase: sssd crashes when refreshing expired sudo rules.
  - pytest: use ConfigParser() instead of SafeConfigParser()

- Pavel Březina (25):

  - sbus: register filter on new connection
  - sbus: fix typo
  - sbus: check for null message in sbus_message_bound
  - sbus: replace sbus_message_bound_ref with sbus_message_bound_steal
  - sbus: add unit tests for public sbus_message module
  - sudo: respect case sensitivity in sudo responder
  - proxy: access provider directly not through be_ctx
  - dp: set be_ctx-&gt;provider as part of dp_init request
  - sbus: read destination after sender is set
  - sbus: do not try to remove signal listeners when disconnecting
  - sbus: free watch_fd-&gt;fdevent explicitly
  - be: use be_is_offline for the main domain when asking for domain status
  - sudo: use correct sbus interface
  - sudo: fix error handling in sudosrv_refresh_rules_done
  - sbus: remove leftovers from previous implementation
  - sbus: allow access for sssd user
  - nss: use enumeration context as talloc parent for cache req result
  - sss_iface: prevent from using invalid names that start with digits
  - ci: add ability to run tests in jenkins
  - ci: add Fedora 29
  - sbus: do not use signature when copying dictionary entry
  - sbus: avoid using invalid stack point in SBUS_INTERFACE
  - sbus: improve documentation of SBUS_INTERFACE
  - ci: add Fedora Rawhide
  - sbus: terminated active ongoing request when reconnecting

- Sumit Bose (63):

  - intg: flush the SSSD caches to sync with files
  - sbus: dectect python binary for sbus_generate.sh
  - sysdb: extract sysdb_ldb_msg_attr_to_certmap_info() call
  - sysdb_ldb_msg_attr_to_certmap_info: set SSS_CERTMAP_MIN_PRIO
  - sysdb: add attr_map attribute to sysdb_ldb_msg_attr_to_certmap_info()
  - confdb: add confdb_certmap_to_sysdb()
  - AD/LDAP: read certificate mapping rules from config file
  - sysdb: sysdb_certmap_add() handle domains more flexible
  - confdb: add special handling for rules for the files provider
  - files: add support for Smartcard authentication
  - responder: make sure SSS_DP_CERT is passed to files provider
  - PAM: add certificate matching rules from all domains
  - doc: add certificate mapping section to man page
  - intg: user default locale
  - PAM: use better PAM error code for failed Smartcard authentication
  - test_ca: test library only for readable
  - test_ca: set a password/PIN to nss databases
  - getsockopt_wrapper: add support for PAM clients
  - intg: add Smartcard authentication tests
  - ci: add http-parser-devel for Fedora
  - p11: handle multiple certs during auth with OpenSSL
  - p11_child: add --wait_for_card option
  - PAM: add p11_wait_for_card_timeout option
  - pam_sss: make flags public
  - pam_sss: add try_cert_auth option
  - pam_sss: add option require_cert_auth
  - intg: require SC tests
  - p11_child: show PKCS\#11 URI in debug output
  - p11_child: add PKCS\#11 uri to restrict selection
  - PAM: add p11_uri option
  - tests: add PKCS\#11 URI tests
  - PAM: return short name for files provider users
  - p11_child: add OCSP check ot the OpenSSL version
  - p11_child: add crl_file option for the OpenSSL build
  - files: add session recording flag
  - ifp: fix typo causing a crash in FindByNameAndCertificate
  - pam_sss: return PAM_AUTHINFO_UNAVAIL if sc options are set
  - p11_child(NSS): print key type in a debug message
  - pam_test_srv: set default value for SOFTHSM2_CONF
  - tests: add ECC CA
  - test_pam_srv: add test for certificate with EC keys
  - p11_child(openssl): add support for EC keys
  - utils: refactor ssh key extraction (OpenSSL)
  - utils: add ec_pub_key_to_ssh() (OpenSSL)
  - utils: refactor ssh key extraction (NSS)
  - utils: add ec_pub_key_to_ssh() (NSS)
  - BUILD: Accept krb5 1.17 for building the PAC plugin
  - tests: fix mocking krb5_creds in test_copy_ccache
  - tests: increase p11_child_timeout
  - LDAP: Log the encryption used during LDAP authentication
  - Revert "IPA: use forest name when looking up the Global Catalog"
  - ipa: use only the global catalog service of the forest root
  - p11_child(openssl): do not free static memory
  - krb5_child: fix permissions during SC auth
  - idmap_sss: improve man page
  - PAM: use user name hint if any domain has set it
  - utils: make N_ELEMENTS public
  - ad: replace ARRAY_SIZE with N_ELEMENTS
  - responder: fix domain lookup refresh timeout
  - ldap: add get_ldap_conn_from_sdom_pvt
  - ldap: prefer LDAP port during initgroups user lookup
  - ldap: user get_ldap_conn_from_sdom_pvt() where possible
  - krb5_locator: always use port 88 for master KDC

- Thorsten Scherf (1):

  - CONFIG: add missing ldap attributes for validation

- Tomas Halman (14):

  - doc: remove local provider reference from manpages
  - confdb: log an error when domain is misconfigured
  - doc: Add nsswitch.conf note to manpage
  - test_config: Test for invalid characker in domain
  - UTIL: move and rename sysdb_error_to_errno to utils
  - DYNDNS: Drop support for legacy NSUPDATE
  - SSSCTL: user-show says that user is expired
  - DYNDNS: Convert dyndns timer to be_ptask
  - DYNDNS: SSSD does not batch DDNS update requests
  - nss: sssd returns '/' for emtpy home directories
  - ifp: extraAttributes is UnknownProperty
  - SSSCTL: user-checks does not show custom attributes
  - ssh: sssd_ssh fails completely on p11_child timeout
  - ssh: p11_child error message is too generic

- Victor Tapia (1):

  - GPO: Allow customization of GPO_CROND per OS

- mateusz (1):

  - Added note about default value of ad_gpo_map_batch parameter
