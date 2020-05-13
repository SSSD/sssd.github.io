Release Process for SSSD
========================

We will use SSSD 1.3.0 as an example. Substitute with the appropriate version where needed.

Pre-requisites
--------------
 * Commit access to the SSSD upstream source and docs repositories
 * A GPG key signed by at least two other members of the SSSD team.
 * Maintainer privileges on the SSSD Zanata Instance. Follow the `zanata guide <http://docs.zanata.org/en/release/client/configuration/>`_  to set up the zanata-cli tool
 * A fresh clone of the SSSD upstream repository to work from
 * Ensure that all tickets that were closed in this release are marked with the appropriate resolution.
 * Perform a scratch build on all supported architectures.

Prepare the sources
-------------------
 #. Ensure that you have the latest version of the upstream sources.
 #. Update the translation files.
 #. In the root of SSSD checkout, pull new translations from zanata with::

        zanata-cli pull -s . -t .

 #. If new translations have been added to the main translations (``po/*.po``), add the new language to ``po/LINGUAS``. Please keep them in English alphabetical order.
 #. If new translations have been added to the manpage translations (``src/man/po/*.po``), add the new language to ``src/man/po/po4a.cfg``. Please keep them in English alphabetical order.
 #. Run ``autoreconf -if && ./configure && make update-po && make distcheck`` from the root
 #. Check ``git status`` for changes to ``*.po`` or ``*.pot`` files.
 #. Commit the new ``.po[t]`` files.
 #. Push the changes.

Special Beta or Pre-release rules
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 #. For the benefit of translators, push any new strings up to Zanata whenever we make a pre-release tarball::

       zanata-cli push -s .

 #. If this is the last pre-release (e.g. final beta before bugfix-only phase) String Freeze should be announced on the sssd-devel list and the Zanata site.

Tag and sign the release
------------------------

 #. Tag the release and sign it with your GPG key::

       git tag -s sssd-1_3_0

 #. Push the tag. Push the tag explicitly instead of using ``--tags`` so that you do not push extraneous tags by mistake::

       git push origin sssd-1_3_0

Special Beta or Pre-release rules
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
When tagging a beta or release candidate, the sources should be tagged
twice. Once for the pure numeric value and once for the human-friendly
value. So for example, if we are tagging SSSD 1.9.0 beta 2, we should do::

       git tag -s sssd-1_8_92
       git tag -s sssd-1_9_0_beta2

Followed by::

       git push --tags

Generate HTML manpages
----------------------

 #. Use the attached perl script to produce XHTML-formatted manpages::

       perl make-xhtml.pl /path/to/xml /path/to/output

 #. Upload these manpages to public space (for example, FedoraPeople space)
 #. Link to these files when creating the release page entry.

Create a release tarball
------------------------

 #. Run ``scripts/release.sh`` from the root directory of the source
    checkout. This will create two files, ``sssd-1.3.0.tar.gz`` and
    ``sssd-1.3.0.tar.gz.asc``

 #. Create an md5sum and a sha1sum of the tarball::

       md5sum sssd-1.3.0.tar.gz > sssd-1.3.0.tar.gz.md5sum
       sha1sum sssd-1.3.0.tar.gz > sssd-1.3.0.tar.gz.sha1sum

Special Beta or Pre-release rules
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
When creating a tarball for a beta or a release candidate, the resulting
tarball should be renamed appropriately. To use the 1.9.0 beta 2 example::

       mv sssd-1.8.92.tar.gz sssd-1.9.0beta2.tar.gz
       mv sssd-1.8.92.tar.gz.asc sssd-1.9.0beta2.tar.gz.asc

Prepare the branch for the next version
---------------------------------------

 #. Update the version in version.m4 to the next point release (e.g. 1.3.1)

    * Only update the version to a final release (like 1.9.0) right before releasing the final version. Bumping the version to final sooner would prevent us from being able to release another pre-release..

 #. Push this new version::

       git push


Special-case: branching off master to track the next major version
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

 #. As an example, we will branch off ``sssd-1-3`` and let master track the development of sssd 1.4
 #. Create a stable branch from master::

       git checkout -b sssd-1-3
       git push -n origin sssd-1-3
       # verify everything looks sane
       git push origin sssd-1-3

 #. Switch back to the master branch
 #. On master, update the version in version.m4 to the next point release (e.g. ``1.3.90``)
 #. Push this new version::

       git push -n origin master
       # verify everything looks sane
       git push origin master

Upload the tarball to the `pagure releases section <https://pagure.io/SSSD/sssd/releases>`_
-------------------------------------------------------------------------------------------

 #. Navigate the browser to `<https://pagure.io/SSSD/sssd/releases>`_
 #. Click the `Upload a new release` button
 #. Upload both the source tarball (``.tar.gz``) and the GPG signature (``.tar.gz.asc``)

Update the releases page
------------------------

 #. Add a line at the top of the :doc:`Releases <../users/releases>` page with links to the tarball and the GPG signature
 #. Add the ``md5sum`` and ``sha1sum`` calculated above
 #. Create a release notes page (e.g. ``users/releases/notes_1_3_0.rst``).
 #. Generate the detailed changelog::

       git shortlog previoustag..newtag

 #. For each release, if any changes have occurred in packaging (a new directory, a new provider plugin, etc.), the release notes page should include a section notifying potential packagers of these changes. In general, this can be determined by doing (from the root of the git checkout)::

       git diff previoustag..newtag -- contrib/sssd.spec.in

 #. For each release, if any changes have occurred in documentation, such as new options, options changing default values, the release notes should include a section that summarizes there changes::

       git diff previoustag..newtag -- src/man

 #. Update the documentation with links to the latest manual pages and/or Deployment Guides
 #. Update the security sensitive options list if any new security-sensitive options were added

Special-case: final release after multiple preview releases
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
When releasing a final version (such as 1.9.0) after multiple preview
releases, the release notes page for that final release should contain all of
the changes from the various preview release note pages. This way, potential
packagers and users do not need to examine all of the prerelease notes.


Close the released milestone and plan the next one
--------------------------------------------------

 * Actions to take in the Pagure repository settings

   #. Make sure all tickets have been closed in the milestone so that it no longer appears in the roadmap
   #. Create a new milestone for the next minor version (even if one isn't planned)

 * Add new ticket with the title 'Review and update SSSD's documentation for X.Y.Z release'.

   * An example of this ticket is `<https://pagure.io/SSSD/sssd/issue/2990>`_

Announce the release to the world!
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

 #. Send an email to ``sssd-devel@lists.fedorahosted.org``, ``sssd-users@lists.fedorahosted.org``, ``freeipa-users@lists.fedorahosted.org`` and ``freeipa-interest@redhat.com`` announcing the availability of the new version.
 #. Announce the release on social networks
