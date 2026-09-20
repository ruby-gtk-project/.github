import {
  to = github_repository.fretboard_rb
  id = "fretboard-rb"
}

resource "github_repository" "fretboard_rb" {
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
  description                 = "Look up guitar chords"
  etag                        = "W/\"9e702f2172fda841a51346806d4e6e2301cfcc0579906beb7a892177bd00ba24\""
  fork                        = "true"
  gitignore_template          = null
  has_discussions             = false
  has_issues                  = true
  has_projects                = true
  has_wiki                    = false
  homepage_url                = "https://apps.gnome.org/Fretboard"
  is_template                 = false
  license_template            = null
  merge_commit_message        = "PR_TITLE"
  merge_commit_title          = "MERGE_MESSAGE"
  name                        = "fretboard-rb"
  source_owner                = "bragefuglseth"
  source_repo                 = "fretboard"
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
  to = github_repository_topics.fretboard_rb
  id = "fretboard-rb"
}

resource "github_repository_topics" "fretboard_rb" {
  repository = "fretboard-rb"
  topics     = []
}

import {
  to = github_repository_dependabot_security_updates.fretboard_rb
  id = "fretboard-rb"
}

resource "github_repository_dependabot_security_updates" "fretboard_rb" {
  enabled    = false
  repository = "fretboard-rb"
}

import {
  to = github_branch_default.fretboard_rb
  id = "fretboard-rb"
}

resource "github_branch_default" "fretboard_rb" {
  branch          = "ruby"
  etag            = "W/\"eae7b729c98bb4b96dc36b7fc57ad604ed914c405ba3c09d64da09a7b786428b\""
  rename          = null
  repository      = "fretboard-rb"
  wait_for_rename = null
}

import {
  to = github_actions_repository_permissions.fretboard_rb
  id = "fretboard-rb"
}

resource "github_actions_repository_permissions" "fretboard_rb" {
  allowed_actions      = "all"
  enabled              = true
  repository           = "fretboard-rb"
  sha_pinning_required = false
}

import {
  to = github_repository_vulnerability_alerts.fretboard_rb
  id = "fretboard-rb"
}

resource "github_repository_vulnerability_alerts" "fretboard_rb" {
  enabled    = false
  repository = "fretboard-rb"
}

import {
  to = github_workflow_repository_permissions.fretboard_rb
  id = "fretboard-rb"
}

resource "github_workflow_repository_permissions" "fretboard_rb" {
  can_approve_pull_request_reviews = true
  default_workflow_permissions     = "write"
  repository                       = "fretboard-rb"
}

import {
  to = github_repository_collaborators.fretboard_rb
  id = "fretboard-rb"
}

resource "github_repository_collaborators" "fretboard_rb" {
  repository = "fretboard-rb"
}

import {
  to = github_issue_labels.fretboard_rb
  id = "fretboard-rb"
}

resource "github_issue_labels" "fretboard_rb" {
  repository = "fretboard-rb"
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

