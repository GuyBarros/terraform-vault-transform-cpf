resource "vault_transform_transformation" "cpf_partial_masking" {
  path              = vault_mount.transform.path
  name              = "cpf_partial_masking"
  type              = "masking"
  masking_character = "#"
  template          = vault_transform_template.cpf-mask-first9.name
  allowed_roles     = ["*"]
  deletion_allowed  = true
}

resource "vault_transform_transformation" "cnpj_partial_masking" {
  path              = vault_mount.transform.path
  name              = "cnpj_partial_masking"
  type              = "masking"
  masking_character = "#"
  template          = vault_transform_template.cnpj-mask-middle10.name
  allowed_roles     = ["*"]
  deletion_allowed  = true
}