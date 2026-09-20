import {
  to = github_branch_default.workbench_demos
  id = "workbench-demos"
}

resource "github_branch_default" "workbench_demos" {
  branch          = "ruby"
  etag            = "W/\"b91018e3baac8430125c87af516a25a93515b71a74cbd5c99dac535b30660468\""
  rename          = null
  repository      = "workbench-demos"
  wait_for_rename = null
}

import {
  to = github_actions_repository_permissions.workbench_demos
  id = "workbench-demos"
}

resource "github_actions_repository_permissions" "workbench_demos" {
  allowed_actions      = "all"
  enabled              = true
  repository           = "workbench-demos"
  sha_pinning_required = false
}

import {
  to = github_repository.workbench_demos
  id = "workbench-demos"
}

resource "github_repository" "workbench_demos" {
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
  description                 = "Demos of GNOME technologies - GTK, libadwaita, CSS, portals, ..."
  etag                        = "W/\"b91018e3baac8430125c87af516a25a93515b71a74cbd5c99dac535b30660468\""
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
  name                        = "workbench-demos"
  source_owner                = "workbenchdev"
  source_repo                 = "demos"
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
  to = github_repository_vulnerability_alerts.workbench_demos
  id = "workbench-demos"
}

resource "github_repository_vulnerability_alerts" "workbench_demos" {
  enabled    = false
  repository = "workbench-demos"
}

import {
  to = github_repository_topics.workbench_demos
  id = "workbench-demos"
}

resource "github_repository_topics" "workbench_demos" {
  repository = "workbench-demos"
  topics     = []
}

import {
  to = github_repository_collaborators.workbench_demos
  id = "workbench-demos"
}

resource "github_repository_collaborators" "workbench_demos" {
  repository = "workbench-demos"
}

import {
  to = github_workflow_repository_permissions.workbench_demos
  id = "workbench-demos"
}

resource "github_workflow_repository_permissions" "workbench_demos" {
  can_approve_pull_request_reviews = true
  default_workflow_permissions     = "write"
  repository                       = "workbench-demos"
}

import {
  to = github_repository_dependabot_security_updates.workbench_demos
  id = "workbench-demos"
}

resource "github_repository_dependabot_security_updates" "workbench_demos" {
  enabled    = false
  repository = "workbench-demos"
}

import {
  to = github_issue_labels.workbench_demos
  id = "workbench-demos"
}

resource "github_issue_labels" "workbench_demos" {
  repository = "workbench-demos"
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

