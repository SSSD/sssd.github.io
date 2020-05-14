SSSD 1.15.1
===========

Highlights
----------

- Several issues related to starting the SSSD services on-demand via socket activation were fixed. In particular, it is no longer possible to have a service started both by sssd and socket-activated. Another bug which might have caused the responder to start before SSSD started and cause issues especially on system startup was fixed.
- A new `files` provider was added. This provider mirrors the contents of `/etc/passwd` and `/etc/group` into the SSSD database. The purpose of this new provider is to make it possible to use SSSD's interfaces, such as the D-Bus interface for local users and enable leveraging the in-memory fast cache for local users as well, as a replacement for `nscd`. In future, we intend to extend the D-Bus interface to also provide setting and retrieving additional custom attributes for the files users.
- SSSD now autogenerates a fallback configuration that enables the files domain if no SSSD configuration exists. This allows distributions to enable the `sssd` service when the SSSD package is installed. Please note that SSSD must be build with the configuration option `--enable-files-domain` for this functionality to be enabled.
- Support for public-key authentication with Kerberos (PKINIT) was added. This support will enable users who authenticate with a Smart Card to obtain a Kerberos ticket during authentication.

Packaging Changes
-----------------

- The new files provider comes as a new shared library `libsss_files.so` and a new manual page
- A new helper binary called `sssd_check_socket_activated_responders` was added. This binary is used in the `ExecStartPre` directive to check if the service that corresponds to socket about to be started was also started explicitly and abort the socket startup if it was.

Documentation Changes
---------------------

- A new PAM module option `prompt_always` was added. This option is related to fixing <https://github.com/SSSD/sssd/issues/4025which changed the behaviour of the PAM module so that `pam_sss` always uses an auth token that was on stack. The new `prompt_always` option makes it possible to restore the previous behaviour.

Tickets Fixed
-------------

