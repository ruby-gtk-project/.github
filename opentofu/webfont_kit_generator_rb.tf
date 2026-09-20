import {
  to = github_repository_topics.webfont_kit_generator_rb
  id = "webfont-kit-generator-rb"
}

resource "github_repository_topics" "webfont_kit_generator_rb" {
  repository = "webfont-kit-generator-rb"
  topics     = []
}

import {
  to = github_repository_collaborators.webfont_kit_generator_rb
  id = "webfont-kit-generator-rb"
}

resource "github_repository_collaborators" "webfont_kit_generator_rb" {
  repository = "webfont-kit-generator-rb"
}

import {
  to = github_issue_labels.webfont_kit_generator_rb
  id = "webfont-kit-generator-rb"
}

resource "github_issue_labels" "webfont_kit_generator_rb" {
  repository = "webfont-kit-generator-rb"
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
  to = github_repository_dependabot_security_updates.webfont_kit_generator_rb
  id = "webfont-kit-generator-rb"
}

resource "github_repository_dependabot_security_updates" "webfont_kit_generator_rb" {
  enabled    = false
  repository = "webfont-kit-generator-rb"
}

import {
  to = github_branch_default.webfont_kit_generator_rb
  id = "webfont-kit-generator-rb"
}

resource "github_branch_default" "webfont_kit_generator_rb" {
  branch          = "ruby"
  etag            = "W/\"785eccfa3655746cbd1f725de20e339e7a9c493c9ebc5ff1472e273f8adc0a28\""
  rename          = null
  repository      = "webfont-kit-generator-rb"
  wait_for_rename = null
}

import {
  to = github_actions_repository_permissions.webfont_kit_generator_rb
  id = "webfont-kit-generator-rb"
}

resource "github_actions_repository_permissions" "webfont_kit_generator_rb" {
  allowed_actions      = "all"
  enabled              = true
  repository           = "webfont-kit-generator-rb"
  sha_pinning_required = false
}

import {
  to = github_repository_vulnerability_alerts.webfont_kit_generator_rb
  id = "webfont-kit-generator-rb"
}

resource "github_repository_vulnerability_alerts" "webfont_kit_generator_rb" {
  enabled    = false
  repository = "webfont-kit-generator-rb"
}

import {
  to = github_workflow_repository_permissions.webfont_kit_generator_rb
  id = "webfont-kit-generator-rb"
}

resource "github_workflow_repository_permissions" "webfont_kit_generator_rb" {
  can_approve_pull_request_reviews = true
  default_workflow_permissions     = "write"
  repository                       = "webfont-kit-generator-rb"
}

import {
  to = github_repository.webfont_kit_generator_rb
  id = "webfont-kit-generator-rb"
}

resource "github_repository" "webfont_kit_generator_rb" {
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
  description                 = "Create @ font-face kits easily"
  etag                        = "W/\"28cc9e0ba699376b74f2da67ddd3b809e85220f41c10dd48c2a874a688def2e5\""
  fork                        = "true"
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
  name                        = "webfont-kit-generator-rb"
  source_owner                = "rafaelmardojai"
  source_repo                 = "webfont-kit-generator"
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

