output "cpf_enconded_value" {
  value = data.vault_transform_encode.cpf-test.batch_results
}

output "cnpj_enconded_value" {
  value = data.vault_transform_encode.cnpj-test.batch_results
}

output "email_enconded_value" {
  value = data.vault_transform_encode.email-test.batch_results
}