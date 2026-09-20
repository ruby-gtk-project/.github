import {
  to = github_repository.junction_rb
  id = "Junction-rb"
}

resource "github_repository" "junction_rb" {
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
  description                 = "Application/browser chooser"
  etag                        = "W/\"d95f769e0bbe830a2c815082d4809afed22f984c83b5a0c9f0c35c4ff04a5116\""
  fork                        = "true"
  gitignore_template          = null
  has_discussions             = false
  has_issues                  = true
  has_projects                = true
  has_wiki                    = false
  homepage_url                = "https://flathub.org/apps/re.sonny.Junction"
  is_template                 = false
  license_template            = null
  merge_commit_message        = "PR_TITLE"
  merge_commit_title          = "MERGE_MESSAGE"
  name                        = "Junction-rb"
  source_owner                = "sonnyp"
  source_repo                 = "Junction"
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
  to = github_actions_repository_permissions.junction_rb
  id = "Junction-rb"
}

resource "github_actions_repository_permissions" "junction_rb" {
  allowed_actions      = "all"
  enabled              = true
  repository           = "Junction-rb"
  sha_pinning_required = false
}

import {
  to = github_repository_dependabot_security_updates.junction_rb
  id = "Junction-rb"
}

resource "github_repository_dependabot_security_updates" "junction_rb" {
  enabled    = false
  repository = "Junction-rb"
}

import {
  to = github_repository_collaborators.junction_rb
  id = "Junction-rb"
}

resource "github_repository_collaborators" "junction_rb" {
  repository = "Junction-rb"
}

import {
  to = github_issue_labels.junction_rb
  id = "Junction-rb"
}

resource "github_issue_labels" "junction_rb" {
  repository = "Junction-rb"
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
  to = github_repository_vulnerability_alerts.junction_rb
  id = "Junction-rb"
}

resource "github_repository_vulnerability_alerts" "junction_rb" {
  enabled    = false
  repository = "Junction-rb"
}

import {
  to = github_branch_default.junction_rb
  id = "Junction-rb"
}

resource "github_branch_default" "junction_rb" {
  branch          = "ruby"
  etag            = "W/\"61b1f2c0be5a8f097e752f190dca8844f43be2a9067d435636fe2aa760b2c044\""
  rename          = null
  repository      = "Junction-rb"
  wait_for_rename = null
}

import {
  to = github_workflow_repository_permissions.junction_rb
  id = "Junction-rb"
}

resource "github_workflow_repository_permissions" "junction_rb" {
  can_approve_pull_request_reviews = true
  default_workflow_permissions     = "write"
  repository                       = "Junction-rb"
}

import {
  to = github_repository_topics.junction_rb
  id = "Junction-rb"
}

resource "github_repository_topics" "junction_rb" {
  repository = "Junction-rb"
  topics     = []
}

