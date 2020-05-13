---
version: not-implemented
---

# Proposal to redesign the memberOf plugin (v1)

Let us start with the following setup:

    dn: name=Group A, cn=Groups, cn=default, cn=sysdb
    objectClass: group
    member: name=Group D, cn=Groups, cn=default, cn=sysdb
    member: name=User 1, cn=Users, cn=default, cn=sysdb
    member: name=User 2, cn=Users, cn=default, cn=sysdb
    member: name=User 3, cn=Users, cn=default, cn=sysdb
    member: name=User 4, cn=Users, cn=default, cn=sysdb
    member: name=User 5, cn=Users, cn=default, cn=sysdb
    memberOf: name=Group C, cn=Groups, cn=default, cn=sysdb
    
    dn: name=Group B, cn=Groups, cn=default, cn=sysdb
    objectClass: group
    member: name=Group D, cn=Groups, cn=default, cn=sysdb
    member: name=User 1, cn=Users, cn=default, cn=sysdb
    member: name=User 2, cn=Users, cn=default, cn=sysdb
    memberOf: name=Group C, cn=Groups, cn=default, cn=sysdb
    
    dn: name=Group C, cn=Groups, cn=default, cn=sysdb
    objectClass: group
    member: name=Group A, cn=Groups, cn=default, cn=sysdb
    member: name=Group B, cn=Groups, cn=default, cn=sysdb
    member: name=Group F, cn=Groups, cn=default, cn=sysdb
    member: name=User 3, cn=Users, cn=default, cn=sysdb
    
    dn: name=Group D, cn=Groups, cn=default, cn=sysdb
    objectClass: group
    member: name=User 4, cn=Users, cn=default, cn=sysdb
    memberOf: name=Group A, cn=Groups, cn=default, cn=sysdb
    memberOf: name=Group B, cn=Groups, cn=default, cn=sysdb
    memberOf: name=Group C, cn=Groups, cn=default, cn=sysdb
    
    dn: name=Group E, cn=Groups, cn=default, cn=sysdb
    objectClass: group
    member: name=User 5, cn=Users, cn=default, cn=sysdb
    memberOf: name=Group B, cn=Groups, cn=default, cn=sysdb
    memberOf: name=Group C, cn=Groups, cn=default, cn=sysdb
    memberOf: name=Group F, cn=Groups, cn=default, cn=sysdb
    
    dn: name=Group F, cn=Groups, cn=default, cn=sysdb
    objectClass: group
    memberOf: name=Group C, cn=Groups, cn=default, cn=sysdb
    
    
    dn: name=User 1, cn=Users, cn=default, cn=sysdb
    objectClass: user
    memberOf: name=Group A, cn=Groups, cn=default, cn=sysdb
    memberOf: name=Group B, cn=Groups, cn=default, cn=sysdb
    memberOf: name=Group C, cn=Groups, cn=default, cn=sysdb
    
    dn: name=User 2, cn=Users, cn=default, cn=sysdb
    objectClass: user
    memberOf: name=Group A, cn=Groups, cn=default, cn=sysdb
    memberOf: name=Group B, cn=Groups, cn=default, cn=sysdb
    memberOf: name=Group C, cn=Groups, cn=default, cn=sysdb
    
    dn: name=User 3, cn=Users, cn=default, cn=sysdb
    objectClass: user
    memberOf: name=Group A, cn=Groups, cn=default, cn=sysdb
    memberOf: name=Group C, cn=Groups, cn=default, cn=sysdb
    
    dn: name=User 4, cn=Users, cn=default, cn=sysdb
    objectClass: user
    memberOf: name=Group A, cn=Groups, cn=default, cn=sysdb
    memberOf: name=Group B, cn=Groups, cn=default, cn=sysdb
    memberOf: name=Group C, cn=Groups, cn=default, cn=sysdb
    memberOf: name=Group D, cn=Groups, cn=default, cn=sysdb
    
    dn: name=User 5, cn=Users, cn=default, cn=sysdb
    objectClass: user
    memberOf: name=Group A, cn=Groups, cn=default, cn=sysdb
    memberOf: name=Group B, cn=Groups, cn=default, cn=sysdb
    memberOf: name=Group C, cn=Groups, cn=default, cn=sysdb
    memberOf: name=Group E, cn=Groups, cn=default, cn=sysdb
    memberOf: name=Group F, cn=Groups, cn=default, cn=sysdb

## Actions

### Add new member to a group with no parents

We send an ldb message to add "User 4" to "Group C"

1.  Check whether the member attribute matches the DN of Group C (it does not)
2.  Examine "Group C" for memberOf attributes.
3.  No memberOf attributes exist
4.  Add memberOf(Group C) to "User 4"

### Add new member to a group with parents

We send an ldb message to add "User 5" to "Group B"

1.  Check whether the member attribute matches the DN of Group C (it does not)
2.  Examine "Group B" for memberOf attributes.
3.  "Group B" has memberOf attributes: "Group C"
4.  Check whether any of these memberOf values match "User 5" (none do)
5.  Add memberOf(Group B) and memberOf(Group C) to "User 4" and return
