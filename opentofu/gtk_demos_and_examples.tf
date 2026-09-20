import {
  to = github_workflow_repository_permissions.gtk_demos_and_examples
  id = "gtk-demos-and-examples"
}

resource "github_workflow_repository_permissions" "gtk_demos_and_examples" {
  can_approve_pull_request_reviews = true
  default_workflow_permissions     = "write"
  repository                       = "gtk-demos-and-examples"
}

import {
  to = github_repository.gtk_demos_and_examples
  id = "gtk-demos-and-examples"
}

resource "github_repository" "gtk_demos_and_examples" {
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
  description                 = "A project to port the official GTK demos & examples to ruby."
  etag                        = "W/\"3505d17f1b1282d08105fecc758baf59512ed786a07a70614fbe2837ad6a4359\""
  fork                        = "true"
  gitignore_template          = null
  has_discussions             = false
  has_issues                  = true
  has_projects                = true
  has_wiki                    = false
  homepage_url                = "https://gitlab.gnome.org/GNOME/gtk"
  is_template                 = false
  license_template            = null
  merge_commit_message        = "PR_TITLE"
  merge_commit_title          = "MERGE_MESSAGE"
  name                        = "gtk-demos-and-examples"
  source_owner                = "GNOME"
  source_repo                 = "gtk"
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
  to = github_repository_collaborators.gtk_demos_and_examples
  id = "gtk-demos-and-examples"
}

resource "github_repository_collaborators" "gtk_demos_and_examples" {
  repository = "gtk-demos-and-examples"
}

import {
  to = github_repository_vulnerability_alerts.gtk_demos_and_examples
  id = "gtk-demos-and-examples"
}

resource "github_repository_vulnerability_alerts" "gtk_demos_and_examples" {
  enabled    = false
  repository = "gtk-demos-and-examples"
}

import {
  to = github_actions_repository_permissions.gtk_demos_and_examples
  id = "gtk-demos-and-examples"
}

resource "github_actions_repository_permissions" "gtk_demos_and_examples" {
  allowed_actions      = "all"
  enabled              = true
  repository           = "gtk-demos-and-examples"
  sha_pinning_required = false
}

import {
  to = github_issue_labels.gtk_demos_and_examples
  id = "gtk-demos-and-examples"
}

resource "github_issue_labels" "gtk_demos_and_examples" {
  repository = "gtk-demos-and-examples"
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
  to = github_repository_topics.gtk_demos_and_examples
  id = "gtk-demos-and-examples"
}

resource "github_repository_topics" "gtk_demos_and_examples" {
  repository = "gtk-demos-and-examples"
  topics     = []
}

import {
  to = github_repository_dependabot_security_updates.gtk_demos_and_examples
  id = "gtk-demos-and-examples"
}

resource "github_repository_dependabot_security_updates" "gtk_demos_and_examples" {
  enabled    = false
  repository = "gtk-demos-and-examples"
}

import {
  to = github_branch_default.gtk_demos_and_examples
  id = "gtk-demos-and-examples"
}

resource "github_branch_default" "gtk_demos_and_examples" {
  branch          = "ruby"
  etag            = "W/\"3b6eff606220a49202cbc65643674c2ee96f24c6206bae520631eeb3e913832f\""
  rename          = null
  repository      = "gtk-demos-and-examples"
  wait_for_rename = null
}

