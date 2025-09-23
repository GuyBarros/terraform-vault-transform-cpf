# FPE Parcial Nao Deterministico
resource "vault_transform_transformation" "cpf" {
  path             = vault_mount.transform.path
  name             = "cpf"
  type             = "fpe"
  template         = vault_transform_template.cpf-mask-first9.name
  tweak_source     = "generated"
  allowed_roles    = ["*"]
  deletion_allowed = true
}

# FPE Parcial Deterministico
resource "vault_transform_transformation" "cnpj" {
  path             = vault_mount.transform.path
  name             = "cnpj"
  type             = "fpe"
  template         = vault_transform_template.cnpj-mask-middle10.name
  tweak_source     = "internal"
  allowed_roles    = ["*"]
  deletion_allowed = true
}
# Tokenization Nao Convergente
resource "vault_transform_transformation" "endereco" {
  path             = vault_mount.transform.path
  name             = "endereco"
  type             = "tokenization"
  allowed_roles    = ["*"]
  deletion_allowed = true
}

# FPE Total Nao Deterministico Nao Reversivel
resource "vault_transform_transformation" "email" {
  path             = vault_mount.transform.path
  name             = "email"
  type             = "fpe"
  template         = vault_transform_template.email-template.name
  tweak_source     = "generated"
  allowed_roles    = ["*"]
  deletion_allowed = true
}

# FPE Total Deterministico Nao Reversivel
#FPE Encode
resource "vault_transform_transformation" "telefone" {
  path             = vault_mount.transform.path
  name             = "telefone"
  type             = "fpe"
  template         = vault_transform_template.telefone-template.name
  tweak_source     = "generated"
  allowed_roles    = ["*"]
  deletion_allowed = true
}

# Tokenization Nao Convergente Irreversivel
resource "vault_transform_transformation" "valores" {
  path             = vault_mount.transform.path
  name             = "valores"
  type             = "tokenization"
  allowed_roles    = ["*"]
  deletion_allowed = true
}

# FPE Total Deterministico
resource "vault_transform_transformation" "conta" {
  path             = vault_mount.transform.path
  name             = "conta"
  type             = "fpe"
  template         = vault_transform_template.bank_acct_mask_first6.name
  tweak_source     = "internal"
  allowed_roles    = ["*"]
  deletion_allowed = true
}

# FPE Total Deterministico
resource "vault_transform_transformation" "agencia" {
  path             = vault_mount.transform.path
  name             = "agencia"
  type             = "masking"
  template         = vault_transform_template.bank_agency.name
  tweak_source     = "internal"
  allowed_roles    = ["*"]
  deletion_allowed = true
}

# FPE Total Deterministico
resource "vault_transform_transformation" "data" {
  path             = vault_mount.transform.path
  name             = "data"
  type             = "fpe"
  template         = vault_transform_template.br_date_mask_full.name
  tweak_source     = "internal"
  allowed_roles    = ["*"]
  deletion_allowed = true
}

# Tokenization Nao Convergente Irreversivel
resource "vault_transform_transformation" "contrato" {
  path             = vault_mount.transform.path
  name             = "contrato"
  type             = "tokenization"
  allowed_roles    = ["*"]
  deletion_allowed = true
}

# Tokenization Nao Convergente Irreversivel
resource "vault_transform_transformation" "produto" {
  path             = vault_mount.transform.path
  name             = "produto"
  type             = "tokenization"
  allowed_roles    = ["*"]
  deletion_allowed = true
}

# Tokenization Nao Convergente Irreversivel
resource "vault_transform_transformation" "ticket" {
  path             = vault_mount.transform.path
  name             = "ticket"
  type             = "tokenization"
  allowed_roles    = ["*"]
  deletion_allowed = true
}
