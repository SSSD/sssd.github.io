.. highlight:: none

Migrating from pam\_krb5 to sssd
================================

*pam\_krb5* was a Pluggable Authentication Module (PAM) for performing
user session authentication against Kerberos (specifically, krb5). Red
Hat formally announced its deprecation in the RHEL-7.4 release.

System Security Services Daemon (*sssd*) is a broader toolsuite for
managing authentication mechanisms and remote directories. It includes a
PAM module, pam\_sss, which can perform the tasks for which pam\_krb5
was previously used.

Architecturally, pam\_krb5 was a monolithic module which performed all
needed tasks within itself. sssd is set up differently: the module
pam\_sss calls out to the running sssd itself for most functionality.

Note: sssd does not currently handle the AFS capabilities of pam\_krb5.
If you would like such functionality, please contact Red Hat Support.

Core functionality
------------------

We will first show an example migration, and then provide detailed
information about specific options.

pam\_krb5 had both PAM configuration and a snippet in krb5.conf. The PAM
configuration would have looked similar to

::

    auth required /lib64/security/pam_krb5.so
    session optional /lib64/security/pam_krb5.so
    account sufficient /lib64/security/pam_krb5.so
    password sufficient /lib64/security/pam_krb5.so

and krb5.conf:

::

    [appdefaults]
        pam = {
            validate = true
            ccache_dir = /var/tmp
            TEST.EXAMPLE.COM = {
                debug = true
                keytab = FILE:/etc/krb5.keytab
            }
        }

The PAM configuration for sssd is very similar:

::

    auth required pam_sss.so
    session optional pam_sss.so
    account sufficient pam_sss.so
    password sufficient pam_sss.so

and in sssd.conf we would add:

::

    [sssd]
        services = nss, pam
        domains = TEST.EXAMPLE.COM

    [domain/TEST.EXAMPLE.COM]
        id_provider = files # set to ldap if LDAP is in use, etc.
        auth_provider = krb5
        krb5_realm = TEST.EXAMPLE.COM
        debug_level = 5
        krb5_validate = true
        krb5_ccachedir = /var/tmp # note that RHEL-7 default to KERNEL ccaches, which are preferred in most cases to FILE
        krb5_keytab = /etc/krb5.keytab

Detailed options (by type)
~~~~~~~~~~~~~~~~~~~~~~~~~~

Wholly deprecated (no replacement)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following pam\_krb5 options have no replacement due to only being
useful for AFS: **afs\_cells**, **external**, **ignore\_afs**,
**null\_afs**, **tokens**, **tokens\_strategy**.

Debugging
^^^^^^^^^

Debugging in pam\_krb5 was controlled by the **debug**,
**debug\_sensitive**, and **trace** options. The debugging of pam\_sss
is not configurable (everything is logged and can be filtered
appropriately). Debugging sssd itself is controlled by the
**debug\_level** parameter of sssd.conf, and can also be adjusted
dynamically using ``sss_debuglevel``. At higher levels, krb5 tracing is
enabled. Sensitive messages are not forwarded from the daemon to the PAM
application unless the value of **pam\_verbosity** is increased above
the default.

Prompting
^^^^^^^^^

pam\_krb5 used the options **banner**, **chpw\_prompt**, and **pwhelp**
to display custom messages to the user when prompting for input. There
is no direct replacement for these; however, an expiration messsage
(**pam\_account\_expired\_message**) and account lockout message
(**pam\_account\_locked\_message**) can be set. See documentation on
pam\_verbosity (in sssd.conf(5)) for more information on when these are
displayed.

pam\_krb's prompting options (**chpw\_prompt**, **initial\_prompt**,
**no\_initial\_prompt**, **subsequent\_prompt**,
**no\_subsequent\_prompt**, **use\_first\_pass**, **try\_first\_pass**,
and **use\_authtok**) are replaced by controls in pam\_sss. In
particular, **use\_authtok** and **use\_first\_pass** keep name and
functionality. The behavior coded by **try\_first\_pass** is the sssd
default. All other prompting is can be enabled by setting
**prompt\_always**. For more information, see pam\_sss(8).

Credential management
^^^^^^^^^^^^^^^^^^^^^

The pam\_krb5 **ccache\_dir**, **ccname\_template**, **keytab**, and
**validate** / **no\_validate** options map to the sssd.conf options
**krb5\_ccachedir**, **krb5\_ccname\_template**, **krb5\_keytab**, and
**krb5\_validate**, respectively. By default, validation is not enabled,
unless the Kerberos provider is IPA or Active Directory. See
sssd-krb5(5) for more information.

pam\_krb5's **validate\_user\_user**, **multiple\_ccaches**, and
**cred\_session** options have no sssd equivalent. Please contact Red
Hat Support if you would like such functionality.

Localauth / .k5login
^^^^^^^^^^^^^^^^^^^^

sssd and pam\_krb5 have different approaches here. In order to enable
.k5login-based access control, set **access\_provider** to krb5 in
sssd.conf. sssd also includes its own localauth plugin (which is
typically enabled using a configuration snippet in /etc/krb5.conf.d).
This replaces the **always\_allow\_localname** and \*\*ignore\_k5login\*
settings from pam\_krb5.

pam\_krb5's **mappings** rules are replaced by **krb5\_map\_user** rules
in sssd. Note that sssd does not support the use of regular expressions
for these rules. Since in both cases it is typically necessary to
configure **auth\_to\_local** in krb5.conf with the inverse, it is
recommended to keep these mappings simple.

sssd refuses to admit users that do not exist (i.e., that cannot be
resolved through its NSS interface). Therefore, the **no\_user\_check**
option from pam\_krb5 (previously marked as potentially dangerous) has
no sssd analogue.

Other
^^^^^

pam\_krb5's **ignore\_unknown\_principals**, **ignore\_unknown\_spn**,
and **ignore\_unknown\_upn** options are united as the pam\_sss
**ignore\_unknown\_user** option. However, as above, note that sssd will
not authenticate users that cannot be resolved. Additionally, for users
whose information cannot be obtained from LDAP (or who do not exist in
LDAP), sssd falls back to "username@REALM".

**minimum\_uid** is called **min\_id** in sssd.conf. Additionally,
sssd.conf allows **max\_id** to limit the maximum UID to check. Note
that this also affects NSS user resolution.

**preauth\_options** is superseded by the certmap rules; see
sss-certmap(5) for more information.

**armor** is superseded by sssd's **krb5\_use\_fast** option. The
**armor\_strategy** option has no direct equivalent in sssd; sssd's
behavior is comparable to that which would have been configured by
setting **armor\_strategy** to *keytab*.

**use\_shmem** does not apply to sssd due to architectural differences.

Tools
-----

pam\_krb5 also included four binaries. Three of them were useful only
for AFS-related work, and no replacement is provided: ``afs5log``,
``pagsh``, and ``pam_newpag``.

The fourth, ``pam_krb5_cchelper``, was intended as an internal tool for
pam\_krb5's use. sssd has its own internal management that is not
exposed to end users. ``pam_krb5_cchelper``'s functionality can be
replicated using ``kinit -c`` or ``kdestroy -c``, and calling ``chown``
and ``chgrp`` as needed.
