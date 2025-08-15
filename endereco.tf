resource "vault_transform_template" "endereco-template" {
  path     = vault_mount.transform.path
  name     = "brazilian_endereco"
  type     = "regex"
  pattern  = "^([A-Za-zÀ-ÖØ-öø-ÿ0-9 ,\\-\\/º;%]+)$"
  alphabet = vault_transform_alphabet.complete_brazil_alphabet.name
}

#FPE Encode
resource "vault_transform_transformation" "endereco-fpe" {
  path             = vault_mount.transform.path
  name             = "fpe_endereco"
  type             = "fpe"
  template         = vault_transform_template.endereco-template.name
  tweak_source     = "internal"
  allowed_roles    = ["*"]
  deletion_allowed = true
}

#Masking
resource "vault_transform_transformation" "endereco-masking" {
  path              = vault_mount.transform.path
  name              = "masking_endereco"
  type              = "masking"
  masking_character = "#"
  template          = vault_transform_template.endereco-template.name
  tweak_source      = "internal"
  allowed_roles     = ["*"]
  deletion_allowed  = true
}

#Tokenization
resource "vault_transform_transformation" "endereco-tokenization" {
  path             = vault_mount.transform.path
  name             = "tokenization_endereco"
  type             = "tokenization"
  tweak_source     = "internal"
  allowed_roles    = ["*"]
  deletion_allowed = true
}

data "vault_transform_encode" "endereco-test" {
  path      = vault_transform_role.role.path
  role_name = vault_transform_role.role.name

  batch_input = [{ "value" : "Rua das Flores, nº 100, Bairro Centro, São Paulo/SP", "transformation" : vault_transform_transformation.endereco-fpe.name },
    { "value" : "Rua das Flores, nº 100, Bairro Centro, São Paulo/SP", "transformation" : vault_transform_transformation.endereco-masking.name },
    { "value" : "Rua das Flores, nº 100, Bairro Centro, São Paulo/SP", "transformation" : vault_transform_transformation.endereco-tokenization.name }
  ]
}