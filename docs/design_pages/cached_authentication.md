# Authenticate against cache in SSSD

Related ticket(s):

  - <https://pagure.io/SSSD/sssd/issue/1807>

## Problem statement

SSSD should allow cache authentication instead of authenticating directly against network server every time. Authenticating against the network many times can cause excessive application latency.

## Use cases

In environments with tens of thousands of users login process may become inappropriately long, when servers are running under high workload (e.g. during classes, when many users log in simultaneously).

## Overview of the solution

Add new domain option `cached_auth_timeout` describing how long can be cached credentials used for cached authentication before online authentication must be performed. Update PAM responder functionality for forwarding requests to domain providers by checking if request can be served from cache and if so execute same code branch as for offline authentication instead of contacting the domain provider.

If password is locally changed (via SSSD client) SSSD should use online authentication for the next login attempt.

SSSD should immediately try an online login if the password doesn't match while processing cached authentication. It will allow a user to correctly login if the password was changed through another client. (It will also make the server failed authentication counter go up if it was a password guessing attempt and it would also made such attempts to pay the full round trip to the server, which helps deter local attacks even if we do not do any other checks like we do for real offline authentication.)

## Implementation details

  - extend structure *pam_auth_req*
    - add new field `use_cached_auth` (default value is false)
  - extend structure *sss_domain_info*
    - add new field `cached_auth_timeout` which will hold value of newly introduced domain option `cached_auth_timeout`
  - introduce new sysdb attribute `SYSDB_LAST_ONLINE_AUTH_WITH_CURRENT_TOKEN`
    - this attribute would mostly behave in the same way as `SYSDB_LAST_ONLINE_AUTH` but would be set to 0 when local password change happens
    - this would guarantee that after local password change, next login attempt won't be cached (if SSSD is in the online mode)
  - extend *pam_dom_forwarder()*
    - set local copy of `cached_auth_timeout` to use the smaller of the domain's `cached_auth_timeout` (given in seconds) and the `offline_credentials_expiration` (given in days, also must handle the special value 0 for offline_credentials_expiration)
    - do not forward request to a domain provider if
        - domain uses cached credentials *AND*
        - (local) `cached_auth_timeout` is greater than 0 *AND*
        - last online login (resp. attribute `SYSDB_LAST_ONLINE_AUTH_WITH_CURRENT_TOKEN`) of user who is being authenticated is not stale (\*now()* - (local) `cached_auth_timeout`) *AND*
        - PAM request can be handled from cache (PAM command is `SSS_PAM_AUTHENTICATE`)
            - then set `use_cached_auth` to true
            - call *pam_reply()*
  - extend *pam_reply()*
    - extend condition for entering into block processing case when pam_status is PAM_AUTHINFO_UNAVAIL even for `use_cached_auth` being true
    - while in this block and if PAM command is SSS_PAM_AUTHENTICATE then set `use_cached_auth` to false to avoid cyclic recursion call of *pam_reply()* which is subsequently called from *pam_handle_cached_login()*
  - extend *pam_handle_cached_login()*
    - if permission is denied and and cached authentication was used then return to *pam_dom_forwarder()* and perform online authentication
  - introduce function *sysdb_get_user_lastlogin_with_current_token()*
    - used to obtain value of attribute `SYSDB_LAST_ONLINE_AUTH_WITH_CURRENT_TOKEN` for given user from sysdb while deciding in pam_dom_forwarder() whether authentication can be served from cache or domain provider must be contacted (no output to console should happen here)
  - when password is being changed make sure that value of `SYSDB_LAST_ONLINE_AUTH_WITH_CURRENT_TOKEN` is set to 0

## Configuration changes

A new domain option `cached_auth_timeout` will be added. The value of this option is a time period in seconds for which cached authentication can be used. After this period is exceeded online authentication must be performed. The default value would be 0, which implies that this feature is by default disabled.

## How To Test

1.  set `cached_auth_timeout` in sssd.conf to some non-null value (e.g. 120)
2.  erase SSSD caches and restart SSSD
3.  test with correct password
    1.  log in as user from domain which stores credentials and then log out and log in again. The second login should use cached credentials. Output should by similar to this, especially note the line starting with: **Authenticated with cached credentials** (Please note that to see this console output *pam_verbosity = 2* must be set in pam section of sssd.conf.) :
        
            devel@dev $ su john
            Password:
            john@dev $ exit
            devel@dev $ su john
            Password:
            Authenticated with cached credentials, your cached password will expire at: Wed 22 Apr 2015 08:47:29 AM EDT.
            john@dev $
    
    2.  for the `cached_auth_timeout` seconds since the 1st login all subsequent login attempts (for the same user) should be served from cache and domain provider should not be contacted, this can be verified by changing password at server.
    
    3.  after passing more than `cached_auth_timeout` seconds since the 1st log in an online log in should be performed.
4.  test with wrong password to check if:
    1.  *offline_failed_login_attempts* is respected
    2.  *offline_failed_login_delay* is respected
5.  change locally password
    - verify that subsequent login attempt is processed online and that new password is accepted and old one is denied
6.  change password directly on server or via another client then SSSD
    - verify that new password is accepted and that logs inform that cached authentication failed and online authentication had to be performed (please note that old password would be accepted as SSSD client has no knowledge that it was changed)

## Authors

  - Pavel Reichl \<preichl@redhat.com\>
