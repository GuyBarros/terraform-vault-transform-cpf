vault write transform_cpf/decode/cpf value="797.948.392-38"  transformation=fpe_cpf

vault write transform_cpf/encode/cpf value="123.456.789-09"  transformation=masking_cpf

vault write transform_cpf/decode/cpf value="###.###.###-##"  transformation=masking_cpf

vault write transform_cpf/encode/cpf value="123.456.789-09"  transformation=masking_cpf


vault write transform_cpf/decode/cpf value="Q4tYgFXHxUb3ttDFMGgY97vAY1Q1qdB12HvpiHuFP4hrYR2c416S8p"  transformation=tokenization_cpf


vault write transform_cpf/transformation/oneway \
  type=tokenization \
  template=brazilian_cpf \
  allowed_roles="cpf" \
  tweak_source=internal \
  format_preserved=true \
  token_type=fpe \
  deletion_allowed=false \
  revocation_allowed=false \
  random=true

  vault write transform_cpf/encode/cpf value="123.456.789-09"  transformation=oneway


vault write transform_cpf/decode/cpf value="Q4tYgFXHxUPQFTb9mc6UqPybAmFZ41BRY5wmzrokYaDSk2YXKmmxMD"  transformation=oneway


