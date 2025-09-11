resource "vault_transform_transformation" "tokenization_non_convergent" {
  path             = vault_mount.transform.path
  name             = "tokenization_non_convergent"
  type             = "tokenization"
  tweak_source     = "internal"
  allowed_roles    = ["*"]
  deletion_allowed = true
}
