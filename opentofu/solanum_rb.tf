import {
  to = github_branch_default.solanum_rb
  id = "Solanum-rb"
}

resource "github_branch_default" "solanum_rb" {
  branch          = "ruby"
  etag            = "W/\"a611c237e63943b6a4e7c2292baf0e90847b0f8d40024ac230e412ecf3c15246\""
  rename          = null
  repository      = "Solanum-rb"
  wait_for_rename = null
}

import {
  to = github_repository_dependabot_security_updates.solanum_rb
  id = "Solanum-rb"
}

resource "github_repository_dependabot_security_updates" "solanum_rb" {
  enabled    = false
  repository = "Solanum-rb"
}

import {
  to = github_actions_repository_permissions.solanum_rb
  id = "Solanum-rb"
}

resource "github_actions_repository_permissions" "solanum_rb" {
  allowed_actions      = "all"
  enabled              = true
  repository           = "Solanum-rb"
  sha_pinning_required = false
}

import {
  to = github_repository_collaborators.solanum_rb
  id = "Solanum-rb"
}

resource "github_repository_collaborators" "solanum_rb" {
  repository = "Solanum-rb"
}

import {
  to = github_repository_topics.solanum_rb
  id = "Solanum-rb"
}

resource "github_repository_topics" "solanum_rb" {
  repository = "Solanum-rb"
  topics     = []
}

import {
  to = github_issue_labels.solanum_rb
  id = "Solanum-rb"
}

resource "github_issue_labels" "solanum_rb" {
  repository = "Solanum-rb"
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
  to = github_repository.solanum_rb
  id = "Solanum-rb"
}

resource "github_repository" "solanum_rb" {
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
  description                 = "(Mirror) A pomodoro timer for the GNOME desktop. Source: https://gitlab.gnome.org/World/Solanum"
  etag                        = "W/\"ecbd06023c87790cf297052208c80c8a6cec159bd25dcf0ef253a6d91486b4d3\""
  fork                        = "true"
  gitignore_template          = null
  has_discussions             = false
  has_issues                  = true
  has_projects                = true
  has_wiki                    = false
  homepage_url                = ""
  is_template                 = false
  license_template            = null
  merge_commit_message        = "PR_TITLE"
  merge_commit_title          = "MERGE_MESSAGE"
  name                        = "Solanum-rb"
  source_owner                = "BrainBlasted"
  source_repo                 = "Solanum"
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
  to = github_workflow_repository_permissions.solanum_rb
  id = "Solanum-rb"
}

resource "github_workflow_repository_permissions" "solanum_rb" {
  can_approve_pull_request_reviews = true
  default_workflow_permissions     = "write"
  repository                       = "Solanum-rb"
}

import {
  to = github_repository_vulnerability_alerts.solanum_rb
  id = "Solanum-rb"
}

resource "github_repository_vulnerability_alerts" "solanum_rb" {
  enabled    = false
  repository = "Solanum-rb"
}

