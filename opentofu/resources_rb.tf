import {
  to = github_actions_repository_permissions.resources_rb
  id = "resources-rb"
}

resource "github_actions_repository_permissions" "resources_rb" {
  allowed_actions      = "all"
  enabled              = true
  repository           = "resources-rb"
  sha_pinning_required = false
}

import {
  to = github_workflow_repository_permissions.resources_rb
  id = "resources-rb"
}

resource "github_workflow_repository_permissions" "resources_rb" {
  can_approve_pull_request_reviews = true
  default_workflow_permissions     = "write"
  repository                       = "resources-rb"
}

import {
  to = github_repository.resources_rb
  id = "resources-rb"
}

resource "github_repository" "resources_rb" {
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
  description                 = "Keep an eye on system resources"
  etag                        = "W/\"5fd4372c5eeaf645bfc81908ad1b73901282f640035a74b26a6a04ce868ec0e9\""
  fork                        = "true"
  gitignore_template          = null
  has_discussions             = false
  has_issues                  = true
  has_projects                = true
  has_wiki                    = false
  homepage_url                = "https://resources.nokyan.net"
  is_template                 = false
  license_template            = null
  merge_commit_message        = "PR_TITLE"
  merge_commit_title          = "MERGE_MESSAGE"
  name                        = "resources-rb"
  source_owner                = "nokyan"
  source_repo                 = "resources"
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
  to = github_repository_collaborators.resources_rb
  id = "resources-rb"
}

resource "github_repository_collaborators" "resources_rb" {
  repository = "resources-rb"
}

import {
  to = github_repository_topics.resources_rb
  id = "resources-rb"
}

resource "github_repository_topics" "resources_rb" {
  repository = "resources-rb"
  topics     = []
}

import {
  to = github_repository_dependabot_security_updates.resources_rb
  id = "resources-rb"
}

resource "github_repository_dependabot_security_updates" "resources_rb" {
  enabled    = false
  repository = "resources-rb"
}

import {
  to = github_issue_labels.resources_rb
  id = "resources-rb"
}

resource "github_issue_labels" "resources_rb" {
  repository = "resources-rb"
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
  to = github_repository_vulnerability_alerts.resources_rb
  id = "resources-rb"
}

resource "github_repository_vulnerability_alerts" "resources_rb" {
  enabled    = false
  repository = "resources-rb"
}

import {
  to = github_branch_default.resources_rb
  id = "resources-rb"
}

resource "github_branch_default" "resources_rb" {
  branch          = "ruby"
  etag            = "W/\"1cea43d6eb46239eca4141ffd3278f4131b3105d4a44792a718f8f2ac5d71ca4\""
  rename          = null
  repository      = "resources-rb"
  wait_for_rename = null
}

