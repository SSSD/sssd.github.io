# Debugging and troubleshooting SSSD

This document should help users who are trying to troubleshoot why their SSSD setup is not working as expected. After following the steps described here, the user should be able to either fix the configuration themselves or provide the developers/support a complete set of debug information to follow on in a <span data-role="doc">bug report \<reporting_bugs\></spanor on the [user support list](https://lists.fedorahosted.org/admin/lists/sssd-users.lists.fedorahosted.org/).

The SSSD provides two major features - obtaining information about users and authenticating users. Each of these hooks into different system APIs and should be viewed separately. However, a successful authentication can only be performed when the information about a user can be retrieved, so if authentication doesn't work in your case, please make sure you can at least obtain info from about the user with `getent passwd $user` and `id`.

## Troubleshooting guides

We are trying to document on examples how to read debug messages and how to troubleshoot specific issues. These are currently available guides that can help you:

<div class="toctree">

troubleshooting/how-to-troubleshoot-backend sudo_troubleshooting troubleshooting/how-to-troubleshoot-fleet-commander-integration

</div>

## Let tools help you\!

Rather than hand-crafting the SSSD and system configuration yourself, it's much wiser to let an automated tool do its job. If you want to connect an IPA client, use `ipa-client-install`. For connecting a machine to an Active Directory domain, [realmd](https://freedesktop.org/software/realmd/) is the best tool for the job. If you're on RHEL-6, where realmd is not available, you can still use [adcli](https://www.freedesktop.org/software/realmd/adcli/adcli.html).

On Fedora or RHEL, the `authconfig` utility can also help you set up the Name Service Switch and/or the PAM stack while allowing you to use a custom sssd.conf with the `--enablesssd` and `--enablesssdauth` options. Please note these options only enable SSSD in the NSS and PAM stacks but do not configure the SSSD service itself\!

If you are using a different distribution or operating system, please let us know if there are any special instructions to set the system up and we'll be glad to either link or include the information.

## SSSD debug logs

Each process that SSSD consists of is represented by a section in the `sssd.conf` config file. To enable debugging persistently across SSSD service restarts, put the directive `debug_level=N`, where N typically stands for a number between 1 and 10 into the particular section. Levels up to 3 should log mostly failures (although we haven't really been consistent especially earlier in the SSSD development) and anything above level 8 provides a large number of log messages. Level 6 might be a good starting point for debugging problems. You can also use the [sss_debuglevel(8)](https://jhrozek.fedorapeople.org/sssd/1.14.0/man/sss_debuglevel.8.html) tool to enable debugging on the fly without having to restart the daemon.

On Fedora/RHEL, the debug logs are stored under `/var/log/sssd`. There is one log file per SSSD process. The services (also called responders) log into a log file called `sssd_$service`, for example NSS responder logs into `/var/log/sssd/sssd_nss.log`. The domain sections log into files called `sssd_$domainname.log`. The short-lived helper processes also log into their own log files, such as `ldap_child.log` or `krb5_child.log`.

Keep in mind that enabling `debug_level` in the `[sssd]` section only enables debugging of the sssd process itself, not all the worker processes\!

## Troubleshooting User Information

Before diving into the SSSD logs and config files it is very beneficial to know how does the [SSSD request flow](https://jhrozek.wordpress.com/2015/03/11/anatomy-of-sssd-user-lookup/) looks like. Having that in mind, you can go through the following check-list to identify where the problem might be.

For even more in-depth information on SSSD's architecture, refer to [Pavel Brezina's thesis](https://is.muni.cz/th/359290/fi_m/thesis.pdf).

Please note the examples of the `DEBUG` messages are subject to change in future SSSD versions.

### General tips

  - To avoid SSSD caching, it is often useful to reproduce the bugs with an empty cache or at least invalid cache. However, keep in mind that also the cached credentials are stored in the cache\! Do not remove the cache files if your system is offline and it relies on SSSD authentication\!
  - Before sending the logs and/or config files to a publicly-accessible space, such as mailing lists or bug trackers, check the files for any sensitive information.
  - Please only send log files relevant to the occurrence of the issue. Issues in log files that are mega- or gigabytes large are more likely to be skipped
  - Unless the problem you're trying to diagnose is related to enumeration per se, always reproduce the issue with `enumerate=false`. Triaging logs with enumeration enabled obfuscates the normal data flow..

### `getent passwd` or `id` doesn't print the user or `getent group` doesn't print the group at all

Please follow the usual name-service request flow:

1.  Is sssd running at all? On most recent systems, calling:
    
        # systemctl status sssd
    
    would display the service status. Alternatively, check for the sssd processes with `ps -ef | grep sssd`. or similar.

2.  Is the `sss` module present in `/etc/nsswitch.conf` for all databases?
    
    - If there is a separate initgroups database configured, make sure it either contains the `sss` module as well or comment the `initgroups` line completely

3.  Does the request reach the SSSD responder processes? Enable debugging by putting `debug_level=6` (or higher) into the `[nss]` section. Restart SSSD and check the nss log for incoming requests with the matching timestamp to your getent or id command. Here is how an incoming request looks like with SSSD-1.15:
    
        [sssd[nss]] [get_client_cred] (0x4000): Client creds: euid[10327] egid[10327] pid[18144].
        [sssd[nss]] [setup_client_idle_timer] (0x4000): Idle timer re-set for client [0x13c9960][22]
        [sssd[nss]] [accept_fd_handler] (0x0400): Client connected!
        [sssd[nss]] [sss_cmd_get_version] (0x0200): Received client version [1].
        [sssd[nss]] [sss_cmd_get_version] (0x0200): Offered version [1].
        [sssd[nss]] [nss_getby_name] (0x0400): Input name: admin

4.  If the command is reaching the NSS responder, does it get forwarded to the Data Provider? Does the Data Provider request end successfully? With SSSD 1.15, an unsuccessful request would look like this:
    
        [sssd[nss]] [cache_req_search_dp] (0x0400): CR #3: Looking up [admin@ipa.test] in data provider
        [sssd[nss]] [sss_dp_issue_request] (0x0400): Issuing request for [0x41e51c:1:admin@ipa.test@ipa.test]
        [sssd[nss]] [sss_dp_get_account_msg] (0x0400): Creating request for [ipa.test][0x1][BE_REQ_USER][name=admin@ipa.test:-]
        [sssd[nss]] [sss_dp_internal_get_send] (0x0400): Entering request [0x41e51c:1:admin@ipa.test@ipa.test]
        [sssd[nss]] [sss_dp_req_destructor] (0x0400): Deleting request: [0x41e51c:1:admin@win.trust.test@win.trust.test]
        [sssd[nss]] [sss_dp_get_reply] (0x0010): The Data Provider returned an error [org.freedesktop.sssd.Error.DataProvider.Offline]
        [sssd[nss]] [cache_req_common_dp_recv] (0x0040): CR #3: Data Provider Error: 3, 5, Failed to get reply from Data Provider
        [sssd[nss]] [cache_req_common_dp_recv] (0x0400): CR #3: Due to an error we will return cached data
    
    In contrast, a request that ran into completion would look like this:
    
        [sssd[nss]] [cache_req_search_dp] (0x0400): CR #3: Looking up [admin@ipa.test] in data provider
        [sssd[nss]] [sss_dp_issue_request] (0x0400): Issuing request for [0x41e51c:1:admin@ipa.test@ipa.test]
        [sssd[nss]] [sss_dp_get_account_msg] (0x0400): Creating request for [ipa.test][0x1][BE_REQ_USER][name=admin@ipa.test:-]
        [sssd[nss]] [sss_dp_get_reply] (0x1000): Got reply from Data Provider - DP error code: 0 errno: 0 error message: Success
        [sssd[nss]] [cache_req_search_cache] (0x0400): CR #3: Looking up [admin@ipa.test] in cache
    
    If the Data Provider request had finished completely, but you're still not seeing any data, then chances are the search didn't match any object. Either, way, the next step is to look into the logs from the `[domain]` section. Put `debug_level=6` or higher into the appropriate [domain] section, restart SSSD, re-run the lookup and continue debugging in the next section.

### Troubleshooting general `sssd_be` problems

  - The back end performs several different operations, so it might be difficult to see where the problem is at first. At the highest level, the back end performs these steps, in this order
    - The request is received from the responder
    - The back end resolves the server to connect to. This step might involve locating the client site or resolving a SRV query
    - The back end establishes connection to the server. In case the connection is authenticated, then a proper keytab or a certificate might be required
    - Once connection is established, the back end runs the search. You should see the LDAP filter, search base and requested attributes.
    - After the search finishes, the entries that matched are stored to the cache
    - When the request ends (correctly or not), the status code is returned to the responder
  - Make sure the back end is in "neutral" or "online" state when you run the search.
    - With some responder/provider combinations, SSSD might run a search immediately after startup, which, in case of misconfiguration, might mark the back end offline even before the first request by the user arrives.
    - You can forcibly set SSSD into offline or online state using the `SIGUSR1` and `SIGUSR2` signals, see the [sssd(8)](https://jhrozek.fedorapeople.org/sssd/1.14.0/man/sssd.8.html) man page for details.
  - Can the remote server be resolved? Check if the DNS servers in `/etc/resolv.conf` are correct. With AD or IPA back ends, you generally want them to point to the AD or IPA server directly.
    - Use the `dig` utility to test SRV queries, for instance:
        
            dig -t SRV _ldap._tcp.ad.example.com @127.0.0.1
  - Can the connection be established with the same security properties SSSD uses?
    - Many back ends require the connection to be authenticated. In case of AD and IPA, the connection is authenticated using the system keytab, the LDAP back end often uses certificates.
    - `ldapsearch -ZZ` is useful to test problems with certificates, since SSSD uses openldap libraries under the hood.
    - For debugging GSSAPI authentication, `kinit` is useful, often together with `KRB5_TRACE`. Take care to select the correct principal, especially with the AD back end. If you select the highest `debug_level = 10`, then `ldap_child.log` would contain the Kerberos tracing information as well.
  - Are the LDAP search properties correct?
    - Check if all the attributes required by the search are present on the server. This is especially important with the AD provider where the entries might not contain the POSIX attributes at all or might not have the POSIX attributes replicated to Global Catalog, in case SSSD is connecting to the GC.
        - As of SSSD-1.15, try looking for `DEBUG` messages from `sdap_get_generic_ext_step`
    - Is the search base correct, especially with trusted subdomains? Incorrect search base with an AD subdomain would yield a referral.
  - Try running the same search with the ldapsearch utility. Don't forget to use the same authentication method as SSSD uses\! For `id_provider=ad` or `ipa` this means adding `-Y GSSAPI` to the `ldapsearch invocation`.

### Assorted common SSSD problems

  - Logins take too long or the time to execute `id $username` takes too long.
    - First, make sure to understand [what does id username do](https://jhrozek.wordpress.com/2014/01/27/why-is-id-so-slow-with-sssd/). Do you really care about its performance? Chances are you're more interested in `id -G` performance.
    - Check out the `ignore_group_members` options in the `sssd.conf(5)` manual page.
    - Some users improved their SSSD performance a lot by mounting the cache into `tmpfs`
  - `getent passwd` and `getent group` doesn't display any users or groups.
    - Enumeration is disabled by design. See the FAQ page for explanation
  - Changes on the server are not reflected on the client for quite some time
    - The SSSD caches identity information for some time. You can force cache refresh on next lookup using the [sss_cache(8)](https://jhrozek.fedorapeople.org/sssd/1.14.0/man/sss_cache.8.html) tool.
    - Please note that during login, updated information is always re-read from the server
  - After enrolling the same machine to a domain with different users (perhaps a test VM was enrolled to a newly provisioned server), no users can be resolved or log in
    - Probably the new server has different ID values even if the users are named the same (like admin in an IPA domain). Currently UID changes are not supported even though [we plan on addressing that eventually](https://pagure.io/SSSD/sssd/issue/884). At the moment, caches must be removed.

### Common LDAP provider issues

  - When running `id user`, no groups are displayed.
  - When running `getent group $groupname`, no group members are displayed
    - In both cases, make sure the selected schema is correct. By default, SSSD will use the more common RFC 2307 schema. The difference between RFC 2307 and RFC 2307bis is the way which group membership is stored in the LDAP server. In an RFC 2307 server, group members are stored as the multi-valued attribute `memberuid` which contains the name of the users that are members. In an RFC2307bis server, group members are stored as the multi-valued attribute `member` (or sometimes `uniqueMember`) which contains the DN of the user or group that is a member of this group. RFC2307bis allows nested groups to be maintained as well.
  - If using the LDAP provider with Active Directory, the back end randomly goes offline and performs poorly.
    - Make sure the referrals are disabled. See the FAQ page for explanation. Also please consider migrating to the AD provider. The AD provider disabled referral support by default, so there's no need to disable referrals explicitly
  - When enumeration is enabled, or when the underlying storage has issues, the `sssd_be` process is being killed by `SIGTERM` or even `SIGKILL`
    - With huge directories, the `sssd_be` process takes a long time to store the entries to cache. The cache writes are blocking, so when `sssd_be` writes to the cache, it might be considered stuck (more on the actual mechanism below) You can increase the heartbeat interval by raising the value of the `timeout` option.
    - NOTE: The underlying mechanism changed with upstream version 1.14. In 1.13 and older, the main `sssd` process was sending pings to the worker processes and was expecting pongs. If the target process failed to reply three times, it was killed. Starting with upstream version 1.14, the ping-pongs were removed in favor of in-process watchdog. This change has consequence for the admin in the sense that with the older versions, the most useful debug source was the `sssd.log` file, with more recent versions, it's the per-process log file. In both cases, raising the `timeout` value works.
  - For configuration with `id_provider=ldap` and `auth_provider=ldap`. retrieving user information works, but authentication does not
    - Please note that user authentication is typically retrieved over unencrypted channel (unless `ldap_id_use_start_tls` is enabled), but authentication always happens over an encrypted channel. Checking for certificate errors should be the first step. To test authentication manually, you can perform a base-search against the user entry together with ldapsearch's `-Z` option.

### Common IPA provider issues

  - In an IPA-AD trust setup, `getent group $groupname` doesn't display any group members of an AD group
  - In an IPA-AD trust setup, `id $username` doesn't display any groups for an AD user
    - This is expected with very old SSSD and FreeIPA versions. In order to display the group members for groups and groups for user, you need to have at least SSSD 1.12 on the client and FreeIPA server 4.1 or newer at the same time
  - In an IPA-AD trust setup, IPA users can be resolved, but AD trusted users can't
    - The IPA client machines query the SSSD instance on the IPA server for AD users. If the client logs contain errors such as:
        
            [ipa_s2n_exop_done] (0x0040): ldap_extended_operation result: Operations error(1), Failed to handle the request.
        
        or:
        
            [ipa_s2n_get_user_done] (0x0040): s2n exop request failed.
        
        Check if AD trusted users be resolved on the server at least. Enable debugging for the SSSD instance on the IPA server and take a look at SSSD logs there. Chances are the SSSD on the server is misconfigured or maybe not running at all - make sure that all the requests towards the NSS responder can be answered on the server.
  - In an IPA-AD trust setup, AD trust users cannot be resolved or secondary groups are missing on the IPA server
    - This can be caused by AD permissions issues if the below errors are seen in the logs:
        
            [sdap_ad_resolve_sids_done] (0x0020): Unable to resolve SID S-1-5-21-101891098-1139187330-4192773280-XXXXXX - will try next sid.
        
        Validate permissions on the AD object printed in the logs. This can checked by manually performing ldapsearch with the same LDAP filter and kerberos credentials that SSSD uses(one-way trust uses keytab in `/var/lib/sss/keytabs/` and two-way trust uses host principal in `/etc/krb5.keytab`).

### Common AD provider issues

  - How do I set up the AD provider?
    
    - There is a dedicated page about AD provider setup

  - Many users can't be displayed at all with ID mapping enabled and SSSD domain logs contain error message such as:
    
        [sdap_idmap_sid_to_unix] (0x0080): Could not convert objectSID [S-1-5-21-101891098-1139187330-4192773280-XXXXXX]
    
    If you are running an old (older than 1.13) version and XXXXXX is a number larger than 200000, then check the `ldap_idmap_range_size` option. You'll likely want to increase its value. Keep in mind the largest ID value on a POSIX system is 2^32.
    
    If you are running a more recent version, check that the `subdomains_provider` is set to `ad` (which is the default). Some users are setting the `subdomains_provider` to `none` to work around fail over issues, but this also causes the primary domain SID to be not read and therefore cannot map SIDs from the primary domain. Consider using the `ad_enabled_domains` option instead\!

  - The POSIX attributes disappear randomly after login
    
    - SSSD looks the user's group membership in the Global Catalog to make sure even the cross-domain memberships are taken into account. Chances are the POSIX attributes are not replicated to the Global Catalog. You can disable the Global catalog lookups by disabling the `ad_enable_gc` option, but you'll lose cross-domain memberships. Alternatively, modify the AD schema to replicate the POSIX attribute to the Global Catalog.

  - After selecting a custom `ldap_search_base`, the group membership no longer displays correctly.
    
    - If you use a non-standard LDAP search bases, please disable the TokenGroups performance enhancement by setting `ldap_use_tokengroups=False`. Otherwise, the AD provider would receive the group membership via a special call that is not restricted by the custom search base which causes unpredictable results
    - Typically, users configure a custom `ldap_search_base` to limit the groups the user is a member of. Please see [this blog post](https://jhrozek.wordpress.com/2016/12/09/restrict-the-set-of-groups-the-user-is-a-member-of-with-sssd/) for more information on the subject.

  - SSSD keeps connecting to a trusted domain that is not reachable and the whole daemon switches to offline mode as a result
    
    - SSSD would connect to the forest root in order to discover all subdomains in the forest in case the SSSD client is enrolled with a member of the forest, not the forest root. This is because only the forest root knows all the subdomains, the forest member only knows about itself and the forest root. Also, SSSD by default tries to resolve all groups the user is a member of, from all domains. In case the SSSD client is behind a firewall preventing connection to a trusted domain, can set the `ad_enabled_domains` option to selectively enable only the reachable domains.

  - SSSD keeps switching to offline mode with a `DEBUG` message saying `Service resolving timeout reached`
    
    - This might happen if the service resolution reaches the configured time out before SSSD is able to perform all the steps needed for service resolution in a complex AD forest, such as locating the site or cycling over unreachable DCs. Please check the `FAILOVER` section in the man pages Often, increasing the `dns_resolver_timeout` option helps to allow more time for the service discovery.

  - A group my user is a member of doesn't display in the `id` output
    
    - Cases like this are best debugged from an empty cache. Check if the group GID appears in the output of `id -G` first. In case the group is not present in the `id -G` output at all, there is something up with the initgroups part. Check the schema and look for anything strange during the initgr operation in SSSD back end logs. If the group is present in `id -G` output but not in `id` output (or a subsequent id output) then there's something wrong with resolving the group GIDs with `getgrgid()`.

### Troubleshooting Authentication, Password Change and Access Control

In order for authentication to be successful, the user information must be accurately provided first. Before debugging authentication, please make sure the user information is resolvable with `getent passwd $user` or `id $user`. Failing to retrieve the user info would also manifest in the secure logs or the journal with message such as:

    pam_sss(sshd:account): Access denied for user admin: 10 (User not known to the underlying authentication module)

Authentication happens from PAM's `auth` stack and corresponds to SSSD's `auth_provider`. Access control takes place in PAM `account` phase and is linked with SSSD's `access_provider`. And lastly, password changes go through the `password` stack on the PAM side to SSSD's `chpass_provider`.

If the user info can be retrieved, but authentication fails, the first place to look into is `/var/log/secure` or the system journal. Look for messages from `pam_sss`. Please note that not all authentication requests come through SSSD. Notably, SSH key authentication and GSSAPI SSH authentication happen directly in SSHD and SSSD is only contacted for the `account` phase.

### Troubleshooting general authentication problems

The PAM authentication flow follows this pattern:

1.  The PAM-aware application starts the PAM conversation. Depending on the PAM stack configuration, the `pam_sss` module would be contacted. To debug the authentication process, first check in the secure log or journal if `pam_sss` is called at all. If you don't see `pam_sss` mentioned, chances are your PAM stack is misconfigured. If you see `pam_sss` being contacted, enable debugging in pam responder logs
2.  SSSD's PAM responder receives the authentication request and in most cases forwards it to the back end. Please note that unlike identity requests, the authentication/access control is typically not cached and always contacts the server. This might manifest as a slowdown in some cases, but it's quite important, because the supplementary groups in GNU/Linux are only set during login time.
    - The PAM responder logs should show the request being received from the pam stack and then forwarded to the back end.
    
    - If you see the authentication request getting to the PAM responder, but receiving an error from the back end, check the back end logs. An example error output might look like:
        
            [sssd[pam]] [sss_dp_issue_request] (0x0400): Issuing request for [0x411d44:3:admin@ipa.example.com]
            [sssd[pam]] [sss_dp_get_account_msg] (0x0400): Creating request for [ipa.example.com][3][1][name=admin]
            [sssd[pam]] [sss_dp_internal_get_send] (0x0400): Entering request [0x411d44:3:admin@ipa.example.com]
            [sssd[pam]] [sss_dp_get_reply] (0x1000): Got reply from Data Provider - DP error code: 1 errno: 11 error message: Offline
            [sssd[pam]] [pam_check_user_dp_callback] (0x0040): Unable to get information from Data Provider Error: 1, 11, Offline

3.  The back end processes the request. This might include the equivalent of `kinit` done in the `krb5_child` process, an LDAP bind or consulting an access control list. After the back end request finishes, the result is sent back to the PAM responder.
    - For Kerberos-based (that includes the IPA and AD providers) `auth_provider`, look into the `krb5_child.log` file as well. Setting `debug_level` to 10 would also enable low-level Kerberos tracing information in that logfile. You can also simulate the authentication with `kinit`.
    
    - If the back end's `auth_provider` is LDAP-based, you can simulate the authentication by performing a base-scoped bind as the user who is logging in:
        
            ldapsearch -x -H ldap://master.ipa.example.com -b uid=admin,cn=users,cn=accounts,dc=ipa,dc=example,dc=com -s base -W

4.  The PAM responder receives the result and forwards it back to the `pam_sss` module. The error or status message is displayed in `/var/log/secure` or journal.

### Assorted common SSSD authentication problems

  - How do I enable LDAP authentication over an unsecure connection?
    - Not possible, sorry. SSSD requires the use of either TLS or LDAPS for LDAP authentication. Perimeter security is just not enough.
  - There are no messages from `pam_sss` at all
    - Your PAM stack is likely misconfigured. Use the `authconfig` tool if available together with `--enablesssdauth`.
    - Alternatively, check that the authentication you are using is PAM-aware, because some authentication methods, like SSH public keys are handled directly in the SSHD and do not use PAM at all.
  - I can `su` to an SSSD user from root, but not from a regular user, SSH doesn't work either
    - If you su to another user from root, you typically bypass SSSD authentication completely by using the `pam_rootok.so` module. Your SSSD setup is likely broken, please log in as an ordinary user and continue debugging in this section
  - I'm receiving `System Error (4)` in the authentication logs
    - System Error is an "Unhandled Exception" during authentication. It can either be an SSSD bug or a fatal error during authentication. Either way, please bring up your issue on the [sssd-users mailing list](https://lists.fedorahosted.org/admin/lists/sssd-users.lists.fedorahosted.org/)

  - I'm receiving `Access denied for user $user: 6 (Permission denied)`
    - Authentication went fine, but the user was denied access to the client machine. You can temporarily disable access control with setting `access_provider=permit` temporarily. Don't forget to reset the access provider to a stricter setting after finding out the root cause\!
    - If disabling access control doesn't help, the account might be locked on the server side. Check the SSSD domain logs to find out more.
  - I can't get my LDAP-based access control filter right for group access control using the memberOf attribute
    - The LDAP-based access control is really tricky to get right and doesn't typically handle nested groups well. Use the [simple access provider](https://jhrozek.fedorapeople.org/sssd/1.14.0/man/sssd-simple.5.html) instead.

### Common IPA provider issues

  - In an IPA-AD trust setup, IPA users can log in, but AD users can't
    - Unless you use a "legacy client" such as `nss_ldap`, then IPA users authenticate against the IPA server, but AD users authenticate against the AD servers directly. Therefore, you can test the authentication directly with `kinit`. Use `KRB5_TRACE` for extra tracing information.
  - HBAC rules keep denying access.
    - Use the `ipa hbactest` utility on the IPA server to see if the user is permitted access. The SSSD uses the same code as `ipa hbactest`
  - In an IPA-AD trust setup, a user from the AD domain only lists his AD group membership, not the IPA external groups
  - HBAC prevents access for a user from a trusted AD domain, where the HBAC rule is mapped to an IPA group via an AD group
    - Make sure the group scope of the AD group mapped to the rule is not domain-local. Domain-local groups can't cross the trust boundary and cannot be therefore used for HBAC rules.
    - Check the keytab on the IPA client and make sure that it only contains entries from the IPA domain. If the keytab contains an entry from the AD domain, the PAC code might pick this entry for an AD user and then the PAC would only contain the AD groups, because the PAC would then be verified with the help of the AD KDC which knows nothing about the IPA groups and removes them from the PAC
    - Check the PAC with the help of a [dedicated IPA wiki page](https://www.freeipa.org/page/Howto/Inspecting_the_PAC) If the PAC contains the group, but it is not displayed on the client, then the issue is on the client side. If the PAC doesn't display the group in the PAC, then the issue is on the IPA KDC side. This would at least enable you to ask better questions on the user support lists.
    - There was an irritating [SSSD bug](https://pagure.io/SSSD/sssd/issue/3382) that manifested as SSSD not listing some of the groups in the SSSD logs during the HBAC check. Make sure you are running an SSSD version that includes the fix.
