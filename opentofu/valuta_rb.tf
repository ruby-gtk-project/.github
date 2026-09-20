import {
  to = github_repository_vulnerability_alerts.valuta_rb
  id = "valuta-rb"
}

resource "github_repository_vulnerability_alerts" "valuta_rb" {
  enabled    = false
  repository = "valuta-rb"
}

import {
  to = github_branch_default.valuta_rb
  id = "valuta-rb"
}

resource "github_branch_default" "valuta_rb" {
  branch          = "ruby"
  etag            = "W/\"d93cbcf6db7392500669569c0b74285dd70316a777eb184641ee24a87ded33f8\""
  rename          = null
  repository      = "valuta-rb"
  wait_for_rename = null
}

import {
  to = github_workflow_repository_permissions.valuta_rb
  id = "valuta-rb"
}

resource "github_workflow_repository_permissions" "valuta_rb" {
  can_approve_pull_request_reviews = true
  default_workflow_permissions     = "write"
  repository                       = "valuta-rb"
}

import {
  to = github_repository_collaborators.valuta_rb
  id = "valuta-rb"
}

resource "github_repository_collaborators" "valuta_rb" {
  repository = "valuta-rb"
}

import {
  to = github_issue_labels.valuta_rb
  id = "valuta-rb"
}

resource "github_issue_labels" "valuta_rb" {
  repository = "valuta-rb"
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
  to = github_actions_repository_permissions.valuta_rb
  id = "valuta-rb"
}

resource "github_actions_repository_permissions" "valuta_rb" {
  allowed_actions      = "all"
  enabled              = true
  repository           = "valuta-rb"
  sha_pinning_required = false
}

import {
  to = github_repository_topics.valuta_rb
  id = "valuta-rb"
}

resource "github_repository_topics" "valuta_rb" {
  repository = "valuta-rb"
  topics     = []
}

import {
  to = github_repository_dependabot_security_updates.valuta_rb
  id = "valuta-rb"
}

resource "github_repository_dependabot_security_updates" "valuta_rb" {
  enabled    = false
  repository = "valuta-rb"
}

import {
  to = github_repository.valuta_rb
  id = "valuta-rb"
}

resource "github_repository" "valuta_rb" {
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
  description                 = "This is a simple application for converting currencies, with support for various APIs."
  etag                        = "W/\"5d47e6fef627620c176bda366bcd337df9b47d3256cbca6588a83133ebc89073\""
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
  name                        = "valuta-rb"
  source_owner                = "ideveCore"
  source_repo                 = "Valuta"
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

