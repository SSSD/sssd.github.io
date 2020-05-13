SSSD 1.15.2
===========

Highlights
----------

- It is now possible to configure certain parameters of a trusted domain in a configuration file sub-section. In particular, it is now possible to configure which Active Directory DCs the SSSD talks to with a configuration like this:
>
        [domain/ipa.test]
        # IPA domain configuration. This domain trusts a Windows domain win.test
>
        [domain/ipa.test/win.test]
        ad_server = dc.win.test
>
- Several issues related to socket-activating the NSS service, especially if SSSD was configured to use a non-privileged userm were fixed. The NSS service now doesn't change the ownership of its log files to avoid triggering a name-service lookup while the NSS service is not running yet. Additionally, the NSS service is started before any other service to make sure username resolution works and the other service can resolve the SSSD user correctly.
- A new option `cache_first` allows the administrator to change the way multiple domains are searched. When this option is enabled, SSSD will first try to "pin" the requested name or ID to a domain by searching the entries that are already cached and contact the domain that contains the cached entry first. Previously, SSSD would check the cache and the remote server for each domain. This option brings performance benefit for setups that use multiple domains (even auto-discovered trusted domains), especially for ID lookups that would previously iterate over all domains. Please note that this option must be enabled with care as the administrator must ensure that the ID space of domains does not overlap.
- The SSSD D-Bus interface gained two new methods: `FindByNameAndCertificate` and `ListByCertificate`. These methods will be used primarily by IPA and [mod_lookup_identity](https://github.com/adelton/mod_lookup_identity/) to correctly match multple users who use the same certificate for Smart Card login.
- A bug where SSSD did not properly sanitize a username with a newline character in it was fixed.

Packaging Changes
-----------------

None in this release

Documentation Changes
---------------------

- A new option `cache_first` was added. Please see the Highlights section for more details
- The `override_homedir` option supports a new template expansion `l` that expands to the first letter of username

Tickets Fixed
-------------

Please note that due to a bug in the pagure.io tracker, some tickets that have dependencies set to other tickets cannot be closed at the moment.

- [\#3317](https://pagure.io/SSSD/sssd/issue/3317) - Newline characters (n) must be sanitized before LDAP requests take place
- [\#3316](https://pagure.io/SSSD/sssd/issue/3316) - sssd-secrets doesn't exit on idle
- [\#3314](https://pagure.io/SSSD/sssd/issue/3314) - sssd ignores entire groups from proxy provider if one member is listed twice
- [\#3164](https://pagure.io/SSSD/sssd/issue/3164) - when group is invalidated using sss_cache dataExpireTimestamp entry in the domain and timestamps cache are inconsistent
- [\#2668](https://pagure.io/SSSD/sssd/issue/2668) - [RFE] Add more flexible templating for override_homedir config option
- [\#2599](https://pagure.io/SSSD/sssd/issue/2599) - Make it possible to configure AD subdomain in the server mode
- [\#3322](https://pagure.io/SSSD/sssd/issue/3322) - chown in ExecStartPre of sssd-nss.service hangs forever
- [\#843](https://pagure.io/SSSD/sssd/issue/843) - Login time increases strongly if more than one domain is configured
- [\#2320](https://pagure.io/SSSD/sssd/issue/2320) - use the sss_parse_inp request in other responders than dbus

Detailed Changelog
------------------

- Fabiano Fidêncio (7):

  - RESPONDER: Wrap up the code to setup the idle timeout
  - SECRETS: Shutdown the responder in case it becomes idle
  - CACHE_REQ: Move cache_req_next_domain() into a new tevent request
  - CACHE_REQ: Check the caches first
  - NSS: Don't set SocketUser/SocketGroup as "sssd" in sssd-nss.socket
  - NSS: Ensure the NSS socket is started before any other services' sockets
  - NSS: Don't call chown on NSS service's ExecStartPre

- Ignacio Reguero (1):

  - UTIL: first letter of user name template for override_homedir

- Jakub Hrozek (9):

  - Updating the version for the 1.15.2 release
  - Allow manual start for sssd-ifp
  - NSS: Fix invalidating memory cache for subdomain users
  - UTIL: Add a new macro SAFEALIGN_MEMCPY_CHECK
  - UTIL: Add a generic iobuf module
  - BUILD: Detect libcurl during configure
  - UTIL: Add a libtevent libcurl wrapper
  - TESTS: test the curl wrapper with a command-line tool
  - Updating the translations for the 1.15.2 release

- Justin Stephenson (1):

  - MAN: Add dyndns_auth option

- Lukas Slebodnik (3):

  - test_secrets: Fail in child if sssd_secrets cannot start
  - test_utils: Add test coverage for %l in override_homedir
  - util-test: Extend unit test for sss_filter_sanitize_ex

- Michal Židek (4):

  - data_provider: Fix typo in DEBUG message
  - SUBDOMAINS: Configurable search bases
  - SUBDOMAINS: Allow options ad(_backup)_server
  - MAN: Add trusted domain section man entry

- Pavel Březina (4):

  - cache_req: use rctx as memory context during midpoint refresh
  - CACHE_REQ: Make `cache_req_{create_and_,}add_result()` more generic
  - CACHE_REQ: Move result manipulation into a separate module
  - CACHE_REQ: shortcut if object is found

- Petr Čech (2):

  - sss_cache: User/groups invalidation in domain cache
  - PROXY: Remove duplicit users from group

- Sumit Bose (7):

  - sysdb: allow multiple results for searches by certificate
  - cache_req: allow multiple matches for searches by certificate
  - ifp: add ListByCertificate
  - ifp: add FindByNameAndCertificate
  - PAM: allow muliple users mapped to a certificate
  - nss: ensure that SSS_NSS_GETNAMEBYCERT only returns a unique match
  - IPA: get overrides for all users found by certificate

- Thorsten Scherf (1):

  - Fixed typo in debug output

- Victor Tapia (1):

  - UTIL: Sanitize newline and carriage return characters.
