# Integrating with a Windows server using the AD provider

This page describes how to configure SSSD to authenticate with a Windows 2008 or later Domain Server using the Active Directory provider (`id_provider=ad`).

## Contribute AD documentation

If there is a specific document for your distribution or environment, such as the RHEL guide below, please let us know so that we can include it\!

### Red Hat documentation

Red Hat maintains a very in-depth [guide about SSSD and Windows integration](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Windows_Integration_Guide/index.html). Some of the commands such as setting up the PAM stack or installing packages are specific to RHEL, CentOS or Fedora, but the general information are useful for all distributions.

## Required Software

The AD provider was firstly introduced with SSSD 1.9.0. If you are using an older SSSD version, follow the guide on configuring the LDAP provider with Active Directory.

## Windows Server Setup

The domain to be configured is `ad.example.com` using realm `AD.EXAMPLE.COM.` The Windows server has the hostname of `server.ad.example.com`, and the client host where SSSD is running is called `client.ad.example.com`. Reboot Windows during installation and setup when prompted and complete the needed steps as Administrator.

The Active Directory provider is able to either map the Windows Security Identifiers (SIDs) into POSIX IDs or use the POSIX IDs that are set on the AD server. By default, the AD provider uses the automatic ID mapping method. In order to use the POSIX IDs, you need to set up [Identity Management for UNIX](https://technet.microsoft.com/en-us/library/cc731178.aspx). Please note that starting with Windows Server 2016, the [Identity Management for UNIX UI is deprecated](https://blogs.technet.microsoft.com/activedirectoryua/2016/02/09/identity-management-for-unix-idmu-is-deprecated-in-windows-server/). However, it is still possible to set the POSIX attributes. For managing POSIX attributes in environments with IPA-AD trusts deployed, the [ID views](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Linux_Domain_Identity_Authentication_and_Policy_Guide/id-views.html) feature of IDM might also be interesting.

### Operating System Installation

  - Boot from the Windows 2012 Server DVD
  - Install Windows 2012 Server and set the computer name to `server`

### Domain Configuration

  - In Server Manager add the Active Directory Domain Services role
  - Create a new domain named `ad.example.com`
  - Make sure `server.ad.example.com` is resolvable in DNS

### Global Catalog Configuration

When working with multiple trusted domains, SSSD often reads the data from the Global Catalog first. However, POSIX attributes such as UIDs or GIDs are not replicated to the Global Catalog by default. For performance reasons, it might be a good idea to set them to be replicated manually. This recommendation applies to setups that do not use automatic ID mapping and use `ldap_id_mapping=False` instead.

  - Install the Identity Management for UNIX Components
    - Please follow this [technet article](https://technet.microsoft.com/en-us/library/cc731178.aspx) to install Identity Management for UNIX on primary and child domains controllers
    - After the installation has finished, you'll be able to assign POSIX UID, GID and other attributes using a tab called UNIX Attributes in the Properties menu
  - Setup Schema Snap-in
    - To enable new attributes to replicate to the GC we need an Active Directory Schema snap-in. Follow [this article](https://www.microsoft.com/en-US/download/details.aspx?id=53314) to install the Schema Snap-In
  - Modify Attributes for replication
    - The following [article](https://support.microsoft.com/en-us/help/248717/how-to-modify-attributes-that-replicate-to-the-global-catalog) explains how to select any attribute for replication
    - In our case, select `uidNumber`, `gidNumber`, `unixHomeDirectory` and `loginShell`
  - Verifying Attributes replication to Global Catalog
    - In general, search for a user entry that has the POSIX attributes set on port 3268 of a Domain Controller
    - You can use the LDP tool from Windows or later, when the GNU/Linux machine is joined, simply `ldapsearch`

## Client configuration

The client configuration consists of several steps, each of which can be either performed manually or using a configuration tool such as [realmd](https://freedesktop.org/software/realmd/). The latter is always recommended due to the ease of use and correctness of the resulting configuration. Let's take a look at the automated procedure first.

### DNS configuration

It is recommended that the GNU/Linux client you are enrolling is able to resolve the SRV records the Active directory publishes. In order to do so, the clients would typically point at the AD DCs in `/etc/resolv.conf`. You can verify this using dig:

    dig -t SRV _ldap._tcp.ad.example.com @server.ad.example.com

If the SRV records can't be resolved, you need to list the reachable servers using the `ad_server` configuration option. Note that SSSD auto-discovers all domains in the forest by default, so if any of the DCs in other domains are not reachable, either exclude that domain with `ad_enabled_domains` or, if only some DCs from that trusted domain are reachable, define a per-subdomain section in the config file (see below for an example).

### Joining the GNU/Linux client using realmd

The realmd (Realm Discovery) project is a system service that manages discovery and enrolment to several centralized domains including AD or IPA. realmd is included in several popular GNU/Linux distributions including:

  - Red Hat Enterprise Linux 7.0 and later
  - Fedora 19 and later
  - Ubuntu 13.04 and later
  - Debian 8.0 and later

Run `realm discover` to see what domains realmd can find. Note that this functionality relies on NetworkManager being up and running in order to read the DHCP domain:

    realm discover

Alternatively, you can specify the realm yourself. This functionality only relies on DNS being set up correctly, typically by pointing `/etc/resolv.conf` to the AD DC:

    realm discover AD.EXAMPLE.COM

Finally, joining the Active Directory domain is as easy as:

    realm join AD.EXAMPLE.COM

You will be prompted for Administrator password. However, realmd supports more enrolment options, including using a one-time password or selecting a custom OU. Refer to the [realmd documentation](https://www.freedesktop.org/software/realmd/docs/) for more details.

Please note that the `realm permit` command configures the simple access provider.

### Access control options

There is a number of access control options available to a directly-enrolled AD client machine.

  - `access_provider=simple`
    - Pros: Very simple. Supports nested groups, because the user entry is fully evaluated on login first and then the simple access provider runs.
    - Cons: Does not support any more expressiveness than allow/deny a user or a group.
  - `access_provider=ad`
    - Pros: Supports fully centralized environments by using GPOs for access control
    - Cons: Not supported with older releases. In a mixed environment, sometimes using the same options for GNU/Linux and Windows machines might not be desirable.
  - `ad_access_filter`
    - Pros: Very expressive, can be used to allow/deny based on any properties of the LDAP user object. The filter is applied on the user entry in LDAP, not the cached entry, which might have implications on evaluating nested group memberships.
    - Cons: Cumbersome to write

It is also possible to use completely external means of access control, such as `pam_access.so`. Those might be useful when supporting legacy stack alongside SSSD or when defining access control by means SSSD doesn't support (such as per netgroup).

### Joining the GNU/Linux client to the AD domain manually

The manual process of joining the GNU/Linux client to the AD domain consists of several steps:

  - Acquiring the host keytab with Samba or create it using `ktpass` on the AD controller
  - Configuring `sssd.conf`
  - Configuring the system to use the SSSD for identity information and authentication

#### Creating Host Keytab with Samba

On the GNU/Linux client with properly configured `/etc/krb5.conf` (see below) and suitable `/etc/samba/smb.conf`:

##### /etc/krb5.conf

Adjust the contents to match your realm data:

    [logging]
    default = FILE:/var/log/krb5libs.log
    
    [libdefaults]
    default_realm = AD.EXAMPLE.COM
    dns_lookup_realm = true
    dns_lookup_kdc = true
    ticket_lifetime = 24h
    renew_lifetime = 7d
    forwardable = true
    rdns = false
    
    # You may also want either of:
    # allow_weak_crypto = true
    # default_tkt_enctypes = arcfour-hmac
    
    [realms]
    # Define only if DNS lookups are not working
    # AD.EXAMPLE.COM = {
    # kdc = server.ad.example.com
    # master_kdc = server.ad.example.com
    # admin_server = server.ad.example.com
    # }
    
    [domain_realm]
    # Define only if DNS lookups are not working
    # .ad.example.com = AD.EXAMPLE.COM
    # ad.example.com = AD.EXAMPLE.COM

Make sure `kinit aduser@AD.EXAMPLE.COM` works properly. If not, using `KRB5_TRACE` usually provides helpful information:

    KRB5_TRACE=/dev/stdout kinit -V aduser@AD.EXAMPLE.COM.

##### /etc/samba/smb.conf

Adjust the contents to match your realm data:

    [global]
    security = ads
    realm = AD.EXAMPLE.COM
    workgroup = EXAMPLE
    
    log file = /var/log/samba/%m.log
    
    kerberos method = secrets and keytab
    
    client signing = yes
    client use spnego = yes

Now join the client with:

    kinit Administrator
    net ads join -k

Alternatively, without using the Kerberos ticket:

    net ads join -U Administrator

Additional principals can be created later with `net ads keytab add` if needed.

You don't need a Domain Administrator account to do this, you just need an account with sufficient rights to join a machine to the domain. This is a notable advantage of this approach over generating the keytab directly on the AD controller.

### Creating Service Keytab on AD

Do not do this step if you've already created a keytab using Samba. This part of the guide might be useful if the password for Administrator or another user who is able to enroll computers can't be shared.

On the Windows server:

  - Open Users & Computers snap-in
  - Create a new Computer object named `client` (i.e., the name of the host running SSSD)
  - On the command prompt
    - `setspn -A host/client.ad.example.com@AD.EXAMPLE.COM client`
    - `setspn -L client`
    - `ktpass /princ host/client.ad.example.com@AD.EXAMPLE.COM /out client-host.keytab /crypto all /ptype KRB5_NT_PRINCIPAL -desonly /mapuser AD\client$ +setupn +rndPass +setpass +answer`
  - This sets the machine account password and UPN for the principal
  - If you create additional keytabs for the host add `-setpass -setupn` for the above command to prevent resetting the machine password (thus changing kvno) and to prevent overwriting the UPN
  - Transfer the keytab created in a secure manner to the client as `/etc/krb5.keytab` and make sure its permissions are correct:
    - `chown root:root /etc/krb5.keytab`
    - `chmod 0600 /etc/krb5.keytab`
    - `restorecon /etc/krb5.keytab`

See the next section for verifying the keytab file and the example `sssd.conf` below for the needed SSSD configuration.

### Pre-flight check

To verify the keytab was acquired correctly and can be used to access AD:

    klist -ke
    kinit -k CLIENT\$@AD.EXAMPLE.COM

Now using this credential you've just created try fetching data from the server with `ldapsearch` (in case of issues make sure `/etc/openldap/ldap.conf` does not contain any unwanted settings):

    /usr/bin/ldapsearch -H ldap://server.ad.example.com/ -Y GSSAPI -N -b "dc=ad,dc=example,dc=com" "(&(objectClass=user)(sAMAccountName=aduser))"

By using the credential from the keytab, you've verified that this credential has sufficient rights to retrieve user information.

You can also check if searching the Global Catalog works and whether the attributes your environment depends on are replicated to the Global Catalog:

    /usr/bin/ldapsearch -H ldap://server.ad.example.com:3268 -Y GSSAPI -N -b "dc=ad,dc=example,dc=com" "(&(objectClass=user)(sAMAccountName=aduser))"

After both `kinit` and `ldapsearch` work properly proceed to actual SSSD configuration.

## SSSD setup

Configuring SSSD consists of several steps:

  - Install the `sssd-ad` package on the GNU/Linux client machine
  - Make configuration changes to the files below
  - Start the `sssd` service

### /etc/sssd/sssd.conf

Example `sssd.conf` configuration, additional options can be added as needed:

    [sssd]
    config_file_version = 2
    domains = ad.example.com
    services = nss, pam
    
    [domain/ad.example.com]
    # Uncomment if you need offline logins
    # cache_credentials = true
    
    id_provider = ad
    auth_provider = ad
    access_provider = ad
    
    # Uncomment if service discovery is not working
    # ad_server = server.ad.example.com
    
    # Uncomment if you want to use POSIX UIDs and GIDs set on the AD side
    # ldap_id_mapping = False
    
    # Uncomment if the trusted domains are not reachable
    #ad_enabled_domains = ad.example.com
    
    # Comment out if the users have the shell and home dir set on the AD side
    default_shell = /bin/bash
    fallback_homedir = /home/%d/%u
    
    # Uncomment and adjust if the default principal SHORTNAME$@REALM is not available
    # ldap_sasl_authid = host/client.ad.example.com@AD.EXAMPLE.COM
    
    # Comment out if you prefer to use shortnames.
    use_fully_qualified_names = True
    
    # Uncomment if the child domain is reachable, but only using a specific DC
    # [domain/ad.example.com/child.example.com]
    # ad_server = dc.child.example.com

Set the file ownership and permissions on sssd.conf:

    chown root:root /etc/sssd/sssd.conf
    chmod 0600 /etc/sssd/sssd.conf
    restorecon /etc/sssd/sssd.conf

### NSS/PAM Configuration

Depending on your distribution you have different options how to enable SSSD.

#### Fedora/RHEL

Use `authconfig` to enable SSSD, install `oddjob-mkhomedir` to make sure home directory creation works with SELinux:

    authconfig --enablesssd --enablesssdauth --enablemkhomedir --update

#### Debian/Ubuntu

Install `libnss-sss` and `libpam-sss` to have SSSD added as NSS/PAM provider in `/etc/nsswitch.conf` and `/etc/pam.d/common-*` configuration files. Add `pam_mkhomedir.so` to PAM session configuration manually. Restart SSSD after these changes.

#### Configure NSS/PAM manually

Manual configuration can be done with the following changes. The file paths for PAM in the example below are from Debian/Ubuntu, in Fedora/RHEL corresponding manual configuration should be done in `/etc/pam.d/system-auth` and `/etc/pam.d/password-auth`.

#### /etc/nsswitch.conf

It is of course fine to use other modules, especially for maps that SSSD does not handle:

    passwd: files sss
    shadow: files sss
    group: files sss
    
    hosts: files dns
    
    bootparams: files
    
    ethers: files
    netmasks: files
    networks: files
    protocols: files
    rpc: files
    services: files sss
    
    netgroup: files sss
    
    publickey: files
    
    automount: files sss
    aliases: files
    sudoers : files sss

#### /etc/pam.d/common-auth

Right after the `pam_unix.so` line, add:

    auth sufficient pam_sss.so use_first_pass

#### /etc/pam.d/common-account

Right after the `pam_unix.so` line, add:

    account [default=bad success=ok user_unknown=ignore] pam_sss.so

#### /etc/pam.d/common-password

Right after the `pam_unix.so` line, add:

    password sufficient pam_sss.so use_authtok

#### /etc/pam.d/common-session

Just before the `pam_unix.so` line, add:

    session optional pam_mkhomedir.so

Right after the `pam_unix.so` line, add:

    session optional pam_sss.so

## Understanding Kerberos & Active Directory

It is important to understand that (unlike GNU/Linux MIT based KDC) Active Directory based KDC divides Kerberos principals into two groups:

  - *User Principals* - usually equals to the `sAMAccountname` attribute of the object in AD. In short, User Principal is entitled to obtain TGT (ticket granting ticket). User Principals could be hence used to generate a TGT via `kinit -k`.
  - *Service Principals* - represents which Kerberized service can be used on the computer in question. Service principals can NOT be used to obtain a TGT and can not be used to grant access to a Active Directory controller for example.

Each user object in Active Directory (understand that a computer object in AD is de-facto user object as well) can have:

  - maximum of 2 User Principal Names (UPN). One is pre-defined by the previously mentioned `sAMAccountName` LDAP attribute (for computer objects it will be in the form of *SHORTNAME$*) and the second by its `UserPrincipalName` string attribute
  - many Service Principal Names (typically one for each Kerberized service we want to enable on the computer) defined by the `ServicePrincipalName` (SPN) list attribute. The attributes can be seen/set using the ADSIedit snap-in for example.

## Optional Final Test

You may have made iterative changes to your setup while learning about SSSD. To make sure that your setup actually works, and you're not relying on cached credentials, or cached LDAP information, you may want to clear out the local cache. Obviously this will erase local credentials, and all cached user information, so you should only do this for testing, and while on the network with network access to the AD servers:

    service sssd stop
    rm -f /var/lib/sss/db/*
    rm -f /var/lib/sss/mc/*
    service sssd start
    getent passwd administrator@ad.example.com

If all looks well on your system after this, you know that sssd is able o use the kerberos and ldap services you've configured.

The example configuration enforces the use of *fully qualified names*. This restriction will force all lookups to contain the domain name as well, either the full domain name as specified in sssd.conf (`getent passwd administrator@ad.example.com`) or the short NetBIOS name (`getent passwd AD\\Administrator`). This restriction helps separate users from different domains, especially in setups with multiple domains in a trusted environment, or in cases where local UNIX users might have the same user names as AD users.

## Further reading

Please see the [following article on Technet site](http://technet.microsoft.com/en-us/library/cc772815%28WS.10%29.aspx) for more in-depth Kerberos understanding
