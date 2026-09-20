import {
  to = github_repository.gnome_disk_utility_rb
  id = "gnome-disk-utility-rb"
}

resource "github_repository" "gnome_disk_utility_rb" {
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
  description                 = "Read-only mirror of https://gitlab.gnome.org/GNOME/gnome-disk-utility"
  etag                        = "W/\"4e050920bb9d04c9d5474175fb706f96fe4e6f6c80b6207714e2edd4575c3149\""
  fork                        = "true"
  gitignore_template          = null
  has_discussions             = false
  has_issues                  = true
  has_projects                = true
  has_wiki                    = false
  homepage_url                = "https://gitlab.gnome.org/GNOME/gnome-disk-utility"
  is_template                 = false
  license_template            = null
  merge_commit_message        = "PR_TITLE"
  merge_commit_title          = "MERGE_MESSAGE"
  name                        = "gnome-disk-utility-rb"
  source_owner                = "GNOME"
  source_repo                 = "gnome-disk-utility"
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
  to = github_repository_dependabot_security_updates.gnome_disk_utility_rb
  id = "gnome-disk-utility-rb"
}

resource "github_repository_dependabot_security_updates" "gnome_disk_utility_rb" {
  enabled    = false
  repository = "gnome-disk-utility-rb"
}

import {
  to = github_repository_vulnerability_alerts.gnome_disk_utility_rb
  id = "gnome-disk-utility-rb"
}

resource "github_repository_vulnerability_alerts" "gnome_disk_utility_rb" {
  enabled    = false
  repository = "gnome-disk-utility-rb"
}

import {
  to = github_issue_labels.gnome_disk_utility_rb
  id = "gnome-disk-utility-rb"
}

resource "github_issue_labels" "gnome_disk_utility_rb" {
  repository = "gnome-disk-utility-rb"
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
  to = github_workflow_repository_permissions.gnome_disk_utility_rb
  id = "gnome-disk-utility-rb"
}

resource "github_workflow_repository_permissions" "gnome_disk_utility_rb" {
  can_approve_pull_request_reviews = true
  default_workflow_permissions     = "write"
  repository                       = "gnome-disk-utility-rb"
}

import {
  to = github_actions_repository_permissions.gnome_disk_utility_rb
  id = "gnome-disk-utility-rb"
}

resource "github_actions_repository_permissions" "gnome_disk_utility_rb" {
  allowed_actions      = "all"
  enabled              = true
  repository           = "gnome-disk-utility-rb"
  sha_pinning_required = false
}

import {
  to = github_repository_collaborators.gnome_disk_utility_rb
  id = "gnome-disk-utility-rb"
}

resource "github_repository_collaborators" "gnome_disk_utility_rb" {
  repository = "gnome-disk-utility-rb"
}

import {
  to = github_repository_topics.gnome_disk_utility_rb
  id = "gnome-disk-utility-rb"
}

resource "github_repository_topics" "gnome_disk_utility_rb" {
  repository = "gnome-disk-utility-rb"
  topics     = []
}

import {
  to = github_branch_default.gnome_disk_utility_rb
  id = "gnome-disk-utility-rb"
}

resource "github_branch_default" "gnome_disk_utility_rb" {
  branch          = "ruby"
  etag            = "W/\"0fcd590daa6a33e9557a43a5cfb8bde60ea36f293e7cdc2725a9c1921463b4a7\""
  rename          = null
  repository      = "gnome-disk-utility-rb"
  wait_for_rename = null
}

