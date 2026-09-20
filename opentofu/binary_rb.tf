import {
  to = github_repository_vulnerability_alerts.binary_rb
  id = "binary-rb"
}

resource "github_repository_vulnerability_alerts" "binary_rb" {
  enabled    = false
  repository = "binary-rb"
}

import {
  to = github_issue_labels.binary_rb
  id = "binary-rb"
}

resource "github_issue_labels" "binary_rb" {
  repository = "binary-rb"
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

import {
  to = github_branch_default.binary_rb
  id = "binary-rb"
}

resource "github_branch_default" "binary_rb" {
  branch          = "ruby"
  etag            = "W/\"c0689a47a018518c537ff1b098da1b73b4353fc86659840cc740642c9725fd9b\""
  rename          = null
  repository      = "binary-rb"
  wait_for_rename = null
}

import {
  to = github_repository.binary_rb
  id = "binary-rb"
}

resource "github_repository" "binary_rb" {
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
  description                 = "Small and simple app to convert numbers to a different base."
  etag                        = "W/\"c0689a47a018518c537ff1b098da1b73b4353fc86659840cc740642c9725fd9b\""
  fork                        = "true"
  gitignore_template          = null
  has_discussions             = false
  has_issues                  = true
  has_projects                = true
  has_wiki                    = false
  homepage_url                = "https://apps.gnome.org/Binary"
  is_template                 = false
  license_template            = null
  merge_commit_message        = "PR_TITLE"
  merge_commit_title          = "MERGE_MESSAGE"
  name                        = "binary-rb"
  source_owner                = "fizzyizzy05"
  source_repo                 = "binary"
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
  to = github_repository_dependabot_security_updates.binary_rb
  id = "binary-rb"
}

resource "github_repository_dependabot_security_updates" "binary_rb" {
  enabled    = false
  repository = "binary-rb"
}

import {
  to = github_repository_collaborators.binary_rb
  id = "binary-rb"
}

resource "github_repository_collaborators" "binary_rb" {
  repository = "binary-rb"
}

import {
  to = github_workflow_repository_permissions.binary_rb
  id = "binary-rb"
}

resource "github_workflow_repository_permissions" "binary_rb" {
  can_approve_pull_request_reviews = true
  default_workflow_permissions     = "write"
  repository                       = "binary-rb"
}

import {
  to = github_repository_topics.binary_rb
  id = "binary-rb"
}

resource "github_repository_topics" "binary_rb" {
  repository = "binary-rb"
  topics     = []
}

import {
  to = github_actions_repository_permissions.binary_rb
  id = "binary-rb"
}

resource "github_actions_repository_permissions" "binary_rb" {
  allowed_actions      = "all"
  enabled              = true
  repository           = "binary-rb"
  sha_pinning_required = false
}

