data "vault_policy_document" "transform_encode_example" {
  rule {
    path         = "${vault_mount.transform.path}/decode/${vault_transform_role.role.name}"
    capabilities = ["update"]
    description  = "allow decoding via the transform/decode/role endpoint"
    allowed_parameter {
      key   = "transformation"
      value = [vault_transform_transformation.cpf_fpe_deterministic.name,
    vault_transform_transformation.cnpj_fpe_deterministic.name,
    vault_transform_transformation.cpf_fpe_non_deterministic.name,
    vault_transform_transformation.cnpj_fpe_non_deterministic.name,
    vault_transform_transformation.cpf_full_masking.name,
    vault_transform_transformation.cnpj_full_masking.name,
    vault_transform_transformation.cpf_partial_masking.name,
    vault_transform_transformation.cnpj_partial_masking.name,
    vault_transform_transformation.tokenization_non_convergent.name,
    vault_transform_transformation.cpf_partial_fpe_deterministic.name]
    }
     
  }

}

resource "vault_policy" "transform_encode" {
  name   = "transform_encode"
  policy = data.vault_policy_document.transform_encode_example.hcl
}

