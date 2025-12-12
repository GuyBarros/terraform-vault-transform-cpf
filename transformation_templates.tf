
resource "vault_transform_template" "cnpj-template" {
  path     = vault_mount.transform.path
  name     = "brazilian_cnpj"
  type     = "regex"
  pattern  = "(^.{2})\\.?(.{3})\\.?(.{3})[/\\.-]?(.{4})[-\\./]?(.{2}$)"
  alphabet = "builtin/numeric"
}

resource "vault_transform_template" "cpf-template" {
  path     = vault_mount.transform.path
  name     = "brazilian_cpf"
  type     = "regex"
  pattern  = "(^.{3})\\.?(.{3})\\.?(.{3})[-\\./]?(.{2}$)"
  alphabet = "builtin/numeric"
}

resource "vault_transform_template" "cpf-mask-first9" {
  path     = vault_mount.transform.path
  name     = "cpf-mask-first9"
  type     = "regex"
  pattern  = "(^.{2})\\.?(.{3})\\.?(.{3})[/\\.-]?(.{4})[-\\./]?.{2}$"
  alphabet = "builtin/numeric"
}

resource "vault_transform_template" "cnpj-mask-middle10" {
  path     = vault_mount.transform.path
  name     = "cnpj-mask-middle10"
  type     = "regex"
  pattern  = "(^.{2})\\.?(.{3})\\.?(.{3})[/\\.-]?(.{4})[-\\./]?(.{2}$)"
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
  pattern  = "(^.*)@.*$"
  alphabet = vault_transform_alphabet.general_email_alphabet.name
}

# e.g. "01/01/2025", "01-01-2025", "01012025"
resource "vault_transform_template" "br_date_mask_full" {
  path       = vault_mount.transform.path
  name       = "date-mask-full"
  type       = "regex"
  pattern    = "(\\d{2})[\\./-]?(\\d{2})[\\./-]?(\\d{4})"
  alphabet   = "builtin/numeric"
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
  path     = vault_mount.transform.path
  name     = "bank-account"
  type     = "regex"
  pattern  = "^(\\d{5,8})[ \\-\\/\\.]?(\\d)$"
  alphabet = "builtin/numeric"
}

# ---- BANK AGENCY: 4 digits — mask first 2, keep last 2
# e.g. "1350" -> "**50"
resource "vault_transform_template" "bank_agency" {
  path     = vault_mount.transform.path
  name     = "bank-agency"
  type     = "regex"
  pattern  = "(\\d{2})(?:\\d{2})"
  alphabet = "builtin/numeric"
}

resource "vault_transform_template" "rg-template" {
  path     = vault_mount.transform.path
  name     = "rg"
  type     = "regex"
  pattern  = "(^\\d{1,3})\\.?(\\d{3})\\.?(\\d{3})[-\\./]?.{0,3}$"
  alphabet = "builtin/numeric"
}

resource "vault_transform_template" "cnh-template" {
  path     = vault_mount.transform.path
  name     = "cnh"
  type     = "regex"
  pattern  = "(^\\d{0,3})\\.?(\\d{0,3})\\.?(\\d{0,3})[-\\./]?(\\d{0,3}$)"
  alphabet = "builtin/numeric"
}