import {
  to = github_actions_repository_permissions.forge_sparks_rb
  id = "forge-sparks-rb"
}

resource "github_actions_repository_permissions" "forge_sparks_rb" {
  allowed_actions      = "all"
  enabled              = true
  repository           = "forge-sparks-rb"
  sha_pinning_required = false
}

import {
  to = github_branch_default.forge_sparks_rb
  id = "forge-sparks-rb"
}

resource "github_branch_default" "forge_sparks_rb" {
  branch          = "ruby"
  etag            = "W/\"44ca70e1e0ae86dbe6674963e8cf39b75b544a2ee4c61b5f9d00b635cf0db408\""
  rename          = null
  repository      = "forge-sparks-rb"
  wait_for_rename = null
}

import {
  to = github_repository_topics.forge_sparks_rb
  id = "forge-sparks-rb"
}

resource "github_repository_topics" "forge_sparks_rb" {
  repository = "forge-sparks-rb"
  topics     = []
}

import {
  to = github_repository_collaborators.forge_sparks_rb
  id = "forge-sparks-rb"
}

resource "github_repository_collaborators" "forge_sparks_rb" {
  repository = "forge-sparks-rb"
}

import {
  to = github_issue_labels.forge_sparks_rb
  id = "forge-sparks-rb"
}

resource "github_issue_labels" "forge_sparks_rb" {
  repository = "forge-sparks-rb"
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
  to = github_repository_vulnerability_alerts.forge_sparks_rb
  id = "forge-sparks-rb"
}

resource "github_repository_vulnerability_alerts" "forge_sparks_rb" {
  enabled    = false
  repository = "forge-sparks-rb"
}

import {
  to = github_repository_dependabot_security_updates.forge_sparks_rb
  id = "forge-sparks-rb"
}

resource "github_repository_dependabot_security_updates" "forge_sparks_rb" {
  enabled    = false
  repository = "forge-sparks-rb"
}

import {
  to = github_workflow_repository_permissions.forge_sparks_rb
  id = "forge-sparks-rb"
}

resource "github_workflow_repository_permissions" "forge_sparks_rb" {
  can_approve_pull_request_reviews = true
  default_workflow_permissions     = "write"
  repository                       = "forge-sparks-rb"
}

import {
  to = github_repository.forge_sparks_rb
  id = "forge-sparks-rb"
}

resource "github_repository" "forge_sparks_rb" {
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
  description                 = "Get git forges notifications"
  etag                        = "W/\"dd77db9ce99c50137aab1ad5c01df313744071f5b8f6a87f17f0644d5925d733\""
  fork                        = "true"
  gitignore_template          = null
  has_discussions             = false
  has_issues                  = true
  has_projects                = true
  has_wiki                    = true
  homepage_url                = ""
  is_template                 = false
  license_template            = null
  merge_commit_message        = "PR_TITLE"
  merge_commit_title          = "MERGE_MESSAGE"
  name                        = "forge-sparks-rb"
  source_owner                = "rafaelmardojai"
  source_repo                 = "forge-sparks"
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

