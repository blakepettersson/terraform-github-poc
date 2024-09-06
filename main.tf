locals {
  helm_values = {
    foo = "bar"
    bla = {
      one = "two"
      two = "aaa"
    }
  }
}

# Multiple Application Sources with Helm value files from external Git repository
resource "argocd_application" "multiple_sources" {
  metadata {
    name      = "helm-app-with-external-values"
    namespace = "argocd"
  }

  spec {
    project = "default"

    source {
      repo_url        = "https://charts.helm.sh/stable"
      chart           = "wordpress"
      target_revision = "9.0.3"
      helm {
        value_files = ["$values/${github_repository_file.foo.file}"]
      }
    }

    source {
      repo_url        = github_repository.foo.http_clone_url
      target_revision = "HEAD"
      ref             = "values"
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "default"
    }
  }
}

resource "github_repository" "foo" {
  name      = "tf-test"
  auto_init = true
}

resource "github_repository_file" "foo" {
  repository          = github_repository.foo.name
  branch              = "main"
  file                = "foo/values.yaml"
  content             = yamlencode(local.helm_values)
  commit_message      = "Managed by Terraform"
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}