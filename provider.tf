terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
    argocd = {
      source  = "oboukili/argocd"
      version = "~> 6.1.1"
    }
  }
}


provider "argocd" {
}

# Configure the GitHub Provider
provider "github" {
  token = "some pat" # or use `GITHUB_TOKEN` as an env var
}

