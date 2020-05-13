---
version: 1.13.x
---

# D-Bus Interface: Domains

Related ticket(s):

  - <https://pagure.io/SSSD/sssd/issue/2187>

Related design page(s):

  - [DBus Responder](https://docs.pagure.org/SSSD.sssd/design_pages/dbus_responder.html)

## Problem statement

This design document describes how domain objects are exposed on the bus.

## D-Bus Interface

### org.freedesktop.sssd.infopipe.Domains

#### Object paths implementing this interface

  - /org/freedesktop/sssd/infopipe/Domains

#### Methods

  - ao List()
    - Returns list of domains.
  - ao FindByName(s:domain_name)
    - Returns object path of *domain_name*.

#### Signals

None.

#### Properties

None.

### org.freedesktop.sssd.infopipe.Domains.Domain

#### Object paths implementing this interface

  - /org/freedesktop/sssd/infopipe/Domains/\*

#### Methods

  - ao ListSubdomains()
    - Returns all subdomains associated with this domain.

#### Signals

None.

#### Properties

  - **property** String name
    - The name of this domain. Same as the domain stanza in the sssd.conf
  - **property** String[] primary_servers
    - Array of primary servers associated with this domain
  - **property** String[] backup_servers
    - Array of backup servers associated with this domain
  - **property** Uint32 min_id
    - Minimum UID and GID value for this domain
  - **property** Uint32 max_id
    - Maximum UID and GID value for this domain
  - **property** String realm
    - The Kerberos realm this domain is configured with
  - **property** String forest
    - The domain forest this domain belongs to
  - **property** String login_format
    - The login format this domain expects.
  - **property** String fully_qualified_name_format
    - The format of fully qualified names this domain uses
  - **property** Boolean enumerable
    - Whether this domain can be enumerated or not
  - **property** Boolean use_fully_qualified_names
    - Whether this domain requires fully qualified names
  - **property** Boolean subdomain
    - Whether the domain is an autodiscovered subdomain or a user-defined domain
  - **property** ObjectPath parent_domain
    - Object path of a parent domain or empty string if this is a root domain

### How To Test

Call the D-Bus methods and properties. For example with **dbus-send** tool.

### Authors

  - Pavel Březina \<pbrezina@redhat.com\>
