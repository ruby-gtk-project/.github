import {
  to = github_repository_collaborators.bustle_rb
  id = "bustle-rb"
}

resource "github_repository_collaborators" "bustle_rb" {
  repository = "bustle-rb"
}

import {
  to = github_workflow_repository_permissions.bustle_rb
  id = "bustle-rb"
}

resource "github_workflow_repository_permissions" "bustle_rb" {
  can_approve_pull_request_reviews = true
  default_workflow_permissions     = "write"
  repository                       = "bustle-rb"
}

import {
  to = github_branch_default.bustle_rb
  id = "bustle-rb"
}

resource "github_branch_default" "bustle_rb" {
  branch          = "ruby"
  etag            = "W/\"bee7c88752ebb2a1b7c19fdd6cdb19a464642e6a0915c470825d7e42cfd1381b\""
  rename          = null
  repository      = "bustle-rb"
  wait_for_rename = null
}

import {
  to = github_repository_topics.bustle_rb
  id = "bustle-rb"
}

resource "github_repository_topics" "bustle_rb" {
  repository = "bustle-rb"
  topics     = []
}

import {
  to = github_issue_labels.bustle_rb
  id = "bustle-rb"
}

resource "github_issue_labels" "bustle_rb" {
  repository = "bustle-rb"
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
  to = github_repository.bustle_rb
  id = "bustle-rb"
}

resource "github_repository" "bustle_rb" {
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
  description                 = "Someone's favourite D-Bus profiler (mirror)"
  etag                        = "W/\"bee7c88752ebb2a1b7c19fdd6cdb19a464642e6a0915c470825d7e42cfd1381b\""
  fork                        = "true"
  gitignore_template          = null
  has_discussions             = false
  has_issues                  = true
  has_projects                = true
  has_wiki                    = false
  homepage_url                = "https://gitlab.freedesktop.org/bustle/bustle"
  is_template                 = false
  license_template            = null
  merge_commit_message        = "PR_TITLE"
  merge_commit_title          = "MERGE_MESSAGE"
  name                        = "bustle-rb"
  source_owner                = "wjt"
  source_repo                 = "bustle"
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
  to = github_actions_repository_permissions.bustle_rb
  id = "bustle-rb"
}

resource "github_actions_repository_permissions" "bustle_rb" {
  allowed_actions      = "all"
  enabled              = true
  repository           = "bustle-rb"
  sha_pinning_required = false
}

import {
  to = github_repository_vulnerability_alerts.bustle_rb
  id = "bustle-rb"
}

resource "github_repository_vulnerability_alerts" "bustle_rb" {
  enabled    = false
  repository = "bustle-rb"
}

import {
  to = github_repository_dependabot_security_updates.bustle_rb
  id = "bustle-rb"
}

resource "github_repository_dependabot_security_updates" "bustle_rb" {
  enabled    = false
  repository = "bustle-rb"
}

