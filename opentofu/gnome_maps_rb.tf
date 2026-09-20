import {
  to = github_repository_vulnerability_alerts.gnome_maps_rb
  id = "gnome-maps-rb"
}

resource "github_repository_vulnerability_alerts" "gnome_maps_rb" {
  enabled    = false
  repository = "gnome-maps-rb"
}

import {
  to = github_branch_default.gnome_maps_rb
  id = "gnome-maps-rb"
}

resource "github_branch_default" "gnome_maps_rb" {
  branch          = "ruby"
  etag            = "W/\"2b4073ab5d136db60392c6b3b46539141335c198ee82bc5cc877e280b4763aae\""
  rename          = null
  repository      = "gnome-maps-rb"
  wait_for_rename = null
}

import {
  to = github_repository_topics.gnome_maps_rb
  id = "gnome-maps-rb"
}

resource "github_repository_topics" "gnome_maps_rb" {
  repository = "gnome-maps-rb"
  topics     = []
}

import {
  to = github_actions_repository_permissions.gnome_maps_rb
  id = "gnome-maps-rb"
}

resource "github_actions_repository_permissions" "gnome_maps_rb" {
  allowed_actions      = "all"
  enabled              = true
  repository           = "gnome-maps-rb"
  sha_pinning_required = false
}

import {
  to = github_issue_labels.gnome_maps_rb
  id = "gnome-maps-rb"
}

resource "github_issue_labels" "gnome_maps_rb" {
  repository = "gnome-maps-rb"
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
  to = github_repository_dependabot_security_updates.gnome_maps_rb
  id = "gnome-maps-rb"
}

resource "github_repository_dependabot_security_updates" "gnome_maps_rb" {
  enabled    = false
  repository = "gnome-maps-rb"
}

import {
  to = github_repository_collaborators.gnome_maps_rb
  id = "gnome-maps-rb"
}

resource "github_repository_collaborators" "gnome_maps_rb" {
  repository = "gnome-maps-rb"
}

import {
  to = github_repository.gnome_maps_rb
  id = "gnome-maps-rb"
}

resource "github_repository" "gnome_maps_rb" {
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
  description                 = "Read-only mirror of https://gitlab.gnome.org/GNOME/gnome-maps"
  etag                        = "W/\"6dbf6c933e58c7c7a89205ff3f9ebacb71a09ebb3865f5de334627117706bedc\""
  fork                        = "true"
  gitignore_template          = null
  has_discussions             = false
  has_issues                  = true
  has_projects                = true
  has_wiki                    = false
  homepage_url                = "https://gitlab.gnome.org/GNOME/gnome-maps"
  is_template                 = false
  license_template            = null
  merge_commit_message        = "PR_TITLE"
  merge_commit_title          = "MERGE_MESSAGE"
  name                        = "gnome-maps-rb"
  source_owner                = "GNOME"
  source_repo                 = "gnome-maps"
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
  to = github_workflow_repository_permissions.gnome_maps_rb
  id = "gnome-maps-rb"
}

resource "github_workflow_repository_permissions" "gnome_maps_rb" {
  can_approve_pull_request_reviews = true
  default_workflow_permissions     = "write"
  repository                       = "gnome-maps-rb"
}

