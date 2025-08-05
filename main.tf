resource "vault_mount" "transform" {
  path = var.transform_path
  type = "transform"
}

resource "vault_transform_template" "regex-template" {
  path     = vault_mount.transform.path
  name     = var.transformation_template_name
  type     = "regex"
  pattern  = var.template_regex_pattern
  alphabet = "builtin/numeric"
}

#FPE Encode
resource "vault_transform_transformation" "fpe" {
  path             = vault_mount.transform.path
  name             = var.fpe_transformation_name
  type             = "fpe"
  template         = vault_transform_template.regex-template.name
  tweak_source     = "internal"
  allowed_roles    = ["*"]
  deletion_allowed = true
}

#Masking
resource "vault_transform_transformation" "masking" {
  path              = vault_mount.transform.path
  name              = var.masking_transformation_name
  type              = "masking"
  masking_character = "#"
  template          = vault_transform_template.regex-template.name
  tweak_source      = "internal"
  allowed_roles     = ["*"]
  deletion_allowed  = true
}

#Tokenization
resource "vault_transform_transformation" "tokenization" {
  path              = vault_mount.transform.path
  name              = var.tokenization_transformation_name
  type              = "tokenization"
  tweak_source      = "internal"
  allowed_roles     = ["*"]
  deletion_allowed  = true
}

resource "vault_transform_transformation" "tokenization" {
  path              = vault_mount.transform.path
  name              = var.tokenization_transformation_name
  type              = "tokenization"
  tweak_source      = "internal"
  allowed_roles     = ["*"]
  deletion_allowed  = true
}

resource "vault_transform_role" "role" {
  path            = vault_mount.transform.path
  name            = var.transformation_role_name
  transformations = [vault_transform_transformation.fpe.name, vault_transform_transformation.masking.name, vault_transform_transformation.tokenization.name]
}


data "vault_transform_encode" "test" {
  path      = vault_transform_role.role.path
  role_name = vault_transform_role.role.name
  
  batch_input = [{ "value" : "123.456.789-09", "transformation" : vault_transform_transformation.fpe.name },
                 { "value" : "123.456.789-09", "transformation" : vault_transform_transformation.masking.name },
                 { "value" : "123.456.789-09", "transformation" : vault_transform_transformation.tokenization.name }
                 ]
}

