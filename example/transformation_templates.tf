resource "vault_transform_template" "cnpj-template" {
  path     = vault_mount.transform.path
  name     = "brazilian_cnpj"
  type     = "regex"
  pattern  = "(\\d{2})\\.(\\d{3})\\.(\\d{3})\\/(\\d{4})-(\\d{2})"
  alphabet = "builtin/numeric"
}

resource "vault_transform_template" "cpf-template" {
  path     = vault_mount.transform.path
  name     = "brazilian_cpf"
  type     = "regex"
  pattern  = "(\\d{3}).(\\d{3}).(\\d{3})-(\\d{2})"
  alphabet = "builtin/numeric"
}

resource "vault_transform_template" "cpf-mask-first9" {
  path     = vault_mount.transform.path
  name     = "cpf-mask-first9"
  type     = "regex"
  pattern  = "(\\d{3}).(\\d{3}).(\\d{3})-(?:\\d{2})"
  alphabet = "builtin/numeric"
}

resource "vault_transform_template" "cnpj-mask-middle10" {
  path     = vault_mount.transform.path
  name     = "cnpj-mask-middle10"
  type     = "regex"
  pattern  = "(?:\\d{2})\\.(\\d{3})\\.(\\d{3})\\/(\\d{4})-(?:\\d{2})"
  alphabet = "builtin/numeric"
}

# resource "vault_transform_template" "email-template" {
#   path     = vault_mount.transform.path
#   name     = "email"
#   type     = "regex"
#   pattern  = "^([A-Za-z0-9._%+\\-&]+)@([A-Za-z0-9._%+\\-&]+)$"
#   alphabet = vault_transform_alphabet.general_email_alphabet.name
# }