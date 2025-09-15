data "vault_policy_document" "transform_encode_example" {
  rule {
    path         = "${vault_mount.transform.path}/encode/${vault_transform_role.role.name}"
    capabilities = ["update"]
    description  = "allow all on secrets"
  }

}

resource "vault_policy" "transform_encode" {
  name   = "transform_encode"
  policy = data.vault_policy_document.transform_encode_example.hcl
}