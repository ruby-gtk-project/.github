import {
  to = github_repository_vulnerability_alerts.extension_manager_rb
  id = "Extension-Manager-rb"
}

resource "github_repository_vulnerability_alerts" "extension_manager_rb" {
  enabled    = false
  repository = "Extension-Manager-rb"
}

import {
  to = github_repository_dependabot_security_updates.extension_manager_rb
  id = "Extension-Manager-rb"
}

resource "github_repository_dependabot_security_updates" "extension_manager_rb" {
  enabled    = false
  repository = "Extension-Manager-rb"
}

import {
  to = github_repository_topics.extension_manager_rb
  id = "Extension-Manager-rb"
}

resource "github_repository_topics" "extension_manager_rb" {
  repository = "Extension-Manager-rb"
  topics     = []
}

import {
  to = github_workflow_repository_permissions.extension_manager_rb
  id = "Extension-Manager-rb"
}

resource "github_workflow_repository_permissions" "extension_manager_rb" {
  can_approve_pull_request_reviews = true
  default_workflow_permissions     = "write"
  repository                       = "Extension-Manager-rb"
}

import {
  to = github_repository_collaborators.extension_manager_rb
  id = "Extension-Manager-rb"
}

resource "github_repository_collaborators" "extension_manager_rb" {
  repository = "Extension-Manager-rb"
}

import {
  to = github_issue_labels.extension_manager_rb
  id = "Extension-Manager-rb"
}

resource "github_issue_labels" "extension_manager_rb" {
  repository = "Extension-Manager-rb"
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
  to = github_actions_repository_permissions.extension_manager_rb
  id = "Extension-Manager-rb"
}

resource "github_actions_repository_permissions" "extension_manager_rb" {
  allowed_actions      = "all"
  enabled              = true
  repository           = "Extension-Manager-rb"
  sha_pinning_required = false
}

import {
  to = github_branch_default.extension_manager_rb
  id = "Extension-Manager-rb"
}

resource "github_branch_default" "extension_manager_rb" {
  branch          = "ruby"
  etag            = "W/\"ce4456ef923451b833b1cbe5eec9bfba561e93cb2d95b3383c56e30bc5148ba1\""
  rename          = null
  repository      = "Extension-Manager-rb"
  wait_for_rename = null
}

import {
  to = github_repository.extension_manager_rb
  id = "Extension-Manager-rb"
}

resource "github_repository" "extension_manager_rb" {
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
  description                 = "A utility for browsing and installing GNOME Shell Extensions."
  etag                        = "W/\"ce4456ef923451b833b1cbe5eec9bfba561e93cb2d95b3383c56e30bc5148ba1\""
  fork                        = "true"
  gitignore_template          = null
  has_discussions             = false
  has_issues                  = false
  has_projects                = true
  has_wiki                    = true
  homepage_url                = "https://mattjakeman.com/apps/extension-manager"
  is_template                 = false
  license_template            = null
  merge_commit_message        = "PR_TITLE"
  merge_commit_title          = "MERGE_MESSAGE"
  name                        = "Extension-Manager-rb"
  source_owner                = "mjakeman"
  source_repo                 = "extension-manager"
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

