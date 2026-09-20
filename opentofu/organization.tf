import {
  to = github_actions_organization_permissions.org
  id = "ruby-gtk-project"
}

resource "github_actions_organization_permissions" "org" {
  allowed_actions      = "all"
  enabled_repositories = "all"
  sha_pinning_required = false
}

import {
  to = github_actions_organization_workflow_permissions.org
  id = "ruby-gtk-project"
}

resource "github_actions_organization_workflow_permissions" "org" {
  can_approve_pull_request_reviews = true
  default_workflow_permissions     = "write"
  organization_slug                = "ruby-gtk-project"
}

import {
  to = github_organization_settings.org
  id = "ruby-gtk-project"
}

resource "github_organization_settings" "org" {
  advanced_security_enabled_for_new_repositories               = false
  billing_email                                                = "nathankidd@hey.com"
  blog                                                         = "www.rubygtk.org"
  company                                                      = ""
  default_repository_permission                                = "read"
  dependabot_alerts_enabled_for_new_repositories               = false
  dependabot_security_updates_enabled_for_new_repositories     = false
  dependency_graph_enabled_for_new_repositories                = false
  description                                                  = "Unofficial project to show the power of ruby for GTK applications."
  email                                                        = ""
  has_organization_projects                                    = true
  has_repository_projects                                      = true
  location                                                     = "United Kingdom"
  members_can_create_internal_repositories                     = false
  members_can_create_pages                                     = true
  members_can_create_private_pages                             = true
  members_can_create_private_repositories                      = true
  members_can_create_public_pages                              = true
  members_can_create_public_repositories                       = true
  members_can_create_repositories                              = true
  members_can_fork_private_repositories                        = false
  name                                                         = "The Ruby GTK Project"
  secret_scanning_enabled_for_new_repositories                 = false
  secret_scanning_push_protection_enabled_for_new_repositories = false
  twitter_username                                             = ""
  web_commit_signoff_required                                  = false
}

