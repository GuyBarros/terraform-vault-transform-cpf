resource "vault_transform_template" "nome-template" {
  path     = vault_mount.transform.path
  name     = "brazilian_nome"
  type     = "regex"
  pattern  = "^([A-Za-zÀ-ÖØ-öø-ÿ]+(?:[-' ][A-Za-zÀ-ÖØ-öø-ÿ]+)*)$"
  # alphabet = "nome"
  alphabet = vault_transform_alphabet.basic_brazil_alphabet.name
}

#FPE Encode
resource "vault_transform_transformation" "nome-fpe" {
  path             = vault_mount.transform.path
  name             = "fpe_nome"
  type             = "fpe"
  template         = vault_transform_template.nome-template.name
  tweak_source     = "internal"
  allowed_roles    = ["*"]
  deletion_allowed = true
}

#Masking
resource "vault_transform_transformation" "nome-masking" {
  path              = vault_mount.transform.path
  name              = "masking_nome"
  type              = "masking"
  masking_character = "#"
  template          = vault_transform_template.nome-template.name
  tweak_source      = "internal"
  allowed_roles     = ["*"]
  deletion_allowed  = true
}

#Tokenization
resource "vault_transform_transformation" "nome-tokenization" {
  path             = vault_mount.transform.path
  name             = "tokenization_nome"
  type             = "tokenization"
  tweak_source     = "internal"
  allowed_roles    = ["*"]
  deletion_allowed = true
}

data "vault_transform_encode" "nome-test" {
  path      = vault_transform_role.role.path
  role_name = vault_transform_role.role.name

  batch_input = [{ "value" : "João da Silva", "transformation" : vault_transform_transformation.nome-fpe.name },
    { "value" : "João da Silva", "transformation" : vault_transform_transformation.nome-masking.name },
    { "value" : "João da Silva", "transformation" : vault_transform_transformation.nome-tokenization.name }
  ]
}

