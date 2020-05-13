SSSD 1.13.1
===========

Highlights
----------

-  Initial support for Smart Card authentication was added. The feature
   can be activated with the new ``pam_cert_auth`` option
-  The PAM prompting was enhanced so that when Two-Factor Authentication
   is used, both factors (password and token) can be entered separately
   on separate prompts. At the same time, only the long-term password is
   cached, so offline access would still work using the long term
   password
-  A new command line tool ``sss_override`` is present in this release.
   The tools allows to override attributes on the SSSD side. It's
   helpful in environment where e.g. some hosts need to have a different
   view of POSIX attributes than others. Please note that the overrides
   are stored in the cache as well, so removing the cache will also
   remove the overrides
-  New methods were added to the SSSD D-Bus interface. Notably support
   for looking up a user by certificate and looking up multiple users
   using a wildcard was added. Please see the interface introspection or
   the design pages for full details
-  Several enhancements to the dynamic DNS update code. Notably, clients
   that update multiple interfaces work better with this release
-  This release supports authenticating againt a KDC proxy
-  The fail over code was enhanced so that if a trusted domain is not
   reachable, only that domain will be marked as inactive but the backed
   would stay in online mode
-  Several fixes to the GPO access control code are present

Packaging Changes
-----------------

-  The Smart Card authentication feature requires a helper process
   ``p11_child`` that needs to be marked as setgid if SSSD needs to be
   able to. Please note the ``p11_child`` requires the NSS crypto
   library at the moment
-  The ``sss_override`` tool was added along with its own manpage
-  The upstream RPM can now build on RHEL/CentOS 6.7

Documentation Changes
---------------------

-  The ``config_file_version`` configuration option now defaults to 2.
   As an effect, this option doesn't have to be set anymore unless the
   config file format is changed again by SSSD upstream
-  It is now possible to specify a comma-separated list of interfaces in
   the ``dyndns_iface`` option
-  The InfoPipe responder and the LDAP provider gained a new option
   ``wildcard_lookup`` that specifies an upper limit on the number of
   entries that can be returned with a wildcard lookup
-  A new option ``dyndns_server`` was added. This option allows to
   attempt a fallback DNS update against a specific DNS server. Please
   note this option only works as a fallback, the first attempt will
   always be performed against autodiscovered servers.
-  The PAM responder gained a new option ``ca_db`` that allows the
   storage of trusted CA certificates to be specified
-  The time the ``p11_child`` is allowed to operate can be specified
   using a new option ``p11_child_timeout``

Tickets Fixed
-------------

.. raw:: html

   <div>

`#546 <https://pagure.io/SSSD/sssd/issue/546>`__
    [RFE] Support for smart cards
`#1697 <https://pagure.io/SSSD/sssd/issue/1697>`__
    sssd: incorrect checks on length values during packet decoding
`#1926 <https://pagure.io/SSSD/sssd/issue/1926>`__
    [RFE] Start the dynamic DNS update after the SSSD has been setup for
    the first time
`#1994 <https://pagure.io/SSSD/sssd/issue/1994>`__
    Complain loudly if backend doesn't start due to missing or invalid
    keytab
`#2275 <https://pagure.io/SSSD/sssd/issue/2275>`__
    nested netgroups do not work in IPA provider
`#2283 <https://pagure.io/SSSD/sssd/issue/2283>`__
    test dyndns failed.
`#2335 <https://pagure.io/SSSD/sssd/issue/2335>`__
    Investigate using the krb5 responder for driving the PAM
    conversation with OTPs
`#2463 <https://pagure.io/SSSD/sssd/issue/2463>`__
    Pass error messages via the extdom plugin
`#2495 <https://pagure.io/SSSD/sssd/issue/2495>`__
    [RFE]Allow sssd to add a new option that would specify which server
    to update DNS with
`#2549 <https://pagure.io/SSSD/sssd/issue/2549>`__
    RFE: Support multiple interfaces with the dyndns\_iface option
`#2553 <https://pagure.io/SSSD/sssd/issue/2553>`__
    RFE: Add support for wildcard-based cache updates
`#2558 <https://pagure.io/SSSD/sssd/issue/2558>`__
    Add dualstack and multihomed support
`#2561 <https://pagure.io/SSSD/sssd/issue/2561>`__
    Too much logging
`#2579 <https://pagure.io/SSSD/sssd/issue/2579>`__
    TRACKER: Support one-way trusts for IPA
