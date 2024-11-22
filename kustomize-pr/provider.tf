terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

# Configure the GitHub Provider
provider "github" {
  #token = "ghp_somepat" # preferably, use `GITHUB_TOKEN` as an env var
}

