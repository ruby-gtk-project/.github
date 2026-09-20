import {
  to = github_actions_repository_permissions.paper_clip_rb
  id = "Paper-Clip-rb"
}

resource "github_actions_repository_permissions" "paper_clip_rb" {
  allowed_actions      = "all"
  enabled              = true
  repository           = "Paper-Clip-rb"
  sha_pinning_required = false
}

import {
  to = github_workflow_repository_permissions.paper_clip_rb
  id = "Paper-Clip-rb"
}

resource "github_workflow_repository_permissions" "paper_clip_rb" {
  can_approve_pull_request_reviews = true
  default_workflow_permissions     = "write"
  repository                       = "Paper-Clip-rb"
}

import {
  to = github_repository_topics.paper_clip_rb
  id = "Paper-Clip-rb"
}

resource "github_repository_topics" "paper_clip_rb" {
  repository = "Paper-Clip-rb"
  topics     = []
}

import {
  to = github_repository_vulnerability_alerts.paper_clip_rb
  id = "Paper-Clip-rb"
}

resource "github_repository_vulnerability_alerts" "paper_clip_rb" {
  enabled    = false
  repository = "Paper-Clip-rb"
}

import {
  to = github_repository.paper_clip_rb
  id = "Paper-Clip-rb"
}

resource "github_repository" "paper_clip_rb" {
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
  description                 = "Edit PDF document metadata"
  etag                        = "W/\"18bdb7c1aa35df9a0250d3f6e283ace48fe801034b1ea1ec26528a58387d6bd0\""
  fork                        = "true"
  gitignore_template          = null
  has_discussions             = false
  has_issues                  = true
  has_projects                = true
  has_wiki                    = true
  homepage_url                = "https://apps.gnome.org/app/io.github.diegoivan.pdf_metadata_editor/"
  is_template                 = false
  license_template            = null
  merge_commit_message        = "PR_TITLE"
  merge_commit_title          = "MERGE_MESSAGE"
  name                        = "Paper-Clip-rb"
  source_owner                = "Diego-Ivan"
  source_repo                 = "Paper-Clip"
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
  to = github_branch_default.paper_clip_rb
  id = "Paper-Clip-rb"
}

resource "github_branch_default" "paper_clip_rb" {
  branch          = "ruby"
  etag            = "W/\"6cb752b6ba502919aa3b55c7c366de5abdd5e14f08ef4403dc00a2796629a859\""
  rename          = null
  repository      = "Paper-Clip-rb"
  wait_for_rename = null
}

import {
  to = github_issue_labels.paper_clip_rb
  id = "Paper-Clip-rb"
}

resource "github_issue_labels" "paper_clip_rb" {
  repository = "Paper-Clip-rb"
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
  to = github_repository_dependabot_security_updates.paper_clip_rb
  id = "Paper-Clip-rb"
}

resource "github_repository_dependabot_security_updates" "paper_clip_rb" {
  enabled    = false
  repository = "Paper-Clip-rb"
}

import {
  to = github_repository_collaborators.paper_clip_rb
  id = "Paper-Clip-rb"
}

resource "github_repository_collaborators" "paper_clip_rb" {
  repository = "Paper-Clip-rb"
}

