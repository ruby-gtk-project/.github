import {
  to = github_repository_dependabot_security_updates.workbench_rb
  id = "Workbench-rb"
}

resource "github_repository_dependabot_security_updates" "workbench_rb" {
  enabled    = false
  repository = "Workbench-rb"
}

import {
  to = github_repository.workbench_rb
  id = "Workbench-rb"
}

resource "github_repository" "workbench_rb" {
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
  etag                        = "W/\"6cdcf58f8179cbcc0188ee0a66a67e6dda3edbb33e5ad6926f927a403042b640\""
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
  name                        = "Workbench-rb"
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
  to = github_repository_collaborators.workbench_rb
  id = "Workbench-rb"
}

resource "github_repository_collaborators" "workbench_rb" {
  repository = "Workbench-rb"
}

import {
  to = github_branch_default.workbench_rb
  id = "Workbench-rb"
}

resource "github_branch_default" "workbench_rb" {
  branch          = "ruby"
  etag            = "W/\"6cdcf58f8179cbcc0188ee0a66a67e6dda3edbb33e5ad6926f927a403042b640\""
  rename          = null
  repository      = "Workbench-rb"
  wait_for_rename = null
}

import {
  to = github_repository_topics.workbench_rb
  id = "Workbench-rb"
}

resource "github_repository_topics" "workbench_rb" {
  repository = "Workbench-rb"
  topics     = []
}

import {
  to = github_workflow_repository_permissions.workbench_rb
  id = "Workbench-rb"
}

resource "github_workflow_repository_permissions" "workbench_rb" {
  can_approve_pull_request_reviews = true
  default_workflow_permissions     = "write"
  repository                       = "Workbench-rb"
}

import {
  to = github_issue_labels.workbench_rb
  id = "Workbench-rb"
}

resource "github_issue_labels" "workbench_rb" {
  repository = "Workbench-rb"
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
  to = github_actions_repository_permissions.workbench_rb
  id = "Workbench-rb"
}

resource "github_actions_repository_permissions" "workbench_rb" {
  allowed_actions      = "all"
  enabled              = true
  repository           = "Workbench-rb"
  sha_pinning_required = false
}

import {
  to = github_repository_vulnerability_alerts.workbench_rb
  id = "Workbench-rb"
}

resource "github_repository_vulnerability_alerts" "workbench_rb" {
  enabled    = false
  repository = "Workbench-rb"
}

