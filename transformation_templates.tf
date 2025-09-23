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


resource "vault_transform_alphabet" "general_email_alphabet" {
  path     = vault_mount.transform.path
  name     = "general_email_alphabet"
  alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789._%+-&"
}

resource "vault_transform_template" "email-template" {
  path     = vault_mount.transform.path
  name     = "email"
  type     = "regex"
  pattern  = "^([A-Za-z0-9._%+\\-&]+)@([A-Za-z0-9._%+\\-&]+)$"
  alphabet = vault_transform_alphabet.general_email_alphabet.name
}



resource "vault_transform_template" "br_date_mask_full" {
  path    = vault_mount.transform.path
  name    = "date-mask-full"
  type    = "regex"
  pattern = "(\\d{2})/(\\d{2})/(\\d{4})"
  alphabet = "builtin/numeric"
  depends_on = [vault_mount.transform]
}

resource "vault_transform_template" "telefone-template" {
  path     = vault_mount.transform.path
  name     = "brazilian_telefone"
  type     = "regex"
  pattern  = "^\\+?(\\d{0,3})[ \\.-]?\\(?(\\d{2})\\)?[ \\.-]?(\\d{4,5})[ \\.-]?(\\d{4})$"
  alphabet = "builtin/numeric"
}


# ---- BANK ACCOUNT NUMBER: 8 digits + optional dash — mask first 6, keep last 2
# e.g. "00345678-" -> "******78-"
resource "vault_transform_template" "bank_acct_mask_first6" {
  path    = vault_mount.transform.path
  name    = "bank-account"
  type    = "regex"
  pattern = "(\\d{6})(?:-?)(?:\\d{1})"
  alphabet = "builtin/numeric"
}

# ---- BANK AGENCY: 4 digits — mask first 2, keep last 2
# e.g. "1350" -> "**50"
resource "vault_transform_template" "bank_agency" {
  path    = vault_mount.transform.path
  name    = "bank-agency"
  type    = "regex"
  pattern = "(\\d{2})(?:\\d{2})"
  alphabet = "builtin/numeric"
}

