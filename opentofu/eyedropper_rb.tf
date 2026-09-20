import {
  to = github_repository.eyedropper_rb
  id = "eyedropper-rb"
}

resource "github_repository" "eyedropper_rb" {
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
  description                 = "Pick and format colors"
  etag                        = "W/\"dad89a1765157ef757052abe16c2113c9792a36703f37bc30a89417e1ef2cea7\""
  fork                        = "true"
  gitignore_template          = null
  has_discussions             = false
  has_issues                  = true
  has_projects                = true
  has_wiki                    = true
  homepage_url                = "https://apps.gnome.org/Eyedropper"
  is_template                 = false
  license_template            = null
  merge_commit_message        = "PR_TITLE"
  merge_commit_title          = "MERGE_MESSAGE"
  name                        = "eyedropper-rb"
  source_owner                = "FineFindus"
  source_repo                 = "eyedropper"
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
  to = github_repository_collaborators.eyedropper_rb
  id = "eyedropper-rb"
}

resource "github_repository_collaborators" "eyedropper_rb" {
  repository = "eyedropper-rb"
}

import {
  to = github_repository_dependabot_security_updates.eyedropper_rb
  id = "eyedropper-rb"
}

resource "github_repository_dependabot_security_updates" "eyedropper_rb" {
  enabled    = false
  repository = "eyedropper-rb"
}

import {
  to = github_repository_vulnerability_alerts.eyedropper_rb
  id = "eyedropper-rb"
}

resource "github_repository_vulnerability_alerts" "eyedropper_rb" {
  enabled    = false
  repository = "eyedropper-rb"
}

import {
  to = github_workflow_repository_permissions.eyedropper_rb
  id = "eyedropper-rb"
}

resource "github_workflow_repository_permissions" "eyedropper_rb" {
  can_approve_pull_request_reviews = true
  default_workflow_permissions     = "write"
  repository                       = "eyedropper-rb"
}

import {
  to = github_repository_topics.eyedropper_rb
  id = "eyedropper-rb"
}

resource "github_repository_topics" "eyedropper_rb" {
  repository = "eyedropper-rb"
  topics     = []
}

import {
  to = github_issue_labels.eyedropper_rb
  id = "eyedropper-rb"
}

resource "github_issue_labels" "eyedropper_rb" {
  repository = "eyedropper-rb"
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
  to = github_branch_default.eyedropper_rb
  id = "eyedropper-rb"
}

resource "github_branch_default" "eyedropper_rb" {
  branch          = "ruby"
  etag            = "W/\"0a8e077753c488e521f90035d55a310b4727c4e2b7002f783d0868b17cdf4d5b\""
  rename          = null
  repository      = "eyedropper-rb"
  wait_for_rename = null
}

import {
  to = github_actions_repository_permissions.eyedropper_rb
  id = "eyedropper-rb"
}

resource "github_actions_repository_permissions" "eyedropper_rb" {
  allowed_actions      = "all"
  enabled              = true
  repository           = "eyedropper-rb"
  sha_pinning_required = false
}

