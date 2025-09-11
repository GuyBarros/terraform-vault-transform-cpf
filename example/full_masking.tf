#Masking
resource "vault_transform_transformation" "cpf_full_masking" {
  path              = vault_mount.transform.path
  name              = "cpf_full_masking"
  type              = "masking"
  masking_character = "#"
  template          = vault_transform_template.cpf-template.name
  tweak_source      = "internal"
  allowed_roles     = ["*"]
  deletion_allowed  = true
}

resource "vault_transform_transformation" "cnpj_full_masking" {
  path              = vault_mount.transform.path
  name              = "cnpj_full_masking"
  type              = "masking"
  masking_character = "#"
  template          = vault_transform_template.cnpj-template.name
  tweak_source      = "internal"
  allowed_roles     = ["*"]
  deletion_allowed  = true
}
