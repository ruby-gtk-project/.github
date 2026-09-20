import {
  to = github_repository.collision_rb
  id = "Collision-rb"
}

resource "github_repository" "collision_rb" {
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
  description                 = "[MIRROR] Check hashes for your files - A GUI tool to generate, compare and verify MD5, SHA-1, SHA-256, SHA-512, Blake3, CRC32 & Adler32 hashes."
  etag                        = "W/\"c5a71dcdd4c169adfc550b26b4891c7db732e4e3790f3f8e6bdfeb6b8f38cec7\""
  fork                        = "true"
  gitignore_template          = null
  has_discussions             = false
  has_issues                  = true
  has_projects                = true
  has_wiki                    = false
  homepage_url                = "https://codeberg.org/GeopJr/Collision"
  is_template                 = false
  license_template            = null
  merge_commit_message        = "PR_TITLE"
  merge_commit_title          = "MERGE_MESSAGE"
  name                        = "Collision-rb"
  source_owner                = "GeopJr"
  source_repo                 = "Collision"
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
  to = github_issue_labels.collision_rb
  id = "Collision-rb"
}

resource "github_issue_labels" "collision_rb" {
  repository = "Collision-rb"
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
  to = github_repository_topics.collision_rb
  id = "Collision-rb"
}

resource "github_repository_topics" "collision_rb" {
  repository = "Collision-rb"
  topics     = []
}

import {
  to = github_repository_vulnerability_alerts.collision_rb
  id = "Collision-rb"
}

resource "github_repository_vulnerability_alerts" "collision_rb" {
  enabled    = false
  repository = "Collision-rb"
}

import {
  to = github_actions_repository_permissions.collision_rb
  id = "Collision-rb"
}

resource "github_actions_repository_permissions" "collision_rb" {
  allowed_actions      = "all"
  enabled              = true
  repository           = "Collision-rb"
  sha_pinning_required = false
}

import {
  to = github_branch_default.collision_rb
  id = "Collision-rb"
}

resource "github_branch_default" "collision_rb" {
  branch          = "ruby"
  etag            = "W/\"9cf129cded498d276ed786011704a05c144e775575b1fd64d4956926a862d605\""
  rename          = null
  repository      = "Collision-rb"
  wait_for_rename = null
}

import {
  to = github_repository_dependabot_security_updates.collision_rb
  id = "Collision-rb"
}

resource "github_repository_dependabot_security_updates" "collision_rb" {
  enabled    = false
  repository = "Collision-rb"
}

import {
  to = github_workflow_repository_permissions.collision_rb
  id = "Collision-rb"
}

resource "github_workflow_repository_permissions" "collision_rb" {
  can_approve_pull_request_reviews = true
  default_workflow_permissions     = "write"
  repository                       = "Collision-rb"
}

import {
  to = github_repository_collaborators.collision_rb
  id = "Collision-rb"
}

resource "github_repository_collaborators" "collision_rb" {
  repository = "Collision-rb"
}

