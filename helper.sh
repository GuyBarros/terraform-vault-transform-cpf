export VAULT_ADDR=https://vault.guystack1.guy.aws.sbx.hashicorpdemo.com:8200
export VAULT_NAMESPACE=root
export VAULT_TOKEN=hunter2

vault write transform_brazilian_pii/encode/agent value="123.456.789-09"  transformation=cpf_fpe_deterministic
vault write transform_brazilian_pii/encode/agent value="123.456.789-09"  transformation=cpf_fpe_non_deterministic
vault write transform_brazilian_pii/encode/agent value="123.456.789-09"  transformation=cpf_full_masking
vault write transform_brazilian_pii/encode/agent value="123.456.789-09"  transformation=cpf_partial_masking

vault write transform_brazilian_pii/encode/agent value="76.537.694/0001-62"  transformation=cnpj_partial_masking
vault write transform_brazilian_pii/encode/agent value=@python_app/example.json  transformation=tokenization_non_convergent ttl="8h" metadata=organization=IBM,purpose=Finance,type=BR_PII
vault write transform_brazilian_pii/decode/agent value="J2iVWxV4mferYXCwPBhAeGtF8BtRTERQStZLvD9kXfgNKaG5L4wNMTbuh9kXt1P5y" transformation=tokenization_non_convergent

# Single API call
curl -X PUT -H "X-Vault-Namespace: $VAULT_NAMESPACE" \
 -H "X-Vault-Token: $VAULT_TOKEN" -H "X-Vault-Request: true" \
 -d '{"transformation":"cpf_partial_masking","value":"123.456.789-09"}'\
$VAULT_ADDR/v1/transform_brazilian_pii/encode/agent | jq .


# Batch API call
curl -X PUT -H "X-Vault-Namespace: $VAULT_NAMESPACE" \
 -H "X-Vault-Token: $VAULT_TOKEN" -H "X-Vault-Request: true" \
 -d '{ 
  "batch_input":[ 
    { "value" : "123.456.789-09", "transformation" : "cpf_fpe_non_deterministic" },
    { "value" : "76.537.694/0001-62", "transformation" : "cnpj_partial_masking" },
    { "value" : "myreal@email.com", "transformation" : "tokenization_non_convergent", "ttl" : "8h", "metadata" : { "Organization" : "IBM", "Purpose" : "Finance", "Type" : "BR_PII" } } 
  ] 
}' \
$VAULT_ADDR/v1/transform_brazilian_pii/encode/agent | jq .


vault token create -policy="transform_encode" -policy="transform_decode"