`#2581 <https://pagure.io/SSSD/sssd/issue/2581>`__
    Re-check memcache after acquiring the lock in the client code
`#2584 <https://pagure.io/SSSD/sssd/issue/2584>`__
    RFE: Support client-side overrides
`#2597 <https://pagure.io/SSSD/sssd/issue/2597>`__
    Add index for 'objectSIDString' and maybe to other cache attributes
`#2637 <https://pagure.io/SSSD/sssd/issue/2637>`__
    RFE: Don't mark the main domain as offline if SSSD can't connect to
    a subdomain
`#2639 <https://pagure.io/SSSD/sssd/issue/2639>`__
    RFE: Detect re-established trusts in the IPA subdomain code
`#2652 <https://pagure.io/SSSD/sssd/issue/2652>`__
    KDC proxy not working with SSSD krb5\_use\_kdcinfo enabled
`#2676 <https://pagure.io/SSSD/sssd/issue/2676>`__
    Group members are not turned into ghost entries when the user is
    purged from the SSSD cache
`#2682 <https://pagure.io/SSSD/sssd/issue/2682>`__
    sudoOrder not honored as expected
`#2688 <https://pagure.io/SSSD/sssd/issue/2688>`__
    Default to config\_file\_version=2
`#2691 <https://pagure.io/SSSD/sssd/issue/2691>`__
    GPO: PAM system error returned for PAM\_ACCT\_MGMT and offline mode
`#2692 <https://pagure.io/SSSD/sssd/issue/2692>`__
    GPO: Access denied due to using wrong sam\_account\_name
`#2699 <https://pagure.io/SSSD/sssd/issue/2699>`__
    SSSDConfig: wrong return type returned on python3
`#2700 <https://pagure.io/SSSD/sssd/issue/2700>`__
    krb5\_child should always consider online state to allow use of
    MS-KKDC proxy
`#2708 <https://pagure.io/SSSD/sssd/issue/2708>`__
    Logging messages from user point of view
`#2711 <https://pagure.io/SSSD/sssd/issue/2711>`__
    [RFE] Provide interface for SSH to fetch user certificate
`#2712 <https://pagure.io/SSSD/sssd/issue/2712>`__
    Initgroups memory cache does not work with fq names
`#2716 <https://pagure.io/SSSD/sssd/issue/2716>`__
    Initgroups mmap cache needs update after db changes
`#2717 <https://pagure.io/SSSD/sssd/issue/2717>`__
    well-known SID check is broken for NetBIOS prefixes
`#2718 <https://pagure.io/SSSD/sssd/issue/2718>`__
    SSSD keytab validation check expects root ownership
`#2719 <https://pagure.io/SSSD/sssd/issue/2719>`__
    IPA: returned unknown dp error code with disabled migration mode
`#2722 <https://pagure.io/SSSD/sssd/issue/2722>`__
    Missing config options in gentoo init script
`#2723 <https://pagure.io/SSSD/sssd/issue/2723>`__
    Could not resolve AD user from root domain
`#2724 <https://pagure.io/SSSD/sssd/issue/2724>`__
    getgrgid for user's UID on a trust client prevents getpw\*
`#2725 <https://pagure.io/SSSD/sssd/issue/2725>`__
    If AD site detection fails, not even ad\_site override skipped
`#2729 <https://pagure.io/SSSD/sssd/issue/2729>`__
    Do not send SSS\_OTP if both factors were entered separately
`#2731 <https://pagure.io/SSSD/sssd/issue/2731>`__
    searching SID by ID always checks all domains
`#2733 <https://pagure.io/SSSD/sssd/issue/2733>`__
    Don't use deprecated libraries (libsystemd-\*)
`#2737 <https://pagure.io/SSSD/sssd/issue/2737>`__
    sss\_override: add import and export commands
`#2738 <https://pagure.io/SSSD/sssd/issue/2738>`__
    Cannot build rpms from upstream spec file on rawhide
`#2742 <https://pagure.io/SSSD/sssd/issue/2742>`__
    When certificate is added via user-add-cert, it cannot be looked up
    via org.freedesktop.sssd.infopipe.Users.FindByCertificate
`#2743 <https://pagure.io/SSSD/sssd/issue/2743>`__
    memory cache can work intermittently
`#2744 <https://pagure.io/SSSD/sssd/issue/2744>`__
    cleanup\_groups should sanitize dn of groups
`#2746 <https://pagure.io/SSSD/sssd/issue/2746>`__
    the PAM srv test often fails on RHEL-7