- [\#4145](https://github.com/SSSD/sssd/issues/4145) - When sssd.conf is missing, create one with id_provider=files
- [\#4253](https://github.com/SSSD/sssd/issues/4253) - Improve successful Dynamic DNS update log messages
- [\#4260](https://github.com/SSSD/sssd/issues/4260) - sssd doesn't update PTR records if A/PTR zones are configured as non-secure and secure
- [\#4263](https://github.com/SSSD/sssd/issues/4263) - Use the same logic for matching GC results in initgroups and user lookups
- [\#4293](https://github.com/SSSD/sssd/issues/4293) - handle default_domain_suffix for ssh requests with default_domain_suffix
- [\#4295](https://github.com/SSSD/sssd/issues/4295) - Implement a files provider to mirror the contents of /etc/passwd and /etc/groups
- [\#4303](https://github.com/SSSD/sssd/issues/4303) - [RFE] Add PKINIT support to SSSD Kerberos proivder
- [\#4331](https://github.com/SSSD/sssd/issues/4331) - Socket activation of SSSD doesn't work and leads to chaos
- [\#4332](https://github.com/SSSD/sssd/issues/4332) - SSSD does not start if using only the local provider and services line is empty
- [\#4333](https://github.com/SSSD/sssd/issues/4333) - Avoid running two instances of the same service
- [\#4342](https://github.com/SSSD/sssd/issues/4342) - Coverity warns about an unused value in IPA sudo code
- [\#4346](https://github.com/SSSD/sssd/issues/4346) - cache_req should use an negative cache entry for UPN based lookups
- [\#4025](https://github.com/SSSD/sssd/issues/4025) - Don't prompt for password if there is already one on the stack
- [\#2168](https://github.com/SSSD/sssd/issues/2168) - Reuse cache_req() in responder code

Detailed Changelog
------------------

- Fabiano Fidêncio (11):
  - IFP: Update ifp_iface_generated.c
  - MONITOR: Wrap up sending sd_notify "ready" into a new function
  - MONITOR: Don't timeout if using local provider + socket-activated responders
  - MONITOR: Don't return an error in case we fail to register a service
  - SYSTEMD: Add "After=sssd.service" to the responders' sockets units
  - SYSTEMD: Avoid starting a responder socket in case SSSD is not started
  - SYSTEMD: Don't mix up responders' socket and monitor activation
  - SYSTEMD: Force responders to refuse manual start
  - CACHE_REQ: Add cache_req_data_set_bypass_cache()
  - PAM: Use cache_req to perform initgroups lookups
  - TESTS: Adapt pam-srv-tests to deal with cache_req related changes
- Jakub Hrozek (42):
  - Updating the version to track the 1.15.1 release
  - AD: Use ad_domain to match forest root domain, not the configured domain from sssd.conf
  - SUDO: Only store lowercased attribute value once
  - NEGCACHE: Add API to reset all users and groups
  - NSS: Add sbus interface to clear memory cache
  - UTIL: Add a new domain state called DOM_INCONSISTENT
  - RESPONDER: Add a responder sbus interface to set domain state
  - RESPONDER: A sbus interface to reset negatively cached users and groups
  - DP: Add internal DP interface to set domain state
  - DP: Add internal interface to reset negative cache from DP
  - DP: Add internal interface to invalidate memory cache from DP
  - RESPONDER: Use the NEED_CHECK_DOMAIN macro
  - RESPONDER: Include the files provider in NEEDS_CHECK_PROVIDER
  - RESPONDER: Contact inconsistent domains
  - UTIL: Add a generic inotify module
  - CONFDB: Re-enable the files provider
  - FILES: Add the files provider
  - CONFDB: Make pwfield configurable per-domain
  - CONFDB: The files domain defaults to "x" as pwfield
  - MAN: Document the pwfield configuration option
  - TESTS: move helper fixtures to back up and restore a file to a utility module
  - TESTS: add a helper module with shared NSS constants
  - TESTS: Add a module to call nss_sss's getpw\* from tests
  - TESTS: Add a module to call nss_sss's getgr\* from tests
  - TESTS: Add files provider integration tests
  - MONITOR: Remove checks for sssd.conf changes
  - MONITOR: Use the common inotify code to watch resolv.conf
  - MAN: Add documentation for the files provider
  - EXAMPLES: Do not point to id_provider=local
  - SBUS: Document how to free the result of sbus_create_message
  - FILES: Fix reallocation logic
  - TESTS: Remove unused import
  - DOC: Deprecate README, add README.md
  - MONITOR: Enable an implicit files domain if one is not configured
  - TESTS: Enable the files domain for all integration tests
  - TESTS: Test the files domain autoconfiguration
  - CONFDB: Refactor reading the config file
  - CONFDB: If no configuration file is provided, create a fallback configuration
  - UTIL: Store UPN suffixes when creating a new subdomain
  - SYSDB: When searching for UPNs, search either the whole DB or only the given domain
  - CACHE_REQ: Only search the given domain when looking up entries by UPN
  - Updating translations for the 1.15.1 release
- Justin Stephenson (5):
  - FAILOVER: Improve port status log messages
  - SUDO: Add skip_entry boolean to sudo conversions
  - TESTS: Add to IPA DN test
  - DYNDNS: Update PTR record after non-fatal error
  - DYNDNS: Correct debug log message of realm
- Lukas Slebodnik (13):
  - BUILD: Fix linking of test_wbc_calls
  - Suppres implicit-fallthrough from gcc 7
  - pam_sss: Suppress warning format-truncation
  - TOOLS: Fix warning format-truncation
  - sssctl: Fix warning may be used uninitialized
  - ldap_child: Fix use after free
  - SYSTEMD: Update journald drop-in file
  - Partially revert "CONFIG: Use default config when none provided"
  - BUILD: Fix linking of test_sdap_initgr
  - intg: Fix python3 issues
  - FILES: Remove unnecessary check
  - Update link to commit template
  - Use pagure links as a reference to upstream
- Pavel Březina (17):
  - SBUS: remove unused symbols
  - SBUS: use sss_ptr_hash for opath table
  - SBUS: use sss_ptr_hash for nodes table
  - SBUS: use sss_ptr_hash for signals table
  - ssh: fix number of output certificates
  - ssh: do not create again fq name
  - sss_parse_inp_send: provide default_domain as parameter
  - cache_req: add ability to not use default domain suffix
  - cache_req: search user by name with attrs
  - cache_req: add api to create ldb_result from message
  - cache_req: move dp request to plugin
  - cache_req: add host by name search
  - ssh: rewrite ssh responder to use cache_req
  - ssh: fix typo
  - cache_req: always go to dp first when looking up host
  - NSS: Rename the interface to invalidate memory cache initgroup records for consistency
  - CONFDB: The files provider always enumerates
- Petr Čech (5):
  - LDAP: Better logging message
  - SYSDB: Removing of sysdb_try_to_find_expected_dn()
  - TEST: create_multidom_test_ctx() extending
  - TESTS: Tests for sdap_search_initgr_user_in_batch
  - IPA_SUDO: Unused value fix
- Sumit Bose (17):
  - sdap_extend_map: make sure memory can be freed
  - check_duplicate: check name member before using it
  - pam_sss: check conversation callback
  - PAM: store user object in the preq context
  - PAM: fix memory leak in pam_sss
  - PAM: use sentinel error code in PAM tests
  - utils: new error codes
  - LDAP/proxy: tell frontend that Smartcard auth is not supported
  - authtok: enhance support for Smartcard auth blobs
  - PAM: forward Smartcard credentials to backends
  - p11: return name of PKCS\#11 module and key id to pam_sss
  - pam: enhance Smartcard authentication token
  - KRB5: allow pkinit pre-authentication
  - authtok: fix tests on big-endian
  - pam: use authtok from PAM stack if available
  - cache_req: use own namespace for UPNs
  - PAM: Improve debugging on smartcard creds forward
