locals {
  helm_values = {
    foo = "bar"
    bla = {
      one   = "dddddd"
      two   = "adddddfsdfaa"
      three = "sdfffffs"
      four  = "fff"
      five  = "ffffff"
    }
  }
}

resource "github_branch" "pr" {
  repository = "tf-test"
  branch     = "terraform-branch-${substr(sha256(jsonencode(local.helm_values)), 0, 7)}"
}

resource "github_repository_file" "helm-values-example" {
  repository          = "tf-test"
  branch              = github_branch.pr.branch
  file                = "main/values.yaml"
  content             = yamlencode(local.helm_values)
  commit_message      = "Managed by Terraform"
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

resource "github_repository_pull_request" "helm-example-pr" {
  base_repository = github_repository_file.helm-values-example.repository
  base_ref        = "main"
  head_ref        = github_repository_file.helm-values-example.branch
  title           = "My newest feature"
  body            = "This will change everything"
}

