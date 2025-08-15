resource "vault_transform_template" "cpf-template" {
  path     = vault_mount.transform.path
  name     = "brazilian_cpf"
  type     = "regex"
  pattern  = "(\\d{3}).(\\d{3}).(\\d{3})-(\\d{2})"
  alphabet = "builtin/numeric"
}

#FPE Encode
resource "vault_transform_transformation" "cpf-fpe" {
  path             = vault_mount.transform.path
  name             = "fpe_cpf"
  type             = "fpe"
  template         = vault_transform_template.cpf-template.name
  tweak_source     = "internal"
  allowed_roles    = ["*"]
  deletion_allowed = true
}

#Masking
resource "vault_transform_transformation" "cpf-masking" {
  path              = vault_mount.transform.path
  name              = "masking_cpf"
  type              = "masking"
  masking_character = "#"
  template          = vault_transform_template.cpf-template.name
  tweak_source      = "internal"
  allowed_roles     = ["*"]
  deletion_allowed  = true
}

#Tokenization
resource "vault_transform_transformation" "cpf-tokenization" {
  path             = vault_mount.transform.path
  name             = "tokenization_cpf"
  type             = "tokenization"
  tweak_source     = "internal"
  allowed_roles    = ["*"]
  deletion_allowed = true
}

data "vault_transform_encode" "cpf-test" {
  path      = vault_transform_role.role.path
  role_name = vault_transform_role.role.name

  batch_input = [{ "value" : "123.456.789-09", "transformation" : vault_transform_transformation.cpf-fpe.name },
    { "value" : "123.456.789-09", "transformation" : vault_transform_transformation.cpf-masking.name },
    { "value" : "123.456.789-09", "transformation" : vault_transform_transformation.cpf-tokenization.name }
  ]
}