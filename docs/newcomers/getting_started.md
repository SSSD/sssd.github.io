# Getting started with SSSD

This document is a step-by-step guide for "How to make your first contribution to SSSD project".

## Setting up an environment for development

There are several ways to do so, but the one recommended by the author of this document is by simply using the <https://github.com/SSSD/sssd-test-suite> project.

Just check out the project's documentation on their github.

## GitHub workflow

For general information about SSSD hosting see the paragraph [Source Code Repository](https://docs.pagure.org/SSSD.sssd/developers/contribute.html#source-code-repository). It covers using SSSD's Pagure repository.

This section assumes you use GitHub.

At first some general information. All pull request activity generates an e-mail notification to the [sssd-devel](https://docs.pagure.org/SSSD.sssd/developers/contribute.html#contribute) mailing list so that we keep the development history outside GitHub.

These are the steps to contribute to SSSD:

At first fork our GitHub repository. In order to do so, go to the [SSSD GitHub page](https://github.com/SSSD/sssd), log in with your GitHub account and click on the `Fork` button. It will create a fork in your own GitHub account. Once it's done ...

  - Clone your own SSSD fork: `$ git clone git@github.com:<your_username>/sssd.git`
  - Add SSSD's GitHub repo as a remote repo: `$ git remote add github https://github.com/SSSD/sssd`

Using `https://` will ensure you don't push to SSSD's GitHub repo by mistake. Once those two steps are done, you're good to go and start hacking on your task. We strongly recommend to do that in local branches\!

  - Create your local branch: `$ git checkout -b wip/meaningful_name`

Considering you have built SSSD following the instructions provided in our [Contribute page](https://docs.pagure.org/SSSD.sssd/developers/contribute.html), have made your changes following our [Coding guidelines](https://docs.pagure.org/SSSD.sssd/developers/coding_style.html), have committed your changes following our [git-commit-template](https://github.com/SSSD/sssd/blob/master/.git-commit-template), and have implemented some unit/integration tests to ensure we're never hit by this very same issue again in the future ... now is time to open your pull-request.

The way the author of this document does is:

  - Push the changes to *your* SSSD repo: `$ git push origin wip/meaningful_name`
  - Open the Pull Request either:
    - by using GitHub's web UI on your GitHub page, or
    - by using the [hub](https://github.com/github/hub) tool: `$ hub pull-request`

Here, I'd like to add some really basic etiquette rules for opening the pull-request:

  - The description of your pull-request *must* be meaningful;
  - The message of your pull-request *must* briefly describe the reason behind this pull-request;
  - The message of your pull-request *should* contain the steps to reproduce the issue you're fixing and/or to reproduce the feature you're implementing.

Click on **[Create pull request]**. Now your pull-request has been created and will be reviewed by one of the core SSSD developers.

Please, keep in mind that the developers may also be quite busy with their day-to-day job and it may take some time till someone actually reviews your pull-request. Sending a "ping"/"bump" is totally fine, but only after a week or so (in other words, not immediately after the pull-request has been created).

Once your code is reviewed, a few different things may happen:

  - Your patch is "Accepted": it means the patch is good enough to be merged to SSSD's repo without any changes.
  - Changes are requested: it means that something has to be changed in your patch before it gets merged to SSSD's repo. In this case, you'd like to:
    - Carefully read and understand the changes required by the reviewer;
        - In case you did *not* understand the required changes, comment in the pull-request asking your doubts till you have everything crystal clear in your mind. Don't be afraid to do that, the core developers are around to help\! :-)
            - Please, do *not* privately ping the developers for all your doubts. Discussing in the pull-request is a better and more transparent way to do so *and* also doesn't interrupt the developer from any other task they are doing.
    - Make the changes in your patches;
    - Squash the changes to the original patches;
    - Rebase your work on top of SSSD's git master: `$ git rebase github/master`
        - Please, do *not* merge the branches\!
    - Update the pull-request with the new patchset: `$ git push -f origin wip/meaningful_name`
    - Leave a message in GitHub mentioning that your patchset has been updated.
  - Your patch is rejected: it means that your patch was rejected and the reason for this will be explained in the pull-request.
    - In case you do *not* agree with the reviewer, please, feel free to add another core developer to the discussion. Usually democracy wins\! :-)

### Notes for Maintainers

#### Reviewing pull requests

The list of open pull requests can be found at <https://github.com/SSSD/sssd/pulls>.

Any GitHub user can comment on the code:

  - either add a comment to the text field, or
  - click on the individual commit links and add comments inline to the diff.

Only collaborators can self-assign a pull requests and add labels. If you would like to be added as a collaborator, please send an e-mail to [sssd-devel](https://docs.pagure.org/SSSD.sssd/developers/contribute.html#contribute) and ask to be added.

If you want to formally review a pull request, please assign the pull request to yourself. This indicates that you'll be working with the submitter on pushing their pull requests upstream. You don't need to assign the pull request if you just want to add a one-time comment. The pull-request assignee(s) will be added as `Reviewed-By` tags when pushing to the Pagure repository.

If there is an issue in the code that you feel warrants a patch respin, add the `changes requested` label to the pull request.

Once you agree with the pull request, add the `accepted` label to the pull request. One of the gatekeepers will then push the pull request to the sssd repository manually.

If a pull-request is submitted by someone from outside the core team, the CI tests won't run to make sure some potentially malicious code is not ran on the CI nodes. To allow the code to be tested, one of the core developers must add: :

    ok to test

as a comment to the pull request. An example of one such pull request can be found [here](https://github.com/SSSD/sssd/pull/35).

**Pro-tips:**

  - Pressing `l` on the request allows to set labels without reaching for the mouse. You can also set assignee by pressing `a`.

  - You can add pull requests as refs and check them out as branches locally. To do that, add another `fetch` directive to your GitHub remote definition using `$ git config`. :
    
        GITHUB_REMOTE="github"
        git config --add remote.${GITHUB_REMOTE}.fetch "+refs/pull/*/head:refs/remotes/${GITHUB_REMOTE}/pull/*"
    
    Then you can fetch and checkout the pull requests with: :
    
        git fetch github
        git checkout -b pr7review --track github/pull/7

#### Pushing a pull request

Only pull requests with an `accepted` label can be pushed.

To push a patch, first apply it, for example: :

    hub am https://github.com/SSSD/sssd/pull/5

Don't forget to add the `Reviewed-By` tags, based on the pull request assignee. It's recommended to use the pre-push hook from `contrib/git/pre-push` that rejects any pushes without a `Reviewed-By` tag.

Then check again what patches would be pushed: :

    git push -n github master

And if the hashes look OK, finally push the patches: :

    git push github master

Finally, add the commit hashes to the pull request page, add the label `pushed` and close the pull request.

## Notes

As mentioned in the beginning, there are several different ways to contribute and you may need to find the one that fits better for yourself.

In case you spot something wrong in this page, please, open an issue and/or a pull-request to our [sssd-docs repo](https://pagure.io/SSSD/docs).
