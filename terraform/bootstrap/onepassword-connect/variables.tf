variable "onepassword" {
  description = "1Password connection details"
  type = object({
    connect_credentials = string
    operator_token = string
  })
  sensitive = true
}
