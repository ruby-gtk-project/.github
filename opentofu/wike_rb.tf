import {
  to = github_workflow_repository_permissions.wike_rb
  id = "Wike-rb"
}

resource "github_workflow_repository_permissions" "wike_rb" {
  can_approve_pull_request_reviews = true
  default_workflow_permissions     = "write"
  repository                       = "Wike-rb"
}

import {
  to = github_repository_vulnerability_alerts.wike_rb
  id = "Wike-rb"
}

resource "github_repository_vulnerability_alerts" "wike_rb" {
  enabled    = false
  repository = "Wike-rb"
}

import {
  to = github_repository.wike_rb
  id = "Wike-rb"
}

resource "github_repository" "wike_rb" {
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
  description                 = "Wikipedia Reader for the GNOME Desktop"
  etag                        = "W/\"339cde7e0d9e373cca38f3a68e9b8df23291d82946dd8e77c2921284aaa40995\""
  fork                        = "true"
  gitignore_template          = null
  has_discussions             = false
  has_issues                  = true
  has_projects                = true
  has_wiki                    = true
  homepage_url                = "https://hugolabe.github.io/Wike/"
  is_template                 = false
  license_template            = null
  merge_commit_message        = "PR_TITLE"
  merge_commit_title          = "MERGE_MESSAGE"
  name                        = "Wike-rb"
  source_owner                = "hugolabe"
  source_repo                 = "Wike"
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
  to = github_repository_dependabot_security_updates.wike_rb
  id = "Wike-rb"
}

resource "github_repository_dependabot_security_updates" "wike_rb" {
  enabled    = false
  repository = "Wike-rb"
}

import {
  to = github_branch_default.wike_rb
  id = "Wike-rb"
}

resource "github_branch_default" "wike_rb" {
  branch          = "ruby"
  etag            = "W/\"c67732e6254c7c97b5da9458e0f4fdc7e6f01ded0058c41c3e005e8155e6c601\""
  rename          = null
  repository      = "Wike-rb"
  wait_for_rename = null
}

import {
  to = github_repository_collaborators.wike_rb
  id = "Wike-rb"
}

resource "github_repository_collaborators" "wike_rb" {
  repository = "Wike-rb"
}

import {
  to = github_actions_repository_permissions.wike_rb
  id = "Wike-rb"
}

resource "github_actions_repository_permissions" "wike_rb" {
  allowed_actions      = "all"
  enabled              = true
  repository           = "Wike-rb"
  sha_pinning_required = false
}

import {
  to = github_repository_topics.wike_rb
  id = "Wike-rb"
}

resource "github_repository_topics" "wike_rb" {
  repository = "Wike-rb"
  topics     = []
}

import {
  to = github_issue_labels.wike_rb
  id = "Wike-rb"
}

resource "github_issue_labels" "wike_rb" {
  repository = "Wike-rb"
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