`#2748 <https://pagure.io/SSSD/sssd/issue/2748>`__
    test\_memory\_cache failed in invalidation cache before stop
`#2749 <https://pagure.io/SSSD/sssd/issue/2749>`__
    Fix crash in nss responder
`#2754 <https://pagure.io/SSSD/sssd/issue/2754>`__
    Clear environment and set restrictive umask in p11\_child
`#2757 <https://pagure.io/SSSD/sssd/issue/2757>`__
    sss\_override does not work correctly when
    'use\_fully\_qualified\_names = True'
`#2758 <https://pagure.io/SSSD/sssd/issue/2758>`__
    sss\_override contains an extra parameter --debug but is not listed
    in the man page or in the arguments help
`#2762 <https://pagure.io/SSSD/sssd/issue/2762>`__
    [RFE] sssd: better feedback form constraint password change
`#2768 <https://pagure.io/SSSD/sssd/issue/2768>`__
    Test 'test\_id\_cleanup\_exp\_group' failed
`#2772 <https://pagure.io/SSSD/sssd/issue/2772>`__
    sssd cannot resolve user names containing backslash with ldap
    provider
`#2773 <https://pagure.io/SSSD/sssd/issue/2773>`__
    Make p11\_child timeout configurable
`#2777 <https://pagure.io/SSSD/sssd/issue/2777>`__
    Fix memory leak in GPO
`#2782 <https://pagure.io/SSSD/sssd/issue/2782>`__
    sss\_override : The local override user is not found
`#2783 <https://pagure.io/SSSD/sssd/issue/2783>`__
    REGRESSION: Dyndns soes not update reverse DNS records
`#2790 <https://pagure.io/SSSD/sssd/issue/2790>`__
    sss\_override --name doesn't work with RFC2307 and ghost users
`#2799 <https://pagure.io/SSSD/sssd/issue/2799>`__
    unit tests do not link correctly on Debian
`#2803 <https://pagure.io/SSSD/sssd/issue/2803>`__
    Memory leak / possible DoS with krb auth.
`#2805 <https://pagure.io/SSSD/sssd/issue/2805>`__
    AD: Conditional jump or move depends on uninitialised value

.. raw:: html

   </div>

Detailed Changelog
------------------

Jakub Hrozek (52):

-  Updating the version for 1.13.1 development
-  tests: Move N\_ELEMENTS definition to tests/common.h
-  SYSDB: Add functions to look up multiple entries including name and
   custom filter
-  DP: Add DP\_WILDCARD and
   SSS\_DP\_WILDCARD\_USER/SSS\_DP\_WILDCARD\_GROUP
-  cache\_req: Extend cache\_req with wildcard lookups
-  UTIL: Add sss\_filter\_sanitize\_ex
-  LDAP: Fetch users and groups using wildcards
-  LDAP: Add sdap\_get\_and\_parse\_generic\_send
-  LDAP: Use sdap\_get\_and\_parse\_generic\_/\_recv
-  LDAP: Add sdap\_lookup\_type enum
-  LDAP: Add the wildcard\_limit option
-  IFP: Add wildcard requests
-  Use NSCD path in execl()
-  KRB5: Use the right domain for case-sensitive flag
-  IPA: Better debugging
-  UTIL: Lower debug level in perform\_checks()
-  IPA: Handle sssd-owned keytabs when running as root
-  IPA: Remove MPG groups if getgrgid was called before getpw()
-  LDAP: use ldb\_binary\_encode when printing attribute values
-  IPA: Change the default of ldap\_user\_certificate to
   userCertificate;binary
-  UTIL: Provide a common interface to safely create temporary files
-  IPA: Always re-fetch the keytab from the IPA server
-  DYNDNS: Add a new option dyndns\_server
-  p11child: set restrictive umask and clear environment
-  KRB5: Use sss\_unique file in krb5\_child
-  KRB5: Use sss\_unique\_file when creating kdcinfo files
-  LDAP: Use sss\_unique\_filename in ldap\_child
-  SSH: Use sss\_unique\_file\_ex to create the known hosts file
-  SYSDB: Index the objectSIDString attribute
-  sbus: Initialize errno if constructing message fails and add debug
   messages
-  sbus: Add a special error code for messages sent by the bus itself
-  GPO: Use sss\_unique\_file and close fd on failure
-  SDAP: Remove unused function
-  KRB5: Don't error out reading a minimal krb5.conf
-  UTIL: Convert domain->disabled into tri-state with domain states
-  DP: Provide a way to mark subdomain as disabled and auto-enable it
   later with offline\_timeout
