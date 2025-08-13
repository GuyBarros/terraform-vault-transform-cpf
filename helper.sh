
vault write transform_brazilian_pii/encode/transformacao value="123.456.789-09"  transformation=masking_cpf

vault write transform_brazilian_pii/encode/transformacao value="76.537.694/0001-62"  transformation=masking_cnpj

vault write transform_brazilian_pii/encode/transformacao value="76.537.694/0001-62"  transformation=masking_email
