resource "vault_mount" "transform" {
  path = "transform_brazilian_pii"
  type = "transform"
}


resource "vault_transform_role" "role" {
  path = vault_mount.transform.path
  name = "transformacao"
  transformations = [vault_transform_transformation.cpf-fpe.name,
    vault_transform_transformation.cpf-masking.name,
    vault_transform_transformation.cpf-tokenization.name,
    vault_transform_transformation.cnpj-fpe.name,
    vault_transform_transformation.cnpj-masking.name,
  vault_transform_transformation.cnpj-tokenization.name,
    vault_transform_transformation.email-fpe.name,
    vault_transform_transformation.email-masking.name,
    vault_transform_transformation.email-tokenization.name]
}