-  SDAP: Do not set is\_offline if ignore\_mark\_offline is set
-  AD: Only ignore errors from SDAP lookups if there's another
   connection to fallback to
-  KRB5: Offline operation with disabled domain
-  AD: Do not mark the whole back end as offline if subdomain lookup
   fails
-  AD: Set ignore\_mark\_offline=false when resolving AD root domain
-  IPA: Do not allow the AD lookup code to set backend as offline in
   server mode
-  BUILD: link dp tests with LDB directly to fix builds on Debian
-  LDAP: imposing sizelimit=1 for single-entry searches breaks
   overlapping domains
-  tests: Move named\_domain from test\_utils to common test code
-  LDAP: Move sdap\_create\_search\_base from ldap to sdap code
-  LDAP: Filter out multiple entries when searching overlapping domains
-  IPA: Change ipa\_server\_trust\_add\_send request to be reusable from
   ID code
-  FO: Add an API to reset all servers in a single service
-  FO: Also reset the server common data in addition to SRV
-  IPA: Retry fetching keytab if IPA user lookup fails
-  Updating translations for the 1.13.1 release

Lukas Slebodnik (49):

-  KRB5: Return right data provider error code
-  Update few debug messages
-  intg: Invalidate memory cache before removing files
-  SPEC: Update spec file for krb5\_local\_auth\_plugin
-  SSSDConfig: Return correct types in python3
-  intg: Modernize 'except' clauses
-  mmap\_cache: Rename variables
-  mmap\_cache: "Override" functions for initgr mmap cache
-  mmap: Invalidate initgroups memory cache after any change
-  sss\_client: Update integrity check of records in mmap cache
-  intg\_test: Add module for simulation of utility id
-  intg\_test: Add integration test for memory cache
-  NSS: Initgr memory cache should work with fq names
-  test\_memory\_cache: Add test for initgroups mc with fq names
-  SPEC: Workaround for build with rpm 4.13
-  KRB5: Do not try to remove missing ccache
-  test\_memory\_cache: Test mmap cache after initgroups
-  test\_memory\_cache: Test invalidation with sss\_cache
-  krb5\_utils-tests: Remove unused variables
-  sss\_cache: Wait a while for invalidation of mc by nss responder
-  test\_memory\_cache: Fix few python issues
-  NSS: Fix use after free
-  NSS: Don't ignore backslash in usernames with ldap provider
-  intg\_tests: Add regression test for 2163
-  BUILD: Build libdlopen\_test\_providers.la as a dynamic library
-  BUILD: Speed up build of some tests
-  BUILD: Simplify build of simple\_access\_tests
-  CI: Set env variable for all tabs in screen
-  dyndns-tests: Simulate job in wrapped execv
-  AUTOMAKE: Disable portability warnings
-  tests: Use unique name for TEST\_PATH
-  tests: Move test\_dom\_suite\_setup to different module
-  test\_ipa\_subdomains\_server: Use unique dorectory for keytabs
-  test\_copy\_keytab: Create keytabs in unique directory
-  test\_ad\_common: Use unique directory for keytabs
-  Revert "LDAP: end on ENOMEM"
-  Partially revert "LDAP: sanitize group name when used in filter"
-  LDAP: Sanitize group dn before using in filter
-  test\_ldap\_id\_cleanup: Fix coding style issues
-  DYNDNS: Return right error code in case of failure
-  BUILD: Simplify build of test\_data\_provider\_be
-  BUILD: Remove unused variable CHECK\_OBJ
-  BUILD: Do not build libsss\_ad\_common.la as library
-  BUILD: Remove unused variable SSSD\_UTIL\_OBJ
-  CONFIGURE: Remove bashism
-  IFP: Suppress warning from static analyzer
-  BUILD: Link test\_data\_provider\_be with -ldl
-  sysdb-tests: Use valid base64 encoded certificate for search
-  test\_pam\_srv: Run cert test only with NSS

Michal Židek (13):

-  DEBUG: Add new debug category for fail over.
-  pam: Incerease p11 child timeout
-  sdap\_async: Use specific errmsg when available
-  TESTS: ldap\_id\_cleanup timeouts
-  sssd: incorrect checks on length values during packet decoding
-  CONFDB: Assume config file version 2 if missing
-  Makefile.am: Add missing AM\_CFLAGS
-  SYSDB: Add function to expire entry
-  cleanup task: Expire all memberof targets when removing user
-  CI: Add regression test for
   `#2676 <https://pagure.io/SSSD/sssd/issue/2676>`__
