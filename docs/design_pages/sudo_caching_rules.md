# SUDO caching rules

## Important sudo attributes

  - **sudoHost** - to what host does the rule apply
    - *ALL* - all hostnames
    - *hostname*
    - *IP address*
    - *+netgroup*
    - *regular expression* - contains one of "\\?\*[]"
  - **sudoUser** - to what user does the rule apply
    - *username*
    - *\#uid*
    - *%group*
    - *+netgroup*
  - **sudoOrder** - rules ordering
  - **sudoNotBefore** and **sudoNotAfter** - time constraints

Complete LDAP schema can be found [here](http://www.gratisoft.us/sudo/man/1.8.4/sudoers.ldap.man.html).

## Common

### Per host update

Per host update returns all rules that:

  - sudoHost equals to ALL
  - direct match with sudoHost (by hostname or address)
  - contains regular expression (will be filtered by sudo)
  - contains netgroup (will be filtered by sudo)

Hostname match is performed in sudo source in *plugin/sudoers/ldap.c/sudo_ldap_check_host()*.

### Per user update

Per user update returns all rules that:

  - sudoUser equals to ALL
  - direct match with username, \#uid or %group names
  - contains +netgroup (will be filtered by sudo)

Username match is performed via LADP filter in sudo source in *plugin/sudoers/ldap.c/sudo_ldap_result_get()*.

### Smart refresh

Download only rules that were modified or newly created since the last refresh.

## Implementation

We will be looking for modified and newly created rules in short intervals. Expiration of the rules is handled per user during the execution time of *sudo*. We will also do periodical full refresh to ensure consistency even if the *sudo* command is not used.

### SysDB attributes

**sudoLastSmartRefreshTime** on *ou=SUDOers* - when the last smart refresh was performed  
**sudoLastFullRefreshTime** on *ou=SUDOers* - when the last full refresh was performed  
**sudoNextFullRefreshTime** on *ou=SUDOers* - when the next full is scheduled  
**dataExpireTimestamp** on each rule - when the rule will be considered as expired

### Data provider

Data provider will be performing following actions:

#### A. Periodical download of changed or newly created rules (per host smart refresh)

Interval is configurable via **ldap_sudo_changed_refresh_interval** (default: 15 minutes)  
Enable *modifyTimestamp* with **ldap_sudo_modify_timestamp_enabled** (default: false)

1.  **if** server has changed **then** do **C**
2.  **else if** *entryUSN* is available **then**
    1.  refresh rules per host, where entryUSN \currentHighestUSN
    2.  **goto** 3.2.
3.  **else if** *modifyTimestamp* is enabled **then**
    1.  refresh rules per host, where entryUSN \currentHighestUSN
    2.  *sudoLastSmartRefreshTime* := current time
    3.  nextrefresh := (current time + *ldap_sudo_changed_refresh_interval*)
    4.  **if** nextrefresh \>= *sudoNextFullRefreshTime* AND nextrefresh \< (*sudoNextFullRefreshTime* + *ldap_sudo_changed_refresh_interval*) **then**
        1.  nextrefresh := (*sudoNextFullRefreshTime* + *ldap_sudo_changed_refresh_interval*)
    5.  schedule next smart refresh
4.  **else** do nothing

#### B. Periodical full refresh of all rules

Configurable via **ldap_sudo_full_refresh_interval** (default: 360 minutes)

1.  do **C**
2.  *sudoLastFullRefreshTime* := current time
3.  *sudoNextFullRefreshTime* := (current time + *ldap_sudo_full_refresh_interval*)
4.  schedule next full refresh

#### C. On demand full refresh of all rules

1.  Download all rules per host
2.  Deletes all rules from the sysdb
3.  Store downloaded rule in the sysdb

#### D. On demand refresh of specific rules

1.  Download the rules
2.  Delete them from the sysdb
3.  Store downloaded rule in the sysdb

### Responder

**sudo_timed** (default: false) - filter rules by time constraints?

1.  search sysdb per user
2.  refresh all expired rules
3.  **if** any rule was deleted **then**
    1.  schedule **C** (out of band)
    2.  search sysdb per user
4.  **if** *sudo_timed* = false **then** filter rules by time constraints
5.  sort rules
6.  return rules to sudo

## Questions

1.  Should we also do per user smart updates when the user runs *sudo*?
2.  Should we create a tool to force full refresh of the rules immediately?
