import {
  to = github_repository.gnome_clocks_rb
  id = "gnome-clocks-rb"
}

resource "github_repository" "gnome_clocks_rb" {
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
  description                 = "Read-only mirror of https://gitlab.gnome.org/GNOME/gnome-clocks"
  etag                        = "W/\"0969608be72b99cf0471f10d405624ada24fc5019200f014aa842b5bdc16db67\""
  fork                        = "true"
  gitignore_template          = null
  has_discussions             = false
  has_issues                  = true
  has_projects                = true
  has_wiki                    = false
  homepage_url                = "https://gitlab.gnome.org/GNOME/gnome-clocks"
  is_template                 = false
  license_template            = null
  merge_commit_message        = "PR_TITLE"
  merge_commit_title          = "MERGE_MESSAGE"
  name                        = "gnome-clocks-rb"
  source_owner                = "GNOME"
  source_repo                 = "gnome-clocks"
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
  to = github_actions_repository_permissions.gnome_clocks_rb
  id = "gnome-clocks-rb"
}

resource "github_actions_repository_permissions" "gnome_clocks_rb" {
  allowed_actions      = "all"
  enabled              = true
  repository           = "gnome-clocks-rb"
  sha_pinning_required = false
}

import {
  to = github_repository_dependabot_security_updates.gnome_clocks_rb
  id = "gnome-clocks-rb"
}

resource "github_repository_dependabot_security_updates" "gnome_clocks_rb" {
  enabled    = false
  repository = "gnome-clocks-rb"
}

import {
  to = github_issue_labels.gnome_clocks_rb
  id = "gnome-clocks-rb"
}

resource "github_issue_labels" "gnome_clocks_rb" {
  repository = "gnome-clocks-rb"
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
  to = github_workflow_repository_permissions.gnome_clocks_rb
  id = "gnome-clocks-rb"
}

resource "github_workflow_repository_permissions" "gnome_clocks_rb" {
  can_approve_pull_request_reviews = true
  default_workflow_permissions     = "write"
  repository                       = "gnome-clocks-rb"
}

import {
  to = github_repository_topics.gnome_clocks_rb
  id = "gnome-clocks-rb"
}

resource "github_repository_topics" "gnome_clocks_rb" {
  repository = "gnome-clocks-rb"
  topics     = []
}

import {
  to = github_repository_collaborators.gnome_clocks_rb
  id = "gnome-clocks-rb"
}

resource "github_repository_collaborators" "gnome_clocks_rb" {
  repository = "gnome-clocks-rb"
}

import {
  to = github_branch_default.gnome_clocks_rb
  id = "gnome-clocks-rb"
}

resource "github_branch_default" "gnome_clocks_rb" {
  branch          = "ruby"
  etag            = "W/\"87e403c4ae67037d670ad2af4b83ba16f1accef86e0b22fec6d7aa6f9edee29d\""
  rename          = null
  repository      = "gnome-clocks-rb"
  wait_for_rename = null
}

import {
  to = github_repository_vulnerability_alerts.gnome_clocks_rb
  id = "gnome-clocks-rb"
}

resource "github_repository_vulnerability_alerts" "gnome_clocks_rb" {
  enabled    = false
  repository = "gnome-clocks-rb"
}