-  intg: Fix some PEP 8 violations
-  PAM: Make p11\_child timeout configurable
-  tests: Set p11\_child\_timeout to 30 in tests

Nikolai Kondrashov (1):

-  TESTS: Add trailing whitespace test

Pavel Březina (18):

-  VIEWS TEST: add null-check
-  SYSDB: prepare for LOCAL view
-  TOOLS: add common command framework
-  TOOLS: add sss\_override for local overrides
-  AD: Use ad\_site also when site search fails
-  IFP: use default limit if provided is 0
-  sudo: use "higher value wins" when ordering rules
-  sss\_override: print input name if unable to parse it
-  sss\_override: support domains that require fqname
-  TOOLS: add sss\_colondb API
-  sss\_override: decompose code better
-  sss\_override: support import and export
-  sss\_override: document --debug options
-  sss\_override: support fqn in override name
-  views: do not require overrideDN in grous when LOCAL view is set
-  views: fix two typos in debug messages
-  views: allow ghost members for LOCAL view
-  sss\_override: remove -d from manpage

Pavel Reichl (23):

-  DYNDNS: sss\_iface\_addr\_list\_get return ENOENT
-  DYNDNS: support mult. interfaces for dyndns\_iface opt
-  DYNDNS: special value '\*' for dyndns\_iface option
-  TESTS: dyndns tests support AAAA addresses
-  DYNDNS: support for dualstack
-  TESTS: fix compiler warnings
-  SDAP: rename SDAP\_CACHE\_PURGE\_TIMEOUT
-  IPA: Improve messages about failures
-  DYNDNS: Don't use server cmd in nsupdate by default
-  DYNDNS: remove redundant talloc\_steal()
-  DYNDNS: remove zone command
-  DYNDNS: rename field of sdap\_dyndns\_update\_state
-  DYNDNS: remove code duplication
-  TESTS: UT for sss\_iface\_addr\_list\_as\_str\_list()
-  LDAP: sanitize group name when used in filter
-  LDAP: minor improvements in ldap id cleanup
-  TESTS: fix fail in test\_id\_cleanup\_exp\_group
-  LDAP: end on ENOMEM
-  AD: send less logs to syslog
-  Remove trailing whitespace
-  GPO: fix memory leak
-  DDNS: execute nsupdate for single update of PTR rec
-  AD: inicialize root\_domain\_attrs field

Petr Cech (6):

-  BUILD: Repair dependecies on deprecated libraries
-  TESTS: Removing part of responder\_cache\_req-tests
-  UTIL: Function 2string for enum sss\_cli\_command
-  UTIL: Fixing Makefile.am for util/sss\_cli\_cmd.h
-  DATA\_PROVIDER: BE\_REQ as string in log message
-  IPA PROVIDER: Resolve nested netgroup membership

Robin McCorkell (1):

-  man: List alternative schema defaults for LDAP AutoFS parameters

Stephen Gallagher (1):

-  AD: Handle cases where no GPOs apply

Sumit Bose (17):

-  test common: sss\_dp\_get\_account\_recv() fix assignment
-  nss\_check\_name\_of\_well\_known\_sid() improve name splitting
-  negcache: allow domain name for UID and GID
-  nss: use negative cache for sid-by-id requests
-  krb5: do not send SSS\_OTP if two factors were used
-  utils: add NSS version of cert utils
-  Add NSS version of p11\_child
-  pack\_message\_v3: allow empty name
-  authok: add support for Smart Card related authtokens
-  PAM: add certificate support to PAM (pre-)auth requests
-  pam\_sss: add sc support
-  ssh: generate public keys from certificate
-  krb5 utils: add sss\_krb5\_realm\_has\_proxy()
-  krb5: do not create kdcinfo file if proxy configuration exists
-  krb5: assume online state if KDC proxy is configured
-  GPO: use SDAP\_SASL\_AUTHID as samAccountName
-  utils: make sss\_krb5\_get\_primary() private

Thomas Oulevey (1):

-  Fix memory leak in sssdpac\_verify()

Tyler Gates (1):

-  CONTRIB: Gentoo daemon startup options as declared in conf.d/sssd

Yuri Chornoivan (1):

-  Fix minor typos
