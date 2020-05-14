# Frequently Asked Questions

## What is the System Security Services Daemon?

SSSD is a system daemon. Its primary function is to provide access to identity and authentication remote resource through a common framework that can provide caching and offline support to the system. It provides PAM and NSS modules as well as a D-Bus interface interface for extended user information.

An excellent write-up on SSSD was created by Marko Myllynen and submitted to LWN.net: [SSSD: System Security Services Daemon](http://lwn.net/Articles/457415/)

### What platforms run SSSD?

We are currently aware of the following GNU/Linux distributions shipping some version of SSSD.

  - [Fedora Project](http://fedoraproject.org) - This is the platform used by the original developers
  - [Red Hat Enterprise Linux](http://www.redhat.com)
  - [CentOS](http://www.centos.org)
  - [openSUSE](http://www.opensuse.org)
  - [Debian](http://www.debian.org)
  - [Ubuntu](http://www.ubuntu.com)
  - [Gentoo](http://www.gentoo.org)
  - [Mandriva](http://www.mandriva.org)
  - [Arch Linux](http://www.archlinux.org) via [AUR](http://aur.archlinux.org/packages.php?K=sssd)

In theory, SSSD should compile and run (hopefully without modification) on any modern GNU/Linux distribution. Non-Linux platforms such as the BSD distributions are not yet fully supported, though some work is ongoing to port SSSD to [FreeBSD](http://portsmon.freebsd.org/portoverview.py?category=security&portname=sssd)

If you know of any other distributions shipping SSSD, please [tell us](mailto:sssd-devel@lists.fedorahosted.org)\!

## What branches are maintained upstream at a given time?

In general, the SSSD upstream supports at least one stable branch and one LTM branch at the same time. The branches designated as LTM (long-term maintenance) are supported for longer time than other releases with fixes for important bugs and security patches.

The regular releases are more frequent than LTM releases and are intended for users who like to use the latest functionality. The LTM releases are targeted at users who prefer to run very stable codebase and don't need the latest features.

An LTM release is maintained until the next LTM release comes out. After that, the LTM released is declared as end-of-life, but may still receive critical security fixes for up to one year to allow users to easily migrate to the next LTM release.

For more detailed information on our releases, see our [Releases](releases.md) page.

## Features

### When should I enable enumeration in SSSD? or Why is enumeration disabled by default?

"Enumeration" is SSSD's term for "reading in and displaying all the values of a particular map (users, groups, etc.)". We disable this by default in the SSSD in order to minimize the load on the servers with which SSSD must communicate. In most operations, listing the complete set of users or groups will never be necessary. Applications will generally request information about specific users or groups.

Enumerating all entries has a negative impact in load on the server and performance on the client (as we have to save all of the complex relationships between users and the groups to which they belong in the local cache). So because of this, we ship with enumerations disabled (the same behavior as the Samba project's winbind).

You should only enable enumerations (and the resultant performance issues) if you have applications or scripts in your environment that absolutely must be able to retrieve the complete lists. In these cases, enumeration can be enabled by setting :

    [domain/<domainname>]
    enumerate = true
    ...

in your `sssd.conf` file.

### Why does SSSD (1.7.0 and later) ignore source host[group] rules in HBAC?

There are two serious problems with the srchost feature. In order to do srchost processing, SSSD needs to trust the value passed to it by PAM for the `pam_data->srchost` field. Unfortunately, the PAM specification does not specify the format that this field must take. Different login programs provide different values for this field (such as IP address, short hostname or FQDN) and yet others simply pass a value provided by the remote host. As a result, SSSD has no way of verifying whether the remote client is actually who they say they are.

The second issue is that support of srchost rules requires significantly more processing and bigger LDAP lookups, as every client is now required to retrieve the complete list of hosts and hostgroups from the FreeIPA server, where otherwise it would only need to download the specification for the current host (and any groups that contain it). Eliminating the srchost rules results in at least one order of magnitude performance increase (more in slow LDAP environments).

So the combination of unreliability and slow performance resulted in our making the decision to opt to disable the srchost rules by default (treating them as "allow connection from any source"). It is possible to re-enable these rules with `ipa_hbac_support_srchost = True` in `sssd.conf`. However, note that recent IPA server releases do not support this feature on the server side either.

### What LDAP schema should I use?

The LDAP schema defines the set of default attribute names retrieved on the server as well as meaning of some of the attributes, notably membership attributes. The two most widely used schemas are rfc2307 and rfc2307bis with rfc2307 being the default. When using the rfc2307 schema, group members are listed by name in the `memberUid` attribute. When using the rfc2307bis schema, group members are listed by DN and stored in the `member` (or sometimes `uniqueMember`) attribute.

### How do I configure caching of sudo rules or autofs maps?

The SSSD manual pages only contain reference documentation on the options provided. However, two blog posts are available that describe how to configure [sudo](https://jhrozek.wordpress.com/2012/03/31/access-your-remote-sudo-rules-offline-with-sssd/) and [autofs](https://jhrozek.wordpress.com/2012/05/01/how-to-cache-automounter-maps-using-sssd/) caching in a more tutorial-like form.

### Why do some users appear as group members even if they are not?

Starting with SSSD 1.9.0, we took a different approach in how we store group members for performance reasons. While this new approach provides a notable performance boost, there are some situations when a user might be removed from a nested group but still show up as a member of a parent group.

When group information is requested, the SSSD doesn't download all the information about all members, but rather just downloads the list of user names and stores this list in the cache along with the group object. The list of members is returned from cache until the group object expires and is refreshed during an identity lookup such as invoking getent group from shell or calling getgrnam from a C program.

On the other hand, the membership information is always refreshed during a login, so that access control always operates on the most recent set of data in order to avoid unauthorized access or denial of access.

## Troubleshooting

### Basics of Troubleshooting

When something is not working right, your first step should be to enable debug logging. You can do this in any section in the `sssd.conf` file by setting `debug_level = N` where N is a bitmask of log levels to display. At the time of this writing (SSSD 1.7.0), the usage of each of these levels is still a bit inconsistent, but we are standardizing on the following levels: :

    debug_level (integer)
        Bit mask that indicates which debug levels will be visible. 0x0010
        is the default value as well as the lowest allowed value, 0xFFF0 is
        the most verbose mode. This setting overrides the settings from
        config file.
    
        Currently supported debug levels:
    
        0x0010: Fatal failures. Anything that would prevent SSSD from
        starting up or causes it to cease running.
    
        0x0020: Critical failures. An error that doesn't kill the SSSD, but
        one that indicates that at least one major feature is not going to
        work properly.
    
        0x0040: Serious failures. An error announcing that a particular
        request or operation has failed.
    
        0x0080: Minor failures. These are the errors that would percolate
        down to cause the operation failure of 2.
    
        0x0100: Configuration settings.
        0x0200: Function data.
    
        0x0400: Trace messages for operation functions.
    
        0x1000: Trace messages for internal control functions.
    
        0x2000: Contents of function-internal variables that may be
        interesting.
    
        0x4000: Extremely low-level tracing information.

For backwards-compatibility, the log levels zero through nine map to the above by including the specified level and lower.

### Common Issues

#### I don't see any groups when I run 'id username'

#### I don't see any group members when running 'getent group groupname'

This may be due to an incorrect `ldap_schema` setting in the `[domain/DOMAINNAME]` section of sssd.conf.

SSSD supports three LDAP schema types: RFC 2307, RFC 2307bis and IPA (the last being an extension of RFC 2307bis including memberOf backlinks).

By default, SSSD will use the more common RFC 2307 schema. The difference between RFC 2307 and RFC 2307bis is the way which group membership is stored in the LDAP server. In an RFC 2307 server, group members are stored as the multi-valued attribute `memberuid` which contains the *name* of the users that are members. In an RFC2307bis server, group members are stored as the multi-valued attribute `member` (or sometimes `uniqueMember`) which contains the *DN* of the user or group that is a member of this group. RFC2307bis allows nested groups to be maintained as well.

So the first thing to try when you hit this situation is to try setting `ldap_schema = rfc2307bis`, deleting `/var/lib/sss/db/cache_DOMAINNAME.ldb` and restarting SSSD. If that still doesn't work, add `ldap_group_member = uniqueMember`, delete the cache and restart once more. If that still doesn't work, it's time to [file a bug](https://github.com/SSSD/sssd/issues/new).

The recent glibc versions (Fedora 17 and later) also include a new NSS database `initgroups`, which defaults to `files` only. In order for initgroups to function correctly, you can either append the `sss` module in the same way as `passwd` and `group` databases or comment out the `initgroups` line completely. If your system configuration was generated by authconfig, the `initgroups` line is commented out by authconfig.

#### Authentication fails against LDAP

SSSD is stricter than pam_ldap. In order to perform an authentication, SSSD requires that the communication channel be encrypted. This means that if `sssd.conf` has `ldap_uri = ldap://<server>`, it will attempt to encrypt the communication channel with TLS (transport layer security). If `sssd.conf` has `ldap_uri = ldaps://<server>`, then SSL will be used instead of TLS. This requires that the LDAP server

1.  Supports TLS or SSL
2.  Has TLS access enabled on the standard LDAP port (389) (or alternate port, if specified in the `ldap_uri` or has SSL access enabled on the standard LDAPS port (or alternate port).
3.  Has a valid certificate trust

The first two of these requirements must be handled by the LDAP server administrator. Check with them that this is supported. If it is not, tell them to add it\! (Or find out if there are alternate, secure authentication providers such as Kerberos available).

This last requirement is the cause of most issues with authenticating against LDAP. If the client does not have proper trust of the LDAP server certificate, it will be unable to validate the connection, and SSSD will refuse to send the password. This is done because the LDAP protocol requires that the password is sent plaintext to the LDAP server. If the communication channel is not encrypted, it is trivial for any computer on the network(s) between the client and server to sniff the users' passwords. pam_ldap allowed such authentications to occur, but it was an inexcusable security breach.

If the certificate is not trusted, a syslog message is written, indicating that TLS encryption could not be started, as well as any additional information provided by the openldap libraries.

The first step to resolving this is to contact your LDAP server administrator to acquire a copy of the public CA certificate for the certificate authority used to sign the LDAP server certificate. This should be placed on the filesystem and a directive should be added to `sssd.conf` to locate it: `ldap_tls_cacert = /path/to/cacert`

If the LDAP server is self-signed (or for testing purposes while awaiting a response from the server administrator), the config option `ldap_tls_reqcert = never` can be added to the `sssd.conf`, which will tell SSSD to blindly trust the certificate provided by the LDAP server. **This is a security risk**. It is possible for an attacker to run a man-in-the-middle attack if your clients are not properly validating certificates against a CA. Do not set this option in production.

If the logs aren't helping, you can verify your configuration by taking the following steps: Verify that the services work when not called by SSSD.

Using a LDAP server IP of 10.1.0.7 and a base of dc=example,dc=com, you could search using a simple anonymous bind and with mandatory TLS to confirm LDAP server connectivity using ldapsearch: :

    ldapsearch -x -ZZ -H ldap://10.1.0.7 -b dc=example,dc=com

If this fails with :

    ldap_start_tls: Connect error (-11) additional info: TLS error -8179:Unknown code ___f 13

most likely you do not have a correct CA certificate available in the correct location.

One other common certificate issue is with servers that have multiple hostnames. When connecting with SSL or TLS, the hostname used to connect must include the fully-qualified domain name specified by the certificate subject or subjectAltName. In most cases, this means that specifying an LDAP URI with a numeric IP address will fail to work with SSL/TLS.

#### Connection to LDAP servers on non-standard ports fail

On systems running SELinux in enforcing mode (such as Fedora, Red Hat Enterprise Linux and CentOS), you need to modify your client machine's SELinux policy to allow contacting that port. For example, if you are communicating with an LDAP server running on port 1389, you would need to run the command (as root): :

    semanage port -a -t ldap_port_t -p tcp 1389

This tells the SELinux policy that port 1389 is defined as an LDAP port (to which SSSD has access to talk). This would need to be done on each of your client machines (or coordinated with some tool like puppet).

#### Referral chasing seems to be slowing down the SSSD

There can be a performance penalty if the SSSD performs a large number of referral chasing operations. You can tell a referral rebind operation from the logs: :

    [sssd[be[EXAMPLE]]] [sdap_rebind_proc] (7): Successfully bind to [ldap://example.com/DC=example,DC=com].

Unless your environment requires the use of referrals, you can try setting the `ldap_referrals` options to `false` and restarting the SSSD. Some users have reported improved performance after turning the referral chasing off especially in the case of Microsoft Active Directory.

### Troubleshooting

There are dedicated pages that describe [how to troubleshoot problems](troubleshooting.md) and [how to submit a detailed bug report](reporting_bugs.md).

### Getting help

SSSD has a dedicated [user support mailing list](https://lists.fedorahosted.org/archives/list/sssd-users@lists.fedorahosted.org/).

SSSD development discussions occur either on the [SSSD development list](https://lists.fedorahosted.org/archives/list/sssd-devel@lists.fedorahosted.org/) or on the [\#sssd IRC channel](irc://irc.freenode.net/sssd) on [freenode](http://freenode.net/).

### Tracking bugs and enhancement requests

If you think you have found a bug or would like to file an enhancement request, create a [new issue](https://github.com/SSSD/sssd/issues/new). Logging into the issue tracker requires a Fedora Account System login. To create one, use the [FAS interface](https://admin.fedoraproject.org/accounts/).
