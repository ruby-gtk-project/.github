import {
  to = github_repository.pika_backup_rb
  id = "pika-backup-rb"
}

resource "github_repository" "pika_backup_rb" {
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
  description                 = "Pika Backup – 🪞 Mirror only 🪞 – See https://gitlab.gnome.org/World/pika-backup for development"
  etag                        = "W/\"bb5b6ca6bb29c58bfd183bb507578e36b2922f9df9fad48cbbd8926d35fecd4c\""
  fork                        = "true"
  gitignore_template          = null
  has_discussions             = false
  has_issues                  = true
  has_projects                = true
  has_wiki                    = false
  homepage_url                = "https://gitlab.gnome.org/World/pika-backup"
  is_template                 = false
  license_template            = null
  merge_commit_message        = "PR_TITLE"
  merge_commit_title          = "MERGE_MESSAGE"
  name                        = "pika-backup-rb"
  source_owner                = "pika-backup"
  source_repo                 = "pika-backup"
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
  to = github_repository_vulnerability_alerts.pika_backup_rb
  id = "pika-backup-rb"
}

resource "github_repository_vulnerability_alerts" "pika_backup_rb" {
  enabled    = false
  repository = "pika-backup-rb"
}

import {
  to = github_repository_collaborators.pika_backup_rb
  id = "pika-backup-rb"
}

resource "github_repository_collaborators" "pika_backup_rb" {
  repository = "pika-backup-rb"
}

import {
  to = github_repository_dependabot_security_updates.pika_backup_rb
  id = "pika-backup-rb"
}

resource "github_repository_dependabot_security_updates" "pika_backup_rb" {
  enabled    = false
  repository = "pika-backup-rb"
}

import {
  to = github_issue_labels.pika_backup_rb
  id = "pika-backup-rb"
}

resource "github_issue_labels" "pika_backup_rb" {
  repository = "pika-backup-rb"
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
  to = github_actions_repository_permissions.pika_backup_rb
  id = "pika-backup-rb"
}

resource "github_actions_repository_permissions" "pika_backup_rb" {
  allowed_actions      = "all"
  enabled              = true
  repository           = "pika-backup-rb"
  sha_pinning_required = false
}

import {
  to = github_branch_default.pika_backup_rb
  id = "pika-backup-rb"
}

resource "github_branch_default" "pika_backup_rb" {
  branch          = "ruby"
  etag            = "W/\"14c18207011160e8ba52e680033a0c494b6718a709e4eebe834c447e515261b8\""
  rename          = null
  repository      = "pika-backup-rb"
  wait_for_rename = null
}

import {
  to = github_workflow_repository_permissions.pika_backup_rb
  id = "pika-backup-rb"
}

resource "github_workflow_repository_permissions" "pika_backup_rb" {
  can_approve_pull_request_reviews = true
  default_workflow_permissions     = "write"
  repository                       = "pika-backup-rb"
}

import {
  to = github_repository_topics.pika_backup_rb
  id = "pika-backup-rb"
}

resource "github_repository_topics" "pika_backup_rb" {
  repository = "pika-backup-rb"
  topics     = []
}

