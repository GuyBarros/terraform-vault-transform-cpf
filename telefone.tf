resource "vault_transform_template" "telefone-template" {
  path     = vault_mount.transform.path
  name     = "brazilian_telefone"
  type     = "regex"
  pattern  = "^\\+?(\\d{0,3})[ \\.-]?\\(?(\\d{2})\\)?[ \\.-]?(\\d{4,5})[ \\.-]?(\\d{4})$"
  alphabet = "builtin/numeric"
}

#FPE Encode
resource "vault_transform_transformation" "telefone-fpe" {
  path             = vault_mount.transform.path
  name             = "fpe_telefone"
  type             = "fpe"
  template         = vault_transform_template.telefone-template.name
  tweak_source     = "internal"
  allowed_roles    = ["*"]
  deletion_allowed = true
}

#Masking
resource "vault_transform_transformation" "telefone-masking" {
  path              = vault_mount.transform.path
  name              = "masking_telefone"
  type              = "masking"
  masking_character = "#"
  template          = vault_transform_template.telefone-template.name
  tweak_source      = "internal"
  allowed_roles     = ["*"]
  deletion_allowed  = true
}

#Tokenization
resource "vault_transform_transformation" "telefone-tokenization" {
  path             = vault_mount.transform.path
  name             = "tokenization_telefone"
  type             = "tokenization"
  tweak_source     = "internal"
  allowed_roles    = ["*"]
  deletion_allowed = true
}

data "vault_transform_encode" "telefone-test" {
  path      = vault_transform_role.role.path
  role_name = vault_transform_role.role.name

  batch_input = [{ "value" : "(11) 98765-4321", "transformation" : vault_transform_transformation.telefone-fpe.name },
    { "value" : "(11) 98765-4321", "transformation" : vault_transform_transformation.telefone-masking.name },
    { "value" : "(11) 98765-4321", "transformation" : vault_transform_transformation.telefone-tokenization.name }
  ]
}