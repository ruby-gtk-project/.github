terraform {
  required_providers {
    github = {
      source = "integrations/github"
    }
  }
}

provider "github" {
  owner = "ruby-gtk-project"
}
