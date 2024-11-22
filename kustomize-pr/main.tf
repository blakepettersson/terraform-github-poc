locals {
  some_env_var = "foo"
  some_other_env_var = "bar"
  kustomize = {
    resources : ["../../base"]
    namePrefix : "staging-"
    configMapGenerator : [
      {
        name : "special-config-2"
        literals : [
          "ENV_VAR_ONE=${local.some_env_var}",
          "ENV_VAR_TWO=${local.some_other_env_var}"
        ]
      }
    ]
  }
}

resource "github_branch" "pr" {
  repository = "tf-test"
  branch     = "terraform-branch-${substr(sha256(jsonencode(local.kustomize)), 0, 7)}"
}

resource "github_repository_file" "kustomize-example" {
  repository          = "tf-test"
  branch              = github_branch.pr.branch
  file                = "kustomize/overlays/dev/kustomization.yaml"
  content             = yamlencode(local.kustomize)
  commit_message      = "Managed by Terraform"
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

resource "github_repository_pull_request" "helm-example-pr" {
  base_repository = github_repository_file.kustomize-example.repository
  base_ref        = "main"
  head_ref        = github_repository_file.kustomize-example.branch
  title           = "My newest feature"
  body            = "This will change everything"
}

