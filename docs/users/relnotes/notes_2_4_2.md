# SSSD 2.4.2 Release Notes

## Highlights

### General information

* Default value of 'user' config option was fixed into accordance with man page, i.e. default is 'root'
* Example systemd service configs now makes use of CapabilityBoundingSet option as a security hardening measure.

### New features

* `pam_sss_gss` now support authentication indicators to further harden the authentication

### Configuration changes

* Added `pam_gssapi_indicators_map` to configure authentication indicators requirements

## Tickets Fixed

* [#5385](https://github.com/SSSD/sssd/issues/5385) - Fedora rawhide mock build is broken
* [#5406](https://github.com/SSSD/sssd/issues/5406) - sssd-kcm starts successfully for non existent socket_path
* [#5482](https://github.com/SSSD/sssd/issues/5482) - Add support to verify authentication indicators in pam_sss_gss
* [#5499](https://github.com/SSSD/sssd/issues/5499) - [pam_sss] AD users cannot login to IPA clients

## Detailed changelog

- Alexander Bokovoy (1):
  - pam_sss_gss: support authentication indicators

- Alexey Tikhonov (6):
  - BUILD: fixes gpo_child linking issue
  - SPEC: don't hard require python3-sssdconfig in a meta package
  - spec file: don't enable implicit files domain on RHEL
  - systemd configs: limit process capabilities
  - monitor: fixed default value of 'user' config option
  - systemd configs: add CAP_DAC_OVERRIDE in case certain case

- Pavel Březina (7):
  - scripts: change release tag from sssd-x_y_z to x.y.z
  - Update version in version.m4 to track the next release
  - sudo: do not search by low usn value to improve performance
  - ldap: fix modifytimestamp debugging leftovers
  - spec: remove setuid bit from child helpers if sssd user is root
  - responder: fix warning in activate_unix_sockets
  - pot: update pot files

- Stanislav Levin (1):
  - pam_sss: Don't fail on deskprofiles phase for AD users

- ikerexxe (1):
  - RESPONDER: check that configured sockets match
