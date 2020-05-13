SSSD 1.13.3
===========

Highlights
----------

-  A bug that prevented user lookups and logins after migration from
   winsync to IPA-AD trusts was fixed
-  The OCSP certificate validation checks are enabled for smartcard
   logins if SSSD was compiled with the NSS crypto library.
-  A bug that prevented the ``ignore_group_members`` option from working
   correctly in AD provider setups that use a dedicated primary group
   (as opposed to a user-private group) was fixed
-  Offline detection and offline login timeouts were improved for AD
   users logging in from a domain trusted by an IPA server
-  The AD provider supports setting up ``autofs_provider=ad``
-  Several usability improvements to our debug messages

Packaging Changes
-----------------

-  The ``p11_child`` helper binary is able to run completely
   unprivileged and no longer requires the setgid bit to be set

Documentation Changes
---------------------

-  A new option ``certificate_verification`` was added. This option
   allows the administrator to disable OCSP checks in case the OCSP
   server is not reachable

Tickets Fixed
-------------

.. raw:: html

   <div>

`#1632 <https://pagure.io/SSSD/sssd/issue/1632>`__
    [RFE] Unable to use AD provider for automount lookups
`#1943 <https://pagure.io/SSSD/sssd/issue/1943>`__
    convert sudo timer to be\_ptask
`#2672 <https://pagure.io/SSSD/sssd/issue/2672>`__
    sudo: reload hostinfo when going online
`#2732 <https://pagure.io/SSSD/sssd/issue/2732>`__
    Add Integration tests for local views feature
`#2747 <https://pagure.io/SSSD/sssd/issue/2747>`__
    get\_object\_from\_cache() does not handle services
`#2755 <https://pagure.io/SSSD/sssd/issue/2755>`__
    Review p11\_child hardening
`#2787 <https://pagure.io/SSSD/sssd/issue/2787>`__
    We should mention SSS\_NSS\_USE\_MEMCACHE in man sssd.conf(5) as
    well
`#2796 <https://pagure.io/SSSD/sssd/issue/2796>`__
    fix man page for sssd-ldap
`#2801 <https://pagure.io/SSSD/sssd/issue/2801>`__
    Check next certificate on smart card if first is not valid
`#2812 <https://pagure.io/SSSD/sssd/issue/2812>`__
    Smartcard login when certificate on the card is revoked and ocsp
    check enabled is not supported
`#2830 <https://pagure.io/SSSD/sssd/issue/2830>`__
    Try to suppress "Could not parse domain SID from [(null)]" for IPA
    users
`#2846 <https://pagure.io/SSSD/sssd/issue/2846>`__
    Inform about SSSD PAC timeout better
`#2868 <https://pagure.io/SSSD/sssd/issue/2868>`__
    AD provider and ignore\_group\_members=True might cause flaky group
    memberships
`#2874 <https://pagure.io/SSSD/sssd/issue/2874>`__
    sssd: [sysdb\_add\_user] (0x0400): Error: 17 (File exists)

.. raw:: html

   </div>

Detailed Changelog
------------------

Dan Lavu (1):

-  Clarify that subdomains always use service discovery

Jakub Hrozek (7):

-  Upgrading the version for the 1.13.3 release
-  DP: Do not confuse static analysers with dead code
-  BUILD: Only install polkit rules if the directory is available
-  IPA: Use search timeout, not enum timeout for searching overrides
-  AD: Add autofs provider
-  MAN: Clarify when should TGs be disabled for group nesting
   restriction
-  Update translations for the 1.13.3 release

Lukas Slebodnik (2):

-  sbus\_codegen\_tests: Use portable definition of large constants
-  DEBUG: Add missing new lines

Michal Židek (1):

-  MAN: sssd.conf should mention SSS\_NSS\_USE\_MEMCACHE

Pavel Březina (22):

-  SYSDB: Add missing include to sysdb\_services.h
-  LDAP: Mark globals in ldap\_opts.h as extern
-  AD: Mark globals in ad\_opts.h as extern
-  IPA: Mark globals in ipa\_opts.h as extern
-  KRB5: Mark globals in krb5\_opts.h as extern
-  SUDO: convert periodical refreshes to be\_ptask
-  SUDO: move refreshes from sdap\_sudo.c to sdap\_sudo\_refresh.c
-  SUDO: move offline check to handler
-  SUDO: simplify error handling
-  SUDO: fix sdap\_id\_op logic
-  SUDO: fix tevent style
-  SUDO: fix sdap\_sudo\_smart\_refresh\_recv()
-  SUDO: sdap\_sudo\_load\_sudoers improve iterator
-  SUDO: set USN inside sdap\_sudo\_refresh request
-  SUDO: built host filter inside sdap\_sudo\_refresh request
-  SUDO: do not imitate full refresh if usn is unknown in smart refresh
-  SUDO: fix potential memory leak in sdap\_sudo\_init
-  SUDO: obtain host information when going online
-  SUDO: remove finalizer
-  SUDO: make sdap\_sudo\_handler static
-  SUDO: use size\_t instead of int in for cycles
-  SUDO: get srv\_opts after we are connected

Pavel Reichl (1):

-  sysdb-tests: Fix warning - incompatible pointer type

Petr Cech (2):

-  IPA\_PROVIDER: Explicit no handle of services
-  KRB5\_CHILD: Debug logs for PAC timeout

Sumit Bose (7):

-  IPA: fix override with the same name
-  p11: allow p11\_child to run completely unprivileged
-  p11: check if cert is valid before selecting it
-  p11: enable ocsp checks
-  ldap: skip sdap\_save\_grpmem() if ignore\_group\_members is set
-  initgr: only search for primary group if it is not already cached
-  LDAP: check early for missing SID in mapping check
