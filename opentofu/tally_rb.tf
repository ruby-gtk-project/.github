import {
  to = github_actions_repository_permissions.tally_rb
  id = "tally-rb"
}

resource "github_actions_repository_permissions" "tally_rb" {
  allowed_actions      = "all"
  enabled              = true
  repository           = "tally-rb"
  sha_pinning_required = false
}

import {
  to = github_repository_vulnerability_alerts.tally_rb
  id = "tally-rb"
}

resource "github_repository_vulnerability_alerts" "tally_rb" {
  enabled    = false
  repository = "tally-rb"
}

import {
  to = github_repository_collaborators.tally_rb
  id = "tally-rb"
}

resource "github_repository_collaborators" "tally_rb" {
  repository = "tally-rb"
}

import {
  to = github_repository_topics.tally_rb
  id = "tally-rb"
}

resource "github_repository_topics" "tally_rb" {
  repository = "tally-rb"
  topics     = []
}

import {
  to = github_repository_dependabot_security_updates.tally_rb
  id = "tally-rb"
}

resource "github_repository_dependabot_security_updates" "tally_rb" {
  enabled    = false
  repository = "tally-rb"
}

import {
  to = github_branch_default.tally_rb
  id = "tally-rb"
}

resource "github_branch_default" "tally_rb" {
  branch          = "ruby"
  etag            = "W/\"d7df963805ecd29e5b69bf016820e8ba169c88c0c0ab654df0963304c0c59b88\""
  rename          = null
  repository      = "tally-rb"
  wait_for_rename = null
}

import {
  to = github_workflow_repository_permissions.tally_rb
  id = "tally-rb"
}

resource "github_workflow_repository_permissions" "tally_rb" {
  can_approve_pull_request_reviews = true
  default_workflow_permissions     = "write"
  repository                       = "tally-rb"
}

import {
  to = github_repository.tally_rb
  id = "tally-rb"
}

resource "github_repository" "tally_rb" {
  allow_auto_merge            = false
  allow_forking               = true
  allow_merge_commit          = true
  allow_rebase_merge          = true
  allow_squash_merge          = true
  allow_update_branch         = false
  archive_on_destroy          = null
  archived                    = false
  auto_init                   = false
  delete_branch_on_merge      = false
  description                 = "Counter for GNOME"
  etag                        = "W/\"d7df963805ecd29e5b69bf016820e8ba169c88c0c0ab654df0963304c0c59b88\""
  fork                        = "true"
  gitignore_template          = null
  has_discussions             = false
  has_issues                  = true
  has_projects                = true
  has_wiki                    = true
  homepage_url                = ""
  is_template                 = false
  license_template            = null
  merge_commit_message        = "PR_TITLE"
  merge_commit_title          = "MERGE_MESSAGE"
  name                        = "tally-rb"
  source_owner                = "vtrlx"
  source_repo                 = "tally"
  squash_merge_commit_message = "COMMIT_MESSAGES"
  squash_merge_commit_title   = "COMMIT_OR_PR_TITLE"
  topics                      = []
  visibility                  = "public"
  web_commit_signoff_required = false
  security_and_analysis {
    secret_scanning {
      status = "disabled"
    }
    secret_scanning_push_protection {
      status = "disabled"
    }
  }
}

import {
  to = github_issue_labels.tally_rb
  id = "tally-rb"
}

resource "github_issue_labels" "tally_rb" {
  repository = "tally-rb"
  label {
    color       = "0075ca"
    description = "Improvements or additions to documentation"
    name        = "documentation"
  }
  label {
    color       = "008672"
    description = "Extra attention is needed"
    name        = "help wanted"
  }
  label {
    color       = "7057ff"
    description = "Good for newcomers"
    name        = "good first issue"
  }
  label {
    color       = "a2eeef"
    description = "New feature or request"
    name        = "enhancement"
  }
  label {
    color       = "cfd3d7"
    description = "This issue or pull request already exists"
    name        = "duplicate"
  }
  label {
    color       = "d73a4a"
    description = "Something isn't working"
    name        = "bug"
  }
  label {
    color       = "d876e3"
    description = "Further information is requested"
    name        = "question"
  }
  label {
    color       = "e4e669"
    description = "This doesn't seem right"
    name        = "invalid"
  }
  label {
    color       = "ffffff"
    description = "This will not be worked on"
    name        = "wontfix"
  }
}

