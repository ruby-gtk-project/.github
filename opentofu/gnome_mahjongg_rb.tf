import {
  to = github_repository_vulnerability_alerts.gnome_mahjongg_rb
  id = "gnome-mahjongg-rb"
}

resource "github_repository_vulnerability_alerts" "gnome_mahjongg_rb" {
  enabled    = false
  repository = "gnome-mahjongg-rb"
}

import {
  to = github_repository.gnome_mahjongg_rb
  id = "gnome-mahjongg-rb"
}

resource "github_repository" "gnome_mahjongg_rb" {
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
  description                 = "Read-only mirror of https://gitlab.gnome.org/GNOME/gnome-mahjongg"
  etag                        = "W/\"655b1c783b8138cdee0a068b9eebc87236b6336a5d407c58a4f7d146184f5d1d\""
  fork                        = "true"
  gitignore_template          = null
  has_discussions             = false
  has_issues                  = true
  has_projects                = true
  has_wiki                    = false
  homepage_url                = "https://gitlab.gnome.org/GNOME/gnome-mahjongg"
  is_template                 = false
  license_template            = null
  merge_commit_message        = "PR_TITLE"
  merge_commit_title          = "MERGE_MESSAGE"
  name                        = "gnome-mahjongg-rb"
  source_owner                = "GNOME"
  source_repo                 = "gnome-mahjongg"
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
  to = github_repository_topics.gnome_mahjongg_rb
  id = "gnome-mahjongg-rb"
}

resource "github_repository_topics" "gnome_mahjongg_rb" {
  repository = "gnome-mahjongg-rb"
  topics     = []
}

import {
  to = github_repository_collaborators.gnome_mahjongg_rb
  id = "gnome-mahjongg-rb"
}

resource "github_repository_collaborators" "gnome_mahjongg_rb" {
  repository = "gnome-mahjongg-rb"
}

import {
  to = github_branch_default.gnome_mahjongg_rb
  id = "gnome-mahjongg-rb"
}

resource "github_branch_default" "gnome_mahjongg_rb" {
  branch          = "ruby"
  etag            = "W/\"b07cd03f152d51e803fe3f4c41ae80d78f4a392de1ecdb5c3ea6442223bf4f15\""
  rename          = null
  repository      = "gnome-mahjongg-rb"
  wait_for_rename = null
}

import {
  to = github_workflow_repository_permissions.gnome_mahjongg_rb
  id = "gnome-mahjongg-rb"
}

resource "github_workflow_repository_permissions" "gnome_mahjongg_rb" {
  can_approve_pull_request_reviews = true
  default_workflow_permissions     = "write"
  repository                       = "gnome-mahjongg-rb"
}

import {
  to = github_actions_repository_permissions.gnome_mahjongg_rb
  id = "gnome-mahjongg-rb"
}

resource "github_actions_repository_permissions" "gnome_mahjongg_rb" {
  allowed_actions      = "all"
  enabled              = true
  repository           = "gnome-mahjongg-rb"
  sha_pinning_required = false
}

import {
  to = github_issue_labels.gnome_mahjongg_rb
  id = "gnome-mahjongg-rb"
}

resource "github_issue_labels" "gnome_mahjongg_rb" {
  repository = "gnome-mahjongg-rb"
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
  to = github_repository_dependabot_security_updates.gnome_mahjongg_rb
  id = "gnome-mahjongg-rb"
}

resource "github_repository_dependabot_security_updates" "gnome_mahjongg_rb" {
  enabled    = false
  repository = "gnome-mahjongg-rb"
}

