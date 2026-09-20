import {
  to = github_repository.raider_rb
  id = "raider-rb"
}

resource "github_repository" "raider_rb" {
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
  description                 = "Permanently delete your files"
  etag                        = "W/\"90ad0413c85d6dc15f55f898a812f77b202754d9e19150bec11d43d365781aa7\""
  fork                        = "true"
  gitignore_template          = null
  has_discussions             = false
  has_issues                  = true
  has_projects                = true
  has_wiki                    = false
  homepage_url                = "https://apps.gnome.org/Raider/"
  is_template                 = false
  license_template            = null
  merge_commit_message        = "PR_TITLE"
  merge_commit_title          = "MERGE_MESSAGE"
  name                        = "raider-rb"
  source_owner                = "ADBeveridge"
  source_repo                 = "raider"
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
  to = github_repository_vulnerability_alerts.raider_rb
  id = "raider-rb"
}

resource "github_repository_vulnerability_alerts" "raider_rb" {
  enabled    = false
  repository = "raider-rb"
}

import {
  to = github_repository_topics.raider_rb
  id = "raider-rb"
}

resource "github_repository_topics" "raider_rb" {
  repository = "raider-rb"
  topics     = []
}

import {
  to = github_repository_collaborators.raider_rb
  id = "raider-rb"
}

resource "github_repository_collaborators" "raider_rb" {
  repository = "raider-rb"
}

import {
  to = github_issue_labels.raider_rb
  id = "raider-rb"
}

resource "github_issue_labels" "raider_rb" {
  repository = "raider-rb"
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
  to = github_actions_repository_permissions.raider_rb
  id = "raider-rb"
}

resource "github_actions_repository_permissions" "raider_rb" {
  allowed_actions      = "all"
  enabled              = true
  repository           = "raider-rb"
  sha_pinning_required = false
}

import {
  to = github_workflow_repository_permissions.raider_rb
  id = "raider-rb"
}

resource "github_workflow_repository_permissions" "raider_rb" {
  can_approve_pull_request_reviews = true
  default_workflow_permissions     = "write"
  repository                       = "raider-rb"
}

import {
  to = github_repository_dependabot_security_updates.raider_rb
  id = "raider-rb"
}

resource "github_repository_dependabot_security_updates" "raider_rb" {
  enabled    = false
  repository = "raider-rb"
}

import {
  to = github_branch_default.raider_rb
  id = "raider-rb"
}

resource "github_branch_default" "raider_rb" {
  branch          = "ruby"
  etag            = "W/\"3f0d30c8e5b102953f261457fe29abf7252d964cc02024ff04c1b0fd480db67f\""
  rename          = null
  repository      = "raider-rb"
  wait_for_rename = null
}

