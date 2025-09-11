resource "vault_transform_transformation" "cpf_fpe_non_deterministic" {
  path             = vault_mount.transform.path
  name             = "cpf_fpe_non_deterministic"
  type             = "fpe"
  template         = vault_transform_template.cpf-template.name
  tweak_source     = "generated"
  allowed_roles    = ["*"]
  deletion_allowed = true
}

#FPE Encode
resource "vault_transform_transformation" "cnpj_fpe_non_deterministic" {
  path             = vault_mount.transform.path
  name             = "cnpj_fpe_non_deterministic"
  type             = "fpe"
  template         = vault_transform_template.cnpj-template.name
  tweak_source     = "generated"
  allowed_roles    = ["*"]
  deletion_allowed = true
}
