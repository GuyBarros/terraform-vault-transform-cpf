resource "vault_mount" "transform" {
  path = "transform_brazilian_pii"
  type = "transform"
}

resource "vault_transform_role" "role" {
  path = vault_mount.transform.path
  name = "agent"
  transformations = [
    vault_transform_transformation.cpf_fpe_deterministic.name,
    vault_transform_transformation.cnpj_fpe_deterministic.name,
    vault_transform_transformation.cpf_fpe_non_deterministic.name,
    vault_transform_transformation.cnpj_fpe_non_deterministic.name,
    vault_transform_transformation.cpf_full_masking.name,
    vault_transform_transformation.cnpj_full_masking.name,
    vault_transform_transformation.cpf_partial_masking.name,
    vault_transform_transformation.cnpj_partial_masking.name,
    vault_transform_transformation.tokenization_non_convergent.name
  ]
}
