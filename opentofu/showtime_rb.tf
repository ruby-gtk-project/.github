import {
  to = github_workflow_repository_permissions.showtime_rb
  id = "showtime-rb"
}

resource "github_workflow_repository_permissions" "showtime_rb" {
  can_approve_pull_request_reviews = true
  default_workflow_permissions     = "write"
  repository                       = "showtime-rb"
}

import {
  to = github_branch_default.showtime_rb
  id = "showtime-rb"
}

resource "github_branch_default" "showtime_rb" {
  branch          = "ruby"
  etag            = "W/\"a5424526fe88b9dd4b46beee7af979595cdd384cec4a5a87b5b6d5b94ba6cdd1\""
  rename          = null
  repository      = "showtime-rb"
  wait_for_rename = null
}

import {
  to = github_actions_repository_permissions.showtime_rb
  id = "showtime-rb"
}

resource "github_actions_repository_permissions" "showtime_rb" {
  allowed_actions      = "all"
  enabled              = true
  repository           = "showtime-rb"
  sha_pinning_required = false
}

import {
  to = github_issue_labels.showtime_rb
  id = "showtime-rb"
}

resource "github_issue_labels" "showtime_rb" {
  repository = "showtime-rb"
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
  to = github_repository_dependabot_security_updates.showtime_rb
  id = "showtime-rb"
}

resource "github_repository_dependabot_security_updates" "showtime_rb" {
  enabled    = false
  repository = "showtime-rb"
}

import {
  to = github_repository.showtime_rb
  id = "showtime-rb"
}

resource "github_repository" "showtime_rb" {
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
  description                 = "Read-only mirror of https://gitlab.gnome.org/GNOME/showtime"
  etag                        = "W/\"af0d203b024f06329c7b58f0239f97f90ede251c2e2939c7f5a3d15fa7a50343\""
  fork                        = "true"
  gitignore_template          = null
  has_discussions             = false
  has_issues                  = true
  has_projects                = true
  has_wiki                    = false
  homepage_url                = "https://gitlab.gnome.org/GNOME/showtime"
  is_template                 = false
  license_template            = null
  merge_commit_message        = "PR_TITLE"
  merge_commit_title          = "MERGE_MESSAGE"
  name                        = "showtime-rb"
  source_owner                = "GNOME"
  source_repo                 = "showtime"
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
  to = github_repository_collaborators.showtime_rb
  id = "showtime-rb"
}

resource "github_repository_collaborators" "showtime_rb" {
  repository = "showtime-rb"
}

import {
  to = github_repository_vulnerability_alerts.showtime_rb
  id = "showtime-rb"
}

resource "github_repository_vulnerability_alerts" "showtime_rb" {
  enabled    = false
  repository = "showtime-rb"
}

import {
  to = github_repository_topics.showtime_rb
  id = "showtime-rb"
}

resource "github_repository_topics" "showtime_rb" {
  repository = "showtime-rb"
  topics     = []
}

