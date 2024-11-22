locals {
  helm_values = {
    foo = "bar"
    bla = {
      one   = "two"
      two   = "aaa"
      three = "bbb"
      four  = "dfsdfd"
      five  = "dfsdf"
    }
  }
}

resource "github_repository_file" "helm-values-example" {
  repository          = "tf-test"
  branch              = "main"
  file                = "main/values.yaml"
  content             = yamlencode(local.helm_values)
  commit_message      = "Managed by Terraform"
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}
