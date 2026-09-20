import {
  to = github_repository_dependabot_security_updates.gnome_podcasts_rb
  id = "gnome-podcasts-rb"
}

resource "github_repository_dependabot_security_updates" "gnome_podcasts_rb" {
  enabled    = false
  repository = "gnome-podcasts-rb"
}

import {
  to = github_repository.gnome_podcasts_rb
  id = "gnome-podcasts-rb"
}

resource "github_repository" "gnome_podcasts_rb" {
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
  description                 = "Main repository is over at the GNOME gitlab instance"
  etag                        = "W/\"c96c11283a1b7b03e1b3d83fdac6c8b2eebb20346fb277be815ead164e86a802\""
  fork                        = "true"
  gitignore_template          = null
  has_discussions             = false
  has_issues                  = true
  has_projects                = true
  has_wiki                    = false
  homepage_url                = "https://gitlab.gnome.org/World/Podcasts"
  is_template                 = false
  license_template            = null
  merge_commit_message        = "PR_TITLE"
  merge_commit_title          = "MERGE_MESSAGE"
  name                        = "gnome-podcasts-rb"
  source_owner                = "alatiera"
  source_repo                 = "gnome-podcasts"
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
  to = github_repository_topics.gnome_podcasts_rb
  id = "gnome-podcasts-rb"
}

resource "github_repository_topics" "gnome_podcasts_rb" {
  repository = "gnome-podcasts-rb"
  topics     = []
}

import {
  to = github_repository_collaborators.gnome_podcasts_rb
  id = "gnome-podcasts-rb"
}

resource "github_repository_collaborators" "gnome_podcasts_rb" {
  repository = "gnome-podcasts-rb"
}

import {
  to = github_branch_default.gnome_podcasts_rb
  id = "gnome-podcasts-rb"
}

resource "github_branch_default" "gnome_podcasts_rb" {
  branch          = "ruby"
  etag            = "W/\"e699b7842e33b04ecf4221cb8fdc91596bdbad3ada0c7beb361f0ed668d4c053\""
  rename          = null
  repository      = "gnome-podcasts-rb"
  wait_for_rename = null
}

import {
  to = github_issue_labels.gnome_podcasts_rb
  id = "gnome-podcasts-rb"
}

resource "github_issue_labels" "gnome_podcasts_rb" {
  repository = "gnome-podcasts-rb"
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
  to = github_actions_repository_permissions.gnome_podcasts_rb
  id = "gnome-podcasts-rb"
}

resource "github_actions_repository_permissions" "gnome_podcasts_rb" {
  allowed_actions      = "all"
  enabled              = true
  repository           = "gnome-podcasts-rb"
  sha_pinning_required = false
}

import {
  to = github_repository_vulnerability_alerts.gnome_podcasts_rb
  id = "gnome-podcasts-rb"
}

resource "github_repository_vulnerability_alerts" "gnome_podcasts_rb" {
  enabled    = false
  repository = "gnome-podcasts-rb"
}

import {
  to = github_workflow_repository_permissions.gnome_podcasts_rb
  id = "gnome-podcasts-rb"
}

resource "github_workflow_repository_permissions" "gnome_podcasts_rb" {
  can_approve_pull_request_reviews = true
  default_workflow_permissions     = "write"
  repository                       = "gnome-podcasts-rb"
}

