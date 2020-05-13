---
version: 1.13.x
---

# ID mapping - Automatically assign new slices for any AD domain

Related ticket(s):

  - <https://pagure.io/SSSD/sssd/issue/2188>

## Problem statement

When a domain RID grows beyond the slice size it may make sense to have SSSD allocate a new slice automatically instead of relying on the admin to find the fault and increase the slice size in sssd.conf and then remove SYSDB cache and restart SSSD.

## Use cases

If RID part of Active Directories user's SID (e.g. S-1-5-21-2153326666-2176343378-3404031434-300000) is greater than value of option ldap_idmap_range_size (default: 200000) then ID mapping will not work properly for such user. To resolve such situation:

  - Administrator has to notice this happening.
  - Fix configuration of ID mapping - increase value of ldap_idmap_range_size option.
  - Stop SSSD, remove SYSDB cache, start SSSD.

Downside of such configuration change is that the mapping function will change. SIDs can be mapped to different UIDs and UIDs might be mapped on different SIDs or at no SIDs at all.

For example Active Directory users might not be able to access their files on UNIX hosts any more as the files would belong to their former UNIX IDs not the current ones.

After this feature is implemented administrator's action will not be required in most cases. Also restarting SSSD and removing SYSDB cache will not be necessary and so user ownership of resources such as files will not be lost.

## Overview of the solution

After generating primary range for domain helper ranges are generated. Number of helper ranges is adjustable (new option ldap_idmap_helper_table_size). Special value 0 of this option disables this feature.

  - Unique identifier for helper ranges is a string *domain_sid-$first_rid* where $first_rid is value of the first rid for this helper range.
  - This unique identifier is later passed to *sss_idmap_calculate_range()* where it is used as input for murmur hash.

Update algorithm for mapping SID to UNIX ID:

  - After mapping using primary slice fails then generate list of all domains that SID belongs to.
  - If such list is not empty then check if SID matches against secondary ranges of these domains and perform similar computation of UNIX ID as is done for primary slices. If SID is not in helper ranges a new range is generated and its identifier string is *domain_sid-$first_rid* where $first_rid is **((int)(RIDofSID / range_size)) \* range_size**.

Update algorithm for mapping UNIX ID to SID:

  - After mapping using primary slice fails then iterate through whole list of domains.
  - For each domain check all helper ranges for match with ID.
  - If match is found compute SID in the same manner as is done if match is in primary slice.

## Implementation details

Introduce new struct **idmap_range_params** that holds all relevant information for slice ranges, such as:

  - uint32_t min_id - minimal UNIX ID in given slice
  - uint32_t max_id - maximal UNIX ID in given slice
  - char \*range_id
  - uint32_t first_rid

These fields should be replaced in struct **idmap_domain_info** by new field struct idmap_range_params **range_params** that would describe primary slice assigned to this domain.

Add a linked list of struct idmap_range_params **helpers** into idmap_domain_info. These helpers will hold information for secondary slices assigned to this domain.

Update **sss_idmap_calculate_range()** to check for collision even with secondary slices.

Update **sss_idmap_sid_to_unix()** and **sss_idmap_unix_to_sid()**.

Add new function **sss_idmap_add_auto_domain_ex()** which is similar to sss_idmap_add_domain_ex() but generates helper ranges for domains and also takes callbacks which can be used to store domains generated for helper ranges.

## Configuration changes

ldap_idmap_helper_table_size (integer) - Maximal number of secondary slices that is tried when performing mapping from UNIX ID to SID. If value of ldap_idmap_helper_table_size is equal to 0 then no additional secondary slices are generated.

## How To Test

Create user in Active Directory whose RID part of SID is out of range size (value of option ldap_idmap_range_size). ID mapping should fail for such user, warning in logs should be generated and mainly lookup query should not return the user. After this feature is implemented it should be working.

## Authors

* Sumit Bose \<sbose@redhat.com\>
* Pavel Reichl \<preichl@redhat.com\>
