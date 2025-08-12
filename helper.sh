vault write transform_brazilian_pii/decode/transformacao value="797.948.392-38"  transformation=fpe_cpf

vault write transform_brazilian_pii/encode/transformacao value="123.456.789-09"  transformation=masking_cpf

vault write transform_brazilian_pii/decode/transformacao value="###.###.###-##"  transformation=masking_cpf

vault write transform_brazilian_pii/encode/transformacao value="123.456.789-09"  transformation=masking_cpf

vault write transform_brazilian_pii/encode/transformacao value="123.456.789-99"  transformation=masking_cpf

vault write transform_brazilian_pii/decode/transformacao value="Q4tYgFXHxUb3ttDFMGgY97vAY1Q1qdB12HvpiHuFP4hrYR2c416S8p"  transformation=tokenization_cpf

vault write transform_brazilian_pii/encode/transformacao value="123.456.789-09"  transformation=masking_cpf

