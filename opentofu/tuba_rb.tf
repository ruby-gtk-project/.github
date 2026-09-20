import {
  to = github_repository_collaborators.tuba_rb
  id = "Tuba-rb"
}

resource "github_repository_collaborators" "tuba_rb" {
  repository = "Tuba-rb"
}

import {
  to = github_actions_repository_permissions.tuba_rb
  id = "Tuba-rb"
}

resource "github_actions_repository_permissions" "tuba_rb" {
  allowed_actions      = "all"
  enabled              = true
  repository           = "Tuba-rb"
  sha_pinning_required = false
}

import {
  to = github_repository.tuba_rb
  id = "Tuba-rb"
}

resource "github_repository" "tuba_rb" {
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
  description                 = "Browse the Fediverse"
  etag                        = "W/\"6f0023c723d4a44019b46e23df5983190e6553174ea56d672c1072c0950697e6\""
  fork                        = "true"
  gitignore_template          = null
  has_discussions             = false
  has_issues                  = true
  has_projects                = true
  has_wiki                    = true
  homepage_url                = "https://tuba.geopjr.dev/"
  is_template                 = false
  license_template            = null
  merge_commit_message        = "PR_TITLE"
  merge_commit_title          = "MERGE_MESSAGE"
  name                        = "Tuba-rb"
  source_owner                = "GeopJr"
  source_repo                 = "Tuba"
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
  to = github_repository_topics.tuba_rb
  id = "Tuba-rb"
}

resource "github_repository_topics" "tuba_rb" {
  repository = "Tuba-rb"
  topics     = []
}

import {
  to = github_repository_dependabot_security_updates.tuba_rb
  id = "Tuba-rb"
}

resource "github_repository_dependabot_security_updates" "tuba_rb" {
  enabled    = false
  repository = "Tuba-rb"
}

import {
  to = github_workflow_repository_permissions.tuba_rb
  id = "Tuba-rb"
}

resource "github_workflow_repository_permissions" "tuba_rb" {
  can_approve_pull_request_reviews = true
  default_workflow_permissions     = "write"
  repository                       = "Tuba-rb"
}

import {
  to = github_repository_vulnerability_alerts.tuba_rb
  id = "Tuba-rb"
}

resource "github_repository_vulnerability_alerts" "tuba_rb" {
  enabled    = false
  repository = "Tuba-rb"
}

import {
  to = github_issue_labels.tuba_rb
  id = "Tuba-rb"
}

resource "github_issue_labels" "tuba_rb" {
  repository = "Tuba-rb"
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
  to = github_branch_default.tuba_rb
  id = "Tuba-rb"
}

resource "github_branch_default" "tuba_rb" {
  branch          = "ruby"
  etag            = "W/\"cb64beeb6258cd65ddd30ecee14c0bbfbc4a33e99d633dee642dc43ea430775e\""
  rename          = null
  repository      = "Tuba-rb"
  wait_for_rename = null
}

