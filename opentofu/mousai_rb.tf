import {
  to = github_actions_repository_permissions.mousai_rb
  id = "Mousai-rb"
}

resource "github_actions_repository_permissions" "mousai_rb" {
  allowed_actions      = "all"
  enabled              = true
  repository           = "Mousai-rb"
  sha_pinning_required = false
}

import {
  to = github_repository_dependabot_security_updates.mousai_rb
  id = "Mousai-rb"
}

resource "github_repository_dependabot_security_updates" "mousai_rb" {
  enabled    = false
  repository = "Mousai-rb"
}

import {
  to = github_issue_labels.mousai_rb
  id = "Mousai-rb"
}

resource "github_issue_labels" "mousai_rb" {
  repository = "Mousai-rb"
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
  to = github_branch_default.mousai_rb
  id = "Mousai-rb"
}

resource "github_branch_default" "mousai_rb" {
  branch          = "ruby"
  etag            = "W/\"e1f470930bdc3dc262a87c69c5ceb31641e78a599e6293bf306ddbe2bc026f6a\""
  rename          = null
  repository      = "Mousai-rb"
  wait_for_rename = null
}

import {
  to = github_repository.mousai_rb
  id = "Mousai-rb"
}

resource "github_repository" "mousai_rb" {
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
  description                 = "Identify songs in seconds"
  etag                        = "W/\"e1f470930bdc3dc262a87c69c5ceb31641e78a599e6293bf306ddbe2bc026f6a\""
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
  name                        = "Mousai-rb"
  source_owner                = "SeaDve"
  source_repo                 = "Mousai"
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
  to = github_repository_collaborators.mousai_rb
  id = "Mousai-rb"
}

resource "github_repository_collaborators" "mousai_rb" {
  repository = "Mousai-rb"
}

import {
  to = github_workflow_repository_permissions.mousai_rb
  id = "Mousai-rb"
}

resource "github_workflow_repository_permissions" "mousai_rb" {
  can_approve_pull_request_reviews = true
  default_workflow_permissions     = "write"
  repository                       = "Mousai-rb"
}

import {
  to = github_repository_topics.mousai_rb
  id = "Mousai-rb"
}

resource "github_repository_topics" "mousai_rb" {
  repository = "Mousai-rb"
  topics     = []
}

import {
  to = github_repository_vulnerability_alerts.mousai_rb
  id = "Mousai-rb"
}

resource "github_repository_vulnerability_alerts" "mousai_rb" {
  enabled    = false
  repository = "Mousai-rb"
}

