resource "vault_transform_transformation" "tokenization_convergent" {
  path             = vault_mount.transform.path
  name             = "tokenization_convergent"
  type             = "tokenization"
tweak_source     = "convergent"
  deletion_allowed = true
}
