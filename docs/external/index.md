# External documentation about SSSD

## Red Hat documentation

Red Hat maintains documentation about SSSD and Red Hat IDM. While the documentation can be Red Hat specific as far as commands like package installation or configuration file location go, it is still a very good source of information regardless of the distribution you are running.

  - The [System-level authentication guide](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/System-Level_Authentication_Guide/identity-auth-stores.html) describes how SSSD works and how to configure it
  - The [Windows integration guide](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Windows_Integration_Guide/index.html) documents how to either join an SSSD client to an AD domain or integrate an Red Hat IDM domain with an AD forest
  - The [Linux domain identity, authentication, and policy guide](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Linux_Domain_Identity_Authentication_and_Policy_Guide/index.html) is aimed at documenting the Red Hat IDM server, but still might be useful to many users of SSSD.

## Community documentation

This is a collection of documentation contributed by our community. Please note that the SSSD team does not maintain this documentation.

  - [Troubleshooting Active Directory and SSSD With Packet Captures](https://support.cloudshark.org/kb/sssd-activedirectory-captures.html)
    - This document illustrates and documents network traffic between an SSSD client running with the LDAP provider and an Active Directory server, including use-cases such as invalid CA certificate.
