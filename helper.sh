
vault write transform_brazilian_pii/encode/transformacao value="123.456.789-09"  transformation=masking_cpf

vault write transform_brazilian_pii/encode/transformacao value="76.537.694/0001-62"  transformation=masking_cnpj

vault write transform_brazilian_pii/encode/transformacao  value="realemail@fake.com.br" transformation=masking_email


vault write -output-curl-string transform_brazilian_pii/encode/transformacao value="76.537.694/0001-62" ttl=8h  metadata="Organization=HashiCorp" metadata="Purpose=Travel" metadata="Type=AMEX" transformation=tokenization_cnpj


curl -X PUT -H "X-Vault-Request: true" -H "X-Vault-Token: $(vault print token)" -H "X-Vault-Namespace: admin/" \
-d '{ 
  "batch_input":[{ "value" : "123.456.789-09", "transformation" : "fpe_cpf" },
    { "value" : "76.537.694/0001-62", "transformation" : "masking_cnpj" },
    { "value" : "myreal@email.com", "transformation" : "tokenization_email", "ttl" : "8h", "metadata" : { "Organization" : "HashiCorp", "Purpose" : "Travel", "Type" : "AMEX" } }
  ]
}' $VAULT_ADDR/v1/transform_brazilian_pii/encode/transformacao | jq .