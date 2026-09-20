import {
  to = github_branch_default.graphs_rb
  id = "Graphs-rb"
}

resource "github_branch_default" "graphs_rb" {
  branch          = "ruby"
  etag            = "W/\"01617b6d495cbe1d174cba07c686e9daf8b315eb5c818ad7f36658fac31538be\""
  rename          = null
  repository      = "Graphs-rb"
  wait_for_rename = null
}

import {
  to = github_repository_collaborators.graphs_rb
  id = "Graphs-rb"
}

resource "github_repository_collaborators" "graphs_rb" {
  repository = "Graphs-rb"
}

import {
  to = github_repository.graphs_rb
  id = "Graphs-rb"
}

resource "github_repository" "graphs_rb" {
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
  description                 = "This is the official mirror repository to Graphs, the source repository is now hosted on the GNOME GitLab here: https://gitlab.gnome.org/World/Graphs"
  etag                        = "W/\"01617b6d495cbe1d174cba07c686e9daf8b315eb5c818ad7f36658fac31538be\""
  fork                        = "true"
  gitignore_template          = null
  has_discussions             = false
  has_issues                  = true
  has_projects                = true
  has_wiki                    = false
  homepage_url                = "https://graphs.sjoerd.se/"
  is_template                 = false
  license_template            = null
  merge_commit_message        = "PR_TITLE"
  merge_commit_title          = "MERGE_MESSAGE"
  name                        = "Graphs-rb"
  source_owner                = "sstendahl"
  source_repo                 = "Graphs"
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
  to = github_workflow_repository_permissions.graphs_rb
  id = "Graphs-rb"
}

resource "github_workflow_repository_permissions" "graphs_rb" {
  can_approve_pull_request_reviews = true
  default_workflow_permissions     = "write"
  repository                       = "Graphs-rb"
}

import {
  to = github_issue_labels.graphs_rb
  id = "Graphs-rb"
}

resource "github_issue_labels" "graphs_rb" {
  repository = "Graphs-rb"
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
  to = github_repository_topics.graphs_rb
  id = "Graphs-rb"
}

resource "github_repository_topics" "graphs_rb" {
  repository = "Graphs-rb"
  topics     = []
}

import {
  to = github_repository_dependabot_security_updates.graphs_rb
  id = "Graphs-rb"
}

resource "github_repository_dependabot_security_updates" "graphs_rb" {
  enabled    = false
  repository = "Graphs-rb"
}

import {
  to = github_actions_repository_permissions.graphs_rb
  id = "Graphs-rb"
}

resource "github_actions_repository_permissions" "graphs_rb" {
  allowed_actions      = "all"
  enabled              = true
  repository           = "Graphs-rb"
  sha_pinning_required = false
}

import {
  to = github_repository_vulnerability_alerts.graphs_rb
  id = "Graphs-rb"
}

resource "github_repository_vulnerability_alerts" "graphs_rb" {
  enabled    = false
  repository = "Graphs-rb"
}

