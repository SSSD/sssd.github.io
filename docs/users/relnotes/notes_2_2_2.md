SSSD 2.2.2
==========

Highlights
----------

### New features

None

### Notable bug fixes

- Removing domain from ad_enabled_domain was not reflected in SSSD's cache. This has been fixed.
- Because of a race condition SSSD could crash during shutdown. The race condition was fixed.
- Fixed a bug that limited number of external groups fetched by SSSD to 2000.
- pam_sss now properly creates gnome keyring during login.
- SSSD with KCM could wrongly pick older ccache instead of the latest one after login. This was fixed.

Packaging Changes
-----------------

None

Documentation Changes
---------------------

None

Tickets Fixed
-------------

- [3932](https://pagure.io/SSSD/sssd/issue/3932) - MAN: Document that PAM stack contains the systemd-user service in the account phase in recent distributions
- [4009](https://pagure.io/SSSD/sssd/issue/4009) - Removing domain from ad_enabled_domains is not reflected in cache
- [4058](https://pagure.io/SSSD/sssd/issue/4058) - Paging not enabled when fetching external groups, limits the number of external groups to 2000
- [4063](https://pagure.io/SSSD/sssd/issue/4063) - sssd-kcm: type confusion on KDC offset
- [4067](https://pagure.io/SSSD/sssd/issue/4067) - pam_sss with smartcard auth does not create gnome keyring
- [4068](https://pagure.io/SSSD/sssd/issue/4068) - pam_sss: empty smart card pin registers as authentication attempt
- [4069](https://pagure.io/SSSD/sssd/issue/4069) - pam_sss should reset PAM_USER based on use_fully_qualified_names option in sssd.conf
- [3996](https://pagure.io/SSSD/sssd/issue/3996) - sudo: do not update last usn when updating expired rules
- [4065](https://pagure.io/SSSD/sssd/issue/4065) - IFP: GetUserAttr does not search by UPN
- [4074](https://pagure.io/SSSD/sssd/issue/4074) - Integration tests use python2 unconditionally

Detailed changelog
------------------

- Jakub Hrozek (6):

  - MAN: Document that PAM stack contains the systemd-user service in the account phase in RHEL-8
  - IPA: Allow paging when fetching external groups
  - MAN: Document that PAM stack contains the systemd-user service in the account phase in RHEL-8
  - IPA: Allow paging when fetching external groups
  - KCM: Use int32_t type conversion in DEBUG message for int32_t variable
  - KCM: Add a forgotten return
  - KCM: Allow modifications of ccache's principal
  - KCM: Fill empty cache, do not initialize a new one

- Lukas Slebodnik (18):

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
  - test_pam_responder: Fix unicore error
  - SSSDConfig: Add minimal test for parse method
  - SSSDConfig: Fix SyntaxWarning "is not" with a literal
  - TESTS: Add minimal test for pysss encrypt
  - pysss: Fix DeprecationWarning PY_SSIZE_T_CLEAN
  - pysss_murmur: Fix DeprecationWarning PY_SSIZE_T_CLEAN
  - test_pam_responder: Fix DeprecationWarning invalid escape sequence
  - testlib: Fix SyntaxWarning "is" with a literal

- Michal Židek (2):

  - Bumping the version to track the 2.2.2 development
  - Update the translations for the 2.2.2 release

- Pavel Březina (12):

  - ad: remove subdomain that has been disabled through ad_enabled_domains from sysdb
  - sysdb: add sysdb_domain_set_enabled()
  - ad: set enabled=false attribute for subdomains that no longer exists
  - sysdb: read and interpret domain's enabled attribute
  - sysdb: add sysdb_list_subdomains()
  - ad: remove all subdomains if only master domain is enabled
  - ad: make ad_enabled_domains case insensitive
  - ci: use python2 version of pytest
  - ci: pep8 was renamed to pycodestyle in Fedora 31
  - ci: remove left overs from previous rebase
  - sudo: do not update last usn value on rules refresh
  - ifp: let cache_req parse input name so it can fallback to upn search

- Sumit Bose (5):

  - pam: keep pin on the PAM stack for forward_pass
  - pam: do not accept empty PIN
  - pam: user PAM return codes where expected
  - pam: set PAM_USER properly with allow_missing_name
  - Revert "SERVER: Receving SIGSEGV process on shutdown"

- Tomas Halman (3):

  - SERVER: Receving SIGSEGV process on shutdown
  - BE: Invalid oprator used in condition
  - SERVER: Receving SIGSEGV process on shutdown
