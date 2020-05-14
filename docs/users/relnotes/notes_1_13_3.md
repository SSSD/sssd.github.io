SSSD 1.13.3
===========

Highlights
----------

- A bug that prevented user lookups and logins after migration from winsync to IPA-AD trusts was fixed
- The OCSP certificate validation checks are enabled for smartcard logins if SSSD was compiled with the NSS crypto library.
- A bug that prevented the `ignore_group_members` option from working correctly in AD provider setups that use a dedicated primary group (as opposed to a user-private group) was fixed
- Offline detection and offline login timeouts were improved for AD users logging in from a domain trusted by an IPA server
- The AD provider supports setting up `autofs_provider=ad`
- Several usability improvements to our debug messages

Packaging Changes
-----------------

- The `p11_child` helper binary is able to run completely unprivileged and no longer requires the setgid bit to be set

Documentation Changes
---------------------

- A new option `certificate_verification` was added. This option allows the administrator to disable OCSP checks in case the OCSP server is not reachable

Tickets Fixed
-------------


- [\#2674](https://github.com/SSSD/sssd/issues/2674) [RFE] Unable to use AD provider for automount lookups
- [\#2985](https://github.com/SSSD/sssd/issues/2985) convert sudo timer to be_ptask
- [\#3713](https://github.com/SSSD/sssd/issues/3713) sudo: reload hostinfo when going online
- [\#3773](https://github.com/SSSD/sssd/issues/3773) Add Integration tests for local views feature
- [\#3788](https://github.com/SSSD/sssd/issues/3788) get_object_from_cache() does not handle services
- [\#3796](https://github.com/SSSD/sssd/issues/3796) Review p11_child hardening
- [\#3828](https://github.com/SSSD/sssd/issues/3828) We should mention SSS_NSS_USE_MEMCACHE in man sssd.conf(5) as well
- [\#3837](https://github.com/SSSD/sssd/issues/3837) fix man page for sssd-ldap
- [\#3842](https://github.com/SSSD/sssd/issues/3842) Check next certificate on smart card if first is not valid
- [\#3853](https://github.com/SSSD/sssd/issues/3853) Smartcard login when certificate on the card is revoked and ocsp check enabled is not supported
- [\#3871](https://github.com/SSSD/sssd/issues/3871) Try to suppress "Could not parse domain SID from [(null)]" for IPA users
- [\#3887](https://github.com/SSSD/sssd/issues/3887) Inform about SSSD PAC timeout better
- [\#3909](https://github.com/SSSD/sssd/issues/3909) AD provider and ignore_group_members=True might cause flaky group memberships
- [\#3915](https://github.com/SSSD/sssd/issues/3915) sssd: [sysdb_add_user] (0x0400): Error: 17 (File exists)

Detailed Changelog
------------------

Dan Lavu (1):

- Clarify that subdomains always use service discovery

Jakub Hrozek (7):

- Upgrading the version for the 1.13.3 release
- DP: Do not confuse static analysers with dead code
- BUILD: Only install polkit rules if the directory is available
- IPA: Use search timeout, not enum timeout for searching overrides
- AD: Add autofs provider
- MAN: Clarify when should TGs be disabled for group nesting restriction
- Update translations for the 1.13.3 release

Lukas Slebodnik (2):

- sbus_codegen_tests: Use portable definition of large constants
- DEBUG: Add missing new lines

Michal Židek (1):

- MAN: sssd.conf should mention SSS_NSS_USE_MEMCACHE

Pavel Březina (22):

- SYSDB: Add missing include to sysdb_services.h
- LDAP: Mark globals in ldap_opts.h as extern
- AD: Mark globals in ad_opts.h as extern
- IPA: Mark globals in ipa_opts.h as extern
- KRB5: Mark globals in krb5_opts.h as extern
- SUDO: convert periodical refreshes to be_ptask
- SUDO: move refreshes from sdap_sudo.c to sdap_sudo_refresh.c
- SUDO: move offline check to handler
- SUDO: simplify error handling
- SUDO: fix sdap_id_op logic
- SUDO: fix tevent style
- SUDO: fix sdap_sudo_smart_refresh_recv()
- SUDO: sdap_sudo_load_sudoers improve iterator
- SUDO: set USN inside sdap_sudo_refresh request
- SUDO: built host filter inside sdap_sudo_refresh request
- SUDO: do not imitate full refresh if usn is unknown in smart refresh
- SUDO: fix potential memory leak in sdap_sudo_init
- SUDO: obtain host information when going online
- SUDO: remove finalizer
- SUDO: make sdap_sudo_handler static
- SUDO: use size_t instead of int in for cycles
- SUDO: get srv_opts after we are connected

Pavel Reichl (1):

- sysdb-tests: Fix warning - incompatible pointer type

Petr Cech (2):

- IPA_PROVIDER: Explicit no handle of services
- KRB5_CHILD: Debug logs for PAC timeout

Sumit Bose (7):

- IPA: fix override with the same name
- p11: allow p11_child to run completely unprivileged
- p11: check if cert is valid before selecting it
- p11: enable ocsp checks
- ldap: skip sdap_save_grpmem() if ignore_group_members is set
- initgr: only search for primary group if it is not already cached
- LDAP: check early for missing SID in mapping check
