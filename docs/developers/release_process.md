# Release Process for SSSD

We will use SSSD 1.3.0 as an example. Substitute with the appropriate version where needed.

## Pre-requisites

  - Commit access to the SSSD upstream source and docs repositories
  - A GPG key signed by at least two other members of the SSSD team.
  - Maintainer privileges on the SSSD Zanata Instance. Follow the [zanata guide](http://docs.zanata.org/en/release/client/configuration/) to set up the zanata-cli tool
  - A fresh clone of the SSSD upstream repository to work from
  - Ensure that all tickets that were closed in this release are marked with the appropriate resolution.
  - Perform a scratch build on all supported architectures.

## Prepare the sources

1.  Ensure that you have the latest version of the upstream sources.

2.  Update the translation files.

3.  In the root of SSSD checkout, pull new translations from zanata with:
    
        zanata-cli pull -s . -t .

4.  If new translations have been added to the main translations (`po/*.po`), add the new language to `po/LINGUAS`. Please keep them in English alphabetical order.

5.  If new translations have been added to the manpage translations (`src/man/po/*.po`), add the new language to `src/man/po/po4a.cfg`. Please keep them in English alphabetical order.

6.  Run `autoreconf -if && ./configure && make update-po && make distcheck` from the root

7.  Check `git status` for changes to `*.po` or `*.pot` files.

8.  Commit the new `.po[t]` files.

9.  Push the changes.

### Special Beta or Pre-release rules

1.  For the benefit of translators, push any new strings up to Zanata whenever we make a pre-release tarball:
    
        zanata-cli push -s .

2.  If this is the last pre-release (e.g. final beta before bugfix-only phase) String Freeze should be announced on the sssd-devel list and the Zanata site.

## Tag and sign the release

1.  Tag the release and sign it with your GPG key:
    
        git tag -s sssd-1_3_0

2.  Push the tag. Push the tag explicitly instead of using `--tags` so that you do not push extraneous tags by mistake:
    
        git push origin sssd-1_3_0

### Special Beta or Pre-release rules

When tagging a beta or release candidate, the sources should be tagged twice. Once for the pure numeric value and once for the human-friendly value. So for example, if we are tagging SSSD 1.9.0 beta 2, we should do:

    git tag -s sssd-1_8_92
    git tag -s sssd-1_9_0_beta2

Followed by:

    git push --tags

## Generate HTML manpages

1.  Use the attached perl script to produce XHTML-formatted manpages:
    
        perl make-xhtml.pl /path/to/xml /path/to/output

2.  Upload these manpages to public space (for example, FedoraPeople space)

3.  Link to these files when creating the release page entry.

## Create a release tarball

1.  Run `scripts/release.sh` from the root directory of the source checkout. This will create two files, `sssd-1.3.0.tar.gz` and `sssd-1.3.0.tar.gz.asc`

2.  Create an md5sum and a sha1sum of the tarball:
    
        md5sum sssd-1.3.0.tar.gz sssd-1.3.0.tar.gz.md5sum
        sha1sum sssd-1.3.0.tar.gz sssd-1.3.0.tar.gz.sha1sum

### Special Beta or Pre-release rules

When creating a tarball for a beta or a release candidate, the resulting tarball should be renamed appropriately. To use the 1.9.0 beta 2 example:

    mv sssd-1.8.92.tar.gz sssd-1.9.0beta2.tar.gz
    mv sssd-1.8.92.tar.gz.asc sssd-1.9.0beta2.tar.gz.asc

## Prepare the branch for the next version

1.  Update the version in version.m4 to the next point release (e.g. 1.3.1)
    
    - Only update the version to a final release (like 1.9.0) right before releasing the final version. Bumping the version to final sooner would prevent us from being able to release another pre-release..

2.  Push this new version:
    
        git push

### Special-case: branching off master to track the next major version

1.  As an example, we will branch off `sssd-1-3` and let master track the development of sssd 1.4

2.  Create a stable branch from master:
    
        git checkout -b sssd-1-3
        git push -n origin sssd-1-3
        # verify everything looks sane
        git push origin sssd-1-3

3.  Switch back to the master branch

4.  On master, update the version in version.m4 to the next point release (e.g. `1.3.90`)

5.  Push this new version:
    
        git push -n origin master
        # verify everything looks sane
        git push origin master

## Upload the tarball to the [GitHub releases](https://github.com/SSSD/sssd/releases)

1.  Navigate the browser to <https://github.com/SSSD/sssd/releases>
2.  Click the Draft a new release button
3.  Upload both the source tarball (`.tar.gz`) and the GPG signature (`.tar.gz.asc`)

## Update the releases page

1.  Add a line at the top of the [Releases](../users/releases) with links to the tarball and the GPG signature

2.  Add the `md5sum` and `sha1sum` calculated above

3.  Create a release notes page (e.g. `users/releases/notes_1_3_0.rst`).

4.  Generate the detailed changelog:
    
        git shortlog previoustag..newtag

5.  For each release, if any changes have occurred in packaging (a new directory, a new provider plugin, etc.), the release notes page should include a section notifying potential packagers of these changes. In general, this can be determined by doing (from the root of the git checkout):
    
        git diff previoustag..newtag -- contrib/sssd.spec.in

6.  For each release, if any changes have occurred in documentation, such as new options, options changing default values, the release notes should include a section that summarizes there changes:
    
        git diff previoustag..newtag -- src/man

7.  Update the documentation with links to the latest manual pages and/or Deployment Guides

8.  Update the security sensitive options list if any new security-sensitive options were added

### Special-case: final release after multiple preview releases

When releasing a final version (such as 1.9.0) after multiple preview releases, the release notes page for that final release should contain all of the changes from the various preview release note pages. This way, potential packagers and users do not need to examine all of the prerelease notes.

## Close the released milestone and plan the next one

  - Actions to take in the Pagure repository settings
    1.  Make sure all tickets have been closed in the milestone so that it no longer appears in the roadmap
    2.  Create a new milestone for the next minor version (even if one isn't planned)
  - Add new ticket with the title 'Review and update SSSD's documentation for X.Y.Z release'.
    - An example of this ticket is <https://github.com/SSSD/sssd/issues/4031>

### Announce the release to the world\!

1.  Send an email to `sssd-devel@lists.fedorahosted.org`, `sssd-users@lists.fedorahosted.org`, `freeipa-users@lists.fedorahosted.org` and `freeipa-interest@redhat.com` announcing the availability of the new version.
2.  Announce the release on social networks
