import {
  to = github_workflow_repository_permissions.boatswain_rb
  id = "Boatswain-rb"
}

resource "github_workflow_repository_permissions" "boatswain_rb" {
  can_approve_pull_request_reviews = true
  default_workflow_permissions     = "write"
  repository                       = "Boatswain-rb"
}

import {
  to = github_repository_vulnerability_alerts.boatswain_rb
  id = "Boatswain-rb"
}

resource "github_repository_vulnerability_alerts" "boatswain_rb" {
  enabled    = true
  repository = "Boatswain-rb"
}

import {
  to = github_repository_collaborators.boatswain_rb
  id = "Boatswain-rb"
}

resource "github_repository_collaborators" "boatswain_rb" {
  repository = "Boatswain-rb"
}

import {
  to = github_repository_topics.boatswain_rb
  id = "Boatswain-rb"
}

resource "github_repository_topics" "boatswain_rb" {
  repository = "Boatswain-rb"
  topics     = []
}

import {
  to = github_issue_labels.boatswain_rb
  id = "Boatswain-rb"
}

resource "github_issue_labels" "boatswain_rb" {
  repository = "Boatswain-rb"
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
  to = github_repository_dependabot_security_updates.boatswain_rb
  id = "Boatswain-rb"
}

resource "github_repository_dependabot_security_updates" "boatswain_rb" {
  enabled    = false
  repository = "Boatswain-rb"
}

import {
  to = github_actions_repository_permissions.boatswain_rb
  id = "Boatswain-rb"
}

resource "github_actions_repository_permissions" "boatswain_rb" {
  allowed_actions      = "all"
  enabled              = true
  repository           = "Boatswain-rb"
  sha_pinning_required = false
}

import {
  to = github_repository.boatswain_rb
  id = "Boatswain-rb"
}

resource "github_repository" "boatswain_rb" {
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
  description                 = "Ruby GTK4 port of Boatswain. Upstream: https://gitlab.gnome.org/World/boatswain"
  etag                        = "W/\"288474cb853feb3692fbb89cbbc1207571c479088c339421a5b9f521758b9ac8\""
  fork                        = "false"
  gitignore_template          = null
  has_discussions             = false
  has_issues                  = true
  has_projects                = true
  has_wiki                    = true
  homepage_url                = ""
  is_template                 = false
  license_template            = null
  merge_commit_message        = "PR_TITLE"
  merge_commit_title          = "MERGE_MESSAGE"
  name                        = "Boatswain-rb"
  source_owner                = ""
  source_repo                 = ""
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
  to = github_branch_default.boatswain_rb
  id = "Boatswain-rb"
}

resource "github_branch_default" "boatswain_rb" {
  branch          = "ruby"
  etag            = "W/\"288474cb853feb3692fbb89cbbc1207571c479088c339421a5b9f521758b9ac8\""
  rename          = null
  repository      = "Boatswain-rb"
  wait_for_rename = null
}

