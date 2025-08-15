resource "vault_transform_template" "cartao_credito-template" {
  path     = vault_mount.transform.path
  name     = "brazilian_cartao_credito"
  type     = "regex"
  pattern  = "(\\d{4})[ ]?(\\d{4})[ ]?(\\d{4})[ ]?(\\d{4})"
  alphabet = "builtin/numeric"
}

#FPE Encode
resource "vault_transform_transformation" "cartao_credito-fpe" {
  path             = vault_mount.transform.path
  name             = "fpe_cartao_credito"
  type             = "fpe"
  template         = vault_transform_template.cartao_credito-template.name
  tweak_source     = "internal"
  allowed_roles    = ["*"]
  deletion_allowed = true
}

#Masking
resource "vault_transform_transformation" "cartao_credito-masking" {
  path              = vault_mount.transform.path
  name              = "masking_cartao_credito"
  type              = "masking"
  masking_character = "#"
  template          = vault_transform_template.cartao_credito-template.name
  tweak_source      = "internal"
  allowed_roles     = ["*"]
  deletion_allowed  = true
}

#Tokenization
resource "vault_transform_transformation" "cartao_credito-tokenization" {
  path             = vault_mount.transform.path
  name             = "tokenization_cartao_credito"
  type             = "tokenization"
  tweak_source     = "internal"
  allowed_roles    = ["*"]
  deletion_allowed = true
}

data "vault_transform_encode" "cartao_credito-test" {
  path      = vault_transform_role.role.path
  role_name = vault_transform_role.role.name

  batch_input = [{ "value" : "4213 1239 1239 1293", "transformation" : vault_transform_transformation.cartao_credito-fpe.name },
    { "value" : "4213 1239 1239 1293", "transformation" : vault_transform_transformation.cartao_credito-masking.name },
    { "value" : "4213 1239 1239 1293", "transformation" : vault_transform_transformation.cartao_credito-tokenization.name }
  ]
}