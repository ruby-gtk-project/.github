import {
  to = github_repository_vulnerability_alerts.constrict_rb
  id = "Constrict-rb"
}

resource "github_repository_vulnerability_alerts" "constrict_rb" {
  enabled    = false
  repository = "Constrict-rb"
}

import {
  to = github_branch_default.constrict_rb
  id = "Constrict-rb"
}

resource "github_branch_default" "constrict_rb" {
  branch          = "ruby"
  etag            = "W/\"0c9776e183fd0ebda9a5dc5b54b7dad7958c05ef7dcda333072275925c2145c1\""
  rename          = null
  repository      = "Constrict-rb"
  wait_for_rename = null
}

import {
  to = github_repository_dependabot_security_updates.constrict_rb
  id = "Constrict-rb"
}

resource "github_repository_dependabot_security_updates" "constrict_rb" {
  enabled    = false
  repository = "Constrict-rb"
}

import {
  to = github_repository.constrict_rb
  id = "Constrict-rb"
}

resource "github_repository" "constrict_rb" {
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
  description                 = "Read-only mirror of https://gitlab.gnome.org/World/Constrict"
  etag                        = "W/\"0c9776e183fd0ebda9a5dc5b54b7dad7958c05ef7dcda333072275925c2145c1\""
  fork                        = "true"
  gitignore_template          = null
  has_discussions             = false
  has_issues                  = true
  has_projects                = true
  has_wiki                    = false
  homepage_url                = "https://apps.gnome.org/Constrict"
  is_template                 = false
  license_template            = null
  merge_commit_message        = "PR_TITLE"
  merge_commit_title          = "MERGE_MESSAGE"
  name                        = "Constrict-rb"
  source_owner                = "Wartybix"
  source_repo                 = "Constrict"
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
  to = github_workflow_repository_permissions.constrict_rb
  id = "Constrict-rb"
}

resource "github_workflow_repository_permissions" "constrict_rb" {
  can_approve_pull_request_reviews = true
  default_workflow_permissions     = "write"
  repository                       = "Constrict-rb"
}

import {
  to = github_repository_topics.constrict_rb
  id = "Constrict-rb"
}

resource "github_repository_topics" "constrict_rb" {
  repository = "Constrict-rb"
  topics     = []
}

import {
  to = github_issue_labels.constrict_rb
  id = "Constrict-rb"
}

resource "github_issue_labels" "constrict_rb" {
  repository = "Constrict-rb"
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
  to = github_repository_collaborators.constrict_rb
  id = "Constrict-rb"
}

resource "github_repository_collaborators" "constrict_rb" {
  repository = "Constrict-rb"
}

import {
  to = github_actions_repository_permissions.constrict_rb
  id = "Constrict-rb"
}

resource "github_actions_repository_permissions" "constrict_rb" {
  allowed_actions      = "all"
  enabled              = true
  repository           = "Constrict-rb"
  sha_pinning_required = false
}

