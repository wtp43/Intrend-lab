resource "helm_release" "onepassword-connect" {
  name = "onepassword-connect"
  repository = "https://1password.github.io/connect-helm-charts/"
  chart = "connect"
  version = "1.16.0"
  set_sensitive {
    name = "connect.credentials_base64"
    type = "string"
    value = var.onepassword.connect_credentials
  }
  set_sensitive {
    name = "operator.token.value"
    type = "string"
    value = var.onepassword.operator_token
  }
  # Deploy the Kubernetes Operator alongside the Connect Server
  set {
    name = "operator.create"
    value = true
  }
}

