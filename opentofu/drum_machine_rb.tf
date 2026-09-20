import {
  to = github_repository_dependabot_security_updates.drum_machine_rb
  id = "drum-machine-rb"
}

resource "github_repository_dependabot_security_updates" "drum_machine_rb" {
  enabled    = false
  repository = "drum-machine-rb"
}

import {
  to = github_actions_repository_permissions.drum_machine_rb
  id = "drum-machine-rb"
}

resource "github_actions_repository_permissions" "drum_machine_rb" {
  allowed_actions      = "all"
  enabled              = true
  repository           = "drum-machine-rb"
  sha_pinning_required = false
}

import {
  to = github_repository.drum_machine_rb
  id = "drum-machine-rb"
}

resource "github_repository" "drum_machine_rb" {
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
  description                 = "A drum machine application, built with Python, GTK4, libadwaita."
  etag                        = "W/\"3106714f2183ac3814db22c250af510aa32117bab057e94c2bd3dcc3e3b65a47\""
  fork                        = "true"
  gitignore_template          = null
  has_discussions             = false
  has_issues                  = true
  has_projects                = true
  has_wiki                    = true
  homepage_url                = "https://apps.gnome.org/DrumMachine/"
  is_template                 = false
  license_template            = null
  merge_commit_message        = "PR_TITLE"
  merge_commit_title          = "MERGE_MESSAGE"
  name                        = "drum-machine-rb"
  source_owner                = "Revisto"
  source_repo                 = "drum-machine"
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
  to = github_branch_default.drum_machine_rb
  id = "drum-machine-rb"
}

resource "github_branch_default" "drum_machine_rb" {
  branch          = "ruby"
  etag            = "W/\"3106714f2183ac3814db22c250af510aa32117bab057e94c2bd3dcc3e3b65a47\""
  rename          = null
  repository      = "drum-machine-rb"
  wait_for_rename = null
}

import {
  to = github_issue_labels.drum_machine_rb
  id = "drum-machine-rb"
}

resource "github_issue_labels" "drum_machine_rb" {
  repository = "drum-machine-rb"
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
  to = github_repository_topics.drum_machine_rb
  id = "drum-machine-rb"
}

resource "github_repository_topics" "drum_machine_rb" {
  repository = "drum-machine-rb"
  topics     = []
}

import {
  to = github_repository_collaborators.drum_machine_rb
  id = "drum-machine-rb"
}

resource "github_repository_collaborators" "drum_machine_rb" {
  repository = "drum-machine-rb"
}

import {
  to = github_workflow_repository_permissions.drum_machine_rb
  id = "drum-machine-rb"
}

resource "github_workflow_repository_permissions" "drum_machine_rb" {
  can_approve_pull_request_reviews = true
  default_workflow_permissions     = "write"
  repository                       = "drum-machine-rb"
}

import {
  to = github_repository_vulnerability_alerts.drum_machine_rb
  id = "drum-machine-rb"
}

resource "github_repository_vulnerability_alerts" "drum_machine_rb" {
  enabled    = false
  repository = "drum-machine-rb"
}

