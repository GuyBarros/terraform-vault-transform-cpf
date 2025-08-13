resource "vault_transform_template" "email-template" {
  path     = vault_mount.transform.path
  name     = "email"
  type     = "regex"
  pattern  = "([a-z0-9._%+-]+)@([a-z0-9.-]+\\.[a-z]{2,}(?:\\.[a-z]{2,})?)"
  alphabet = "builtin/alphanumeric-lower"
}

#FPE Encode
resource "vault_transform_transformation" "email-fpe" {
  path             = vault_mount.transform.path
  name             = "fpe_email"
  type             = "fpe"
  template         = vault_transform_template.email-template.name
  tweak_source     = "internal"
  allowed_roles    = ["*"]
  deletion_allowed = true
}

#Masking
resource "vault_transform_transformation" "email-masking" {
  path              = vault_mount.transform.path
  name              = "masking_email"
  type              = "masking"
  masking_character = "#"
  template          = vault_transform_template.email-template.name
  tweak_source      = "internal"
  allowed_roles     = ["*"]
  deletion_allowed  = true
}

#Tokenization
resource "vault_transform_transformation" "email-tokenization" {
  path             = vault_mount.transform.path
  name             = "transform_email"
  type             = "tokenization"
  tweak_source     = "internal"
  allowed_roles    = ["*"]
  deletion_allowed = true
}

data "vault_transform_encode" "email-test" {
  path      = vault_transform_role.role.path
  role_name = vault_transform_role.role.name

  batch_input = [{ "value" : "this.is.@fake.email", "transformation" : vault_transform_transformation.email-fpe.name },
    { "value" : "test@example.com", "transformation" : vault_transform_transformation.email-masking.name },
    { "value" : "myreal@email.com", "transformation" : vault_transform_transformation.email-tokenization.name }
  ]
}