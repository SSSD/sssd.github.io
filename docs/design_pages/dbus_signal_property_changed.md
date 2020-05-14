---
version: not-implemented
---

# D-Bus Signal: Notify Property Changed

Related ticket(s):

  - <https://github.com/SSSD/sssd/issues/3275>

Related design page(s):

  - [DBus Responder](dbus_responder.md)

## Problem statement

This design document describes how to implement org.freedesktop.DBus.Properties.PropertiesChanged signal for SSSD objects exported in the IFP responder.

## D-Bus Interface

### org.freedesktop.DBus.Properties

#### Signals

  - PropertiesChanged(s interface_name, {sv} changed_properties, as invalidated_properties)
    - interface_name: name of the interface on which the properties are defined
    - changed_properties: changed properties with new values
    - invalidated_properties: changed properties but the new values are not send with them
    - this signal is emitted for every property annotated with org.freedesktop.DBus.Property.EmitsChangedSignal, this annotation may be also used for the whole interface meaning that every property within this interface emits the signal

### Overview of the solution

Changes in properties are detected in new LDB plugin inside a *mod* hook. The plugin writes list of changed properties in a TDB-based changelog which is periodically consumed by IFP responder. IFP then emits PropertiesChanged signal per each modified object.

### Implementation details

#### TDB Format

  - **TDB Name**: *ifp_changelog.tdb*
  - **Key**: dn of modified object
  - **Value**: chained list of modified properties in the form *total_num\\0prop1\\0prop2\\0...\\0*

#### IFP Side

1.  TDB database is created on IFP start and deleted on IFP termination.
    - on IFP start:
        - if TDB file does not exist it is created
        - if TDB file exist (unexpected termination of IFP) it is flushed, we do not care about the data inside
    - on correct IFP termination
        - the TDB file is deleted
2.  A periodic task *IFP: notify properties changed* is created, it is responsible for emitting the *PropertiesChanged* signal
    - Periodic task flow:
        1.  Lock TDB for read-only access
        2.  Traverse the TDB and remember dn and properties for all modified objects
        3.  Flush TDB
        4.  Release the lock
        5.  Create and emit D-Bus signal per each object that is exported on IFP bus and supports *PropertiesChanged* signal

#### LDB Plugin Side

1.  If TDB file does not exist just quit
2.  If modified object supports the signal store it in the TDB

### Configuration changes

In IFP section:

  - **ifp_notification_interval**: period of *IFP: notify properties changed*, disabled if 0, default 300 (5 minutes)

### How To Test

1.  Hook onto *PropertiesChanged* signal, e. g. with *dbus-monitor'̈́'*
2.  Trigger change of user/group
3.  Signal should be received

### Questions

1.  Do we want to use *changed_properties* or *invalidated_properties*

### Authors

  - Pavel Březina \<pbrezina@redhat.com\>
