import {
  to = github_repository_dependabot_security_updates.epiphany_rb
  id = "epiphany-rb"
}

resource "github_repository_dependabot_security_updates" "epiphany_rb" {
  enabled    = false
  repository = "epiphany-rb"
}

import {
  to = github_repository.epiphany_rb
  id = "epiphany-rb"
}

resource "github_repository" "epiphany_rb" {
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
  description                 = "Read-only mirror of https://gitlab.gnome.org/GNOME/epiphany"
  etag                        = "W/\"718eea548ff7e3eba77667e154b5a6f11751e84332d4f0a4186b29d4eb63dcd3\""
  fork                        = "true"
  gitignore_template          = null
  has_discussions             = false
  has_issues                  = true
  has_projects                = true
  has_wiki                    = false
  homepage_url                = "https://gitlab.gnome.org/GNOME/epiphany"
  is_template                 = false
  license_template            = null
  merge_commit_message        = "PR_TITLE"
  merge_commit_title          = "MERGE_MESSAGE"
  name                        = "epiphany-rb"
  source_owner                = "GNOME"
  source_repo                 = "epiphany"
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
  to = github_workflow_repository_permissions.epiphany_rb
  id = "epiphany-rb"
}

resource "github_workflow_repository_permissions" "epiphany_rb" {
  can_approve_pull_request_reviews = true
  default_workflow_permissions     = "write"
  repository                       = "epiphany-rb"
}

import {
  to = github_actions_repository_permissions.epiphany_rb
  id = "epiphany-rb"
}

resource "github_actions_repository_permissions" "epiphany_rb" {
  allowed_actions      = "all"
  enabled              = true
  repository           = "epiphany-rb"
  sha_pinning_required = false
}

import {
  to = github_issue_labels.epiphany_rb
  id = "epiphany-rb"
}

resource "github_issue_labels" "epiphany_rb" {
  repository = "epiphany-rb"
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
  to = github_branch_default.epiphany_rb
  id = "epiphany-rb"
}

resource "github_branch_default" "epiphany_rb" {
  branch          = "ruby"
  etag            = "W/\"718eea548ff7e3eba77667e154b5a6f11751e84332d4f0a4186b29d4eb63dcd3\""
  rename          = null
  repository      = "epiphany-rb"
  wait_for_rename = null
}

import {
  to = github_repository_topics.epiphany_rb
  id = "epiphany-rb"
}

resource "github_repository_topics" "epiphany_rb" {
  repository = "epiphany-rb"
  topics     = []
}

import {
  to = github_repository_vulnerability_alerts.epiphany_rb
  id = "epiphany-rb"
}

resource "github_repository_vulnerability_alerts" "epiphany_rb" {
  enabled    = false
  repository = "epiphany-rb"
}

import {
  to = github_repository_collaborators.epiphany_rb
  id = "epiphany-rb"
}

resource "github_repository_collaborators" "epiphany_rb" {
  repository = "epiphany-rb"
}

