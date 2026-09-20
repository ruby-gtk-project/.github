import {
  to = github_issue_labels.workbench
  id = "workbench"
}

resource "github_issue_labels" "workbench" {
  repository = "workbench"
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
  to = github_repository_topics.workbench
  id = "workbench"
}

resource "github_repository_topics" "workbench" {
  repository = "workbench"
  topics     = []
}

import {
  to = github_workflow_repository_permissions.workbench
  id = "workbench"
}

resource "github_workflow_repository_permissions" "workbench" {
  can_approve_pull_request_reviews = true
  default_workflow_permissions     = "write"
  repository                       = "workbench"
}

import {
  to = github_repository_dependabot_security_updates.workbench
  id = "workbench"
}

resource "github_repository_dependabot_security_updates" "workbench" {
  enabled    = false
  repository = "workbench"
}

import {
  to = github_branch_default.workbench
  id = "workbench"
}

resource "github_branch_default" "workbench" {
  branch          = "ruby"
  etag            = "W/\"baf08feebaade87ea9935ed9e75d9ca83ebffe992fe8072469bddd0e6dfe63cc\""
  rename          = null
  repository      = "workbench"
  wait_for_rename = null
}

import {
  to = github_repository.workbench
  id = "workbench"
}

resource "github_repository" "workbench" {
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
  description                 = "Code playground for GNOME 🛠️"
  etag                        = "W/\"baf08feebaade87ea9935ed9e75d9ca83ebffe992fe8072469bddd0e6dfe63cc\""
  fork                        = "true"
  gitignore_template          = null
  has_discussions             = false
  has_issues                  = true
  has_projects                = true
  has_wiki                    = true
  homepage_url                = "https://apps.gnome.org/Workbench"
  is_template                 = false
  license_template            = null
  merge_commit_message        = "PR_TITLE"
  merge_commit_title          = "MERGE_MESSAGE"
  name                        = "workbench"
  source_owner                = "workbenchdev"
  source_repo                 = "Workbench"
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
  to = github_actions_repository_permissions.workbench
  id = "workbench"
}

resource "github_actions_repository_permissions" "workbench" {
  allowed_actions      = "all"
  enabled              = true
  repository           = "workbench"
  sha_pinning_required = false
}

import {
  to = github_repository_vulnerability_alerts.workbench
  id = "workbench"
}

resource "github_repository_vulnerability_alerts" "workbench" {
  enabled    = false
  repository = "workbench"
}

import {
  to = github_repository_collaborators.workbench
  id = "workbench"
}

resource "github_repository_collaborators" "workbench" {
  repository = "workbench"
}

