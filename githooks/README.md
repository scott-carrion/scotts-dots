# githooks

## About

This repo contains various helpful git hooks that can help hasten development under the FNC/1FINITY IP Repo workflow.

### Hooks

* ``prepare-commit-msg``: Pre-fills commit message with Jira ID, derived from current branch. Expects branch name to be of the form ``<something>/PROJECTKEY-<digits>-optional-description``

### Configuration via ENV var

* ``${TICKETHOOK_JIRA_ID}``: If set and non-null, its value will be used as the Jira ID
* ``${TICKETHOOK_FAIL_IF_DNE}``: If set to ``true``, hook exits with failure if a Jira ID was not identified, aborting the commit

### Install

``make install``

This installs the hooks to the path ``~/githooks`` and updates your global git config to use them.

### Uninstall

``make uninstall``

Removes installed git hooks and removes global git config
