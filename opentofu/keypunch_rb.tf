import {
  to = github_repository_vulnerability_alerts.keypunch_rb
  id = "keypunch-rb"
}

resource "github_repository_vulnerability_alerts" "keypunch_rb" {
  enabled    = false
  repository = "keypunch-rb"
}

import {
  to = github_workflow_repository_permissions.keypunch_rb
  id = "keypunch-rb"
}

resource "github_workflow_repository_permissions" "keypunch_rb" {
  can_approve_pull_request_reviews = true
  default_workflow_permissions     = "write"
  repository                       = "keypunch-rb"
}

import {
  to = github_repository.keypunch_rb
  id = "keypunch-rb"
}

resource "github_repository" "keypunch_rb" {
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
  description                 = "Practice your typing skills"
  etag                        = "W/\"004f108a2756f55be8c85a16cd48c452a85d43e43126e8f08f2899b548771938\""
  fork                        = "true"
  gitignore_template          = null
  has_discussions             = false
  has_issues                  = true
  has_projects                = true
  has_wiki                    = false
  homepage_url                = "https://apps.gnome.org/Keypunch"
  is_template                 = false
  license_template            = null
  merge_commit_message        = "PR_TITLE"
  merge_commit_title          = "MERGE_MESSAGE"
  name                        = "keypunch-rb"
  source_owner                = "bragefuglseth"
  source_repo                 = "keypunch"
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
  to = github_repository_dependabot_security_updates.keypunch_rb
  id = "keypunch-rb"
}

resource "github_repository_dependabot_security_updates" "keypunch_rb" {
  enabled    = false
  repository = "keypunch-rb"
}

import {
  to = github_actions_repository_permissions.keypunch_rb
  id = "keypunch-rb"
}

resource "github_actions_repository_permissions" "keypunch_rb" {
  allowed_actions      = "all"
  enabled              = true
  repository           = "keypunch-rb"
  sha_pinning_required = false
}

import {
  to = github_repository_topics.keypunch_rb
  id = "keypunch-rb"
}

resource "github_repository_topics" "keypunch_rb" {
  repository = "keypunch-rb"
  topics     = []
}

import {
  to = github_branch_default.keypunch_rb
  id = "keypunch-rb"
}

resource "github_branch_default" "keypunch_rb" {
  branch          = "ruby"
  etag            = "W/\"0a5a9399d77f99ca2acb7cdae5c2a536b8229e6e848641bb8d4e8abd6e6b662c\""
  rename          = null
  repository      = "keypunch-rb"
  wait_for_rename = null
}

import {
  to = github_repository_collaborators.keypunch_rb
  id = "keypunch-rb"
}

resource "github_repository_collaborators" "keypunch_rb" {
  repository = "keypunch-rb"
}

import {
  to = github_issue_labels.keypunch_rb
  id = "keypunch-rb"
}

resource "github_issue_labels" "keypunch_rb" {
  repository = "keypunch-rb"
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

