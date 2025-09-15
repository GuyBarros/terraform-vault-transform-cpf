resource "vault_transform_transformation" "cpf_partial_fpe_deterministic" {
  path             = vault_mount.transform.path
  name             = "cpf_partial_fpe_deterministic"
  type             = "fpe"
  template         = vault_transform_template.cpf-mask-first9.name
  tweak_source     = "internal"
  allowed_roles    = ["*"]
  deletion_allowed = true
}

resource "vault_transform_transformation" "cnpj_partial_fpe_deterministic" {
  path             = vault_mount.transform.path
  name             = "cnpj_fpe_deterministic"
  type             = "fpe"
  template         = vault_transform_template.cnpj-mask-middle10.name
  tweak_source     = "internal"
  allowed_roles    = ["*"]
  deletion_allowed = true
}
