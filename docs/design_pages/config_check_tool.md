---
version: 1.14.x
---

# sss_confcheck tool (deprecated and moved to sssctl)

This tool is no longer developed and it's functionality was moved to sssctl tool.

Related ticket(s):

  - <https://github.com/SSSD/sssd/issues/3311>

## Problem statement

There is no easy way to debug the SSSD configuration without having to look into the debug logs. Moreover the debug logs can be difficult to understand for people outside SSSD development team. Some common issues can be identified during static offline analysis of the config files. To find these issues soon we need a tool that performs this analysis and provides human readable report.

## Use cases

  - performing ad-hoc static analysis of the installed SSSD configuration
  - performing ad-hoc static analysis of SSSD configuration files retrieved from user with some SSSD problems

## Overview of the solution - sss_confcheck tool

A new tool will be added to sss_\* tools that will perform static analysis of SSSD configuration files. This tool can be run without any parameters in which case it will print a report to the standard output in the following or similar format: :

    $ sss_confcheck
    Number of identified issues: 1
    [rule/allowed_nss_options]: Attribute 'foo' is not allowed in section 'nss'. Check for typos.
    
    Used configuration file:
    <Here will be the contents of sssd.conf file>
    
    Number of used configuration override snippets: 2
    List of configuration override snippets in order of priority (lowest priority first):
    snippet_name_1.conf
    snippet_name_2.conf
    
    Content of configuration override snippets:
    snippet_name_1.conf:
    <content of snippet_name_1.conf>
    
    snippet_name_2.conf:
    <content of snippet_name_2.conf>
    
    Merged configuration:
    <content of merged configuration (sssd.conf merged with snippets)>

Available options: :

    ?, --help
  --config-file PATH_CONFIG_FILE                Path to config file that will be checked.
  --snippets-dir PATH_TO_SNIPPETS_DIRECTORY     Path to snippets directory.
  --no-validators                               Do not use validators (no analysis will be made).
  --no-file-content                             Do not print config file or snippet contents.
  --no-snippets                                 Ignore the snippets.
  --silent                                      If no errors are detected, do not print anything.

## Implementation details

The tool will use ding-libs validators feature described [in this design document](libini_config_file_checks.md).

## Configuration changes

No configuration changes.

## How To Test

Depending on the capabilities of validators used by SSSD, make an error in configuration and run sss_confcheck to see if it was detected.

## Planned features in version 1 - initial version

Validators capabilities:

  - able to detect typo in option name
  - able to detect typo in section name
  - able to detect option in wrong section

Limitations:

  - printing the resulting configuration (after merging with snippets) may not be in the initial version.

## Authors

Michal Židek \<mzidek@redhat.com\>
