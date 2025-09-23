export VAULT_ADDR=https://vault-for-rfi-ibm-itau-a23a5e6b02259ac6.elb.us-east-2.amazonaws.com:8200
export VAULT_NAMESPACE=root
export VAULT_TOKEN=<TOKEN>
export VAULT_SKIP_VERIFY=true

vault write org/transformations/tokenization/nome \
     allowed_roles="*"     convergent=true deletion_allowed=true

#Nome: Tokenization Convergente
vault write org/encode/agent value="João da Silva" transformation=nome metadata=Organization=IBM
vault write org/decode/agent value="DaCJhefr1oZMeyX5Sp98fZtxPgL5RUajHxJ8mr12jgeqk5dcgrxHynmQ6mZFPB1i19Mw56cT1dcj" transformation=nome
#CPF: FPE Parcial Nao Deterministico
vault write org/encode/agent value="123.456.789-09"  transformation=cpf
# vault write org/decode/agent value=260.132.436-09  transformation=cpf tweak=FTlb3QSAHg==
#CNPJ: FPE Parcial Deterministico
vault write org/encode/agent value="76.537.694/0001-62"  transformation=cnpj
vault write org/decode/agent value="76.716.926/2120-62"  transformation=cnpj
#Endereço: Tokenization Nao Convergente
vault write org/encode/agent value="Rua das Palmeiras, 145 - São Paulo/SP" transformation=endereco
vault write org/decode/agent value="Q4tYgFXHxUbWgHNTjbmLeiMUay2GwZBYuKz5VHavsAnKPTRdDib224" transformation=endereco
#E-mail: FPE Total Nao Deterministico Nao Reversivel
vault write org/encode/agent value="test@myrealemail.com" transformation=email
#Telefone:FPE Total Deterministico Nao Reversivel
vault write org/encode/agent value="(11) 91234-5678" transformation=telefone
#Valores: Tokenization Nao Convergente Irreversivel
vault write org/encode/agent value="13/09/2025" transformation=data
#Número de conta: FPE Parcial Deterministico
vault write org/encode/agent value="345678-9"  transformation=conta
#Número de agência: Masking Parcial
vault write org/encode/agent value="1234"  transformation=agencia
#Número de contrato: Tokenization Nao Convergente
vault write org/encode/agent value="123456789012345" transformation=contrato
#Produto/serviço:  Tokenization Nao Convergente
vault write org/encode/agent value="emprestimo" transformation=produto
vault write org/decode/agent value="Q4tYgFXHxUXY3itjTBkFpdqSd5nP2qiVoBH2MsNzGSppZNbr8quWBN" transformation=produto
#vault write org/encode/agent

vault write org/transformations/tokenization/ticket \
     allowed_roles="*"     convergent=true deletion_allowed=true

# Single API call
curl  --insecure -X PUT -H "X-Vault-Namespace: $VAULT_NAMESPACE" \
 -H "X-Vault-Token: $VAULT_TOKEN" -H "X-Vault-Request: true" \
 -d '{"transformation":"cpf","value":"123.456.789-09"}' \
$VAULT_ADDR/v1/org/encode/agent | jq .


vault write -format=json org/encode/agent - <<EOF

{ "batch_input":[ { "value" : "Nome Exemplo", "transformation" : "nome" , "reference": "nome" }, { "value" : "123.456.789-09", "transformation" : "cpf","reference": "cpf" }, { "value" : "76.537.694/0001-62", "transformation" : "cnpj","reference": "cnpj" }, { "value" : "myreal@email.com", "transformation" : "email", "ttl" : "8h", "metadata" : { "Organization" : "IBM", "Purpose" : "Finance", "Type" : "BR_PII" },"reference": "email" }, { "value" : "345678-9", "transformation" : "conta","reference": "conta" }, { "value" : "1234", "transformation" : "agencia","reference": "agencia" }, { "value" : "123456789012345", "transformation" : "contrato","reference": "contrato" }, { "value" : "emprestimo", "transformation" : "produto","reference": "produto" } ] }

EOF

# Batch API call
curl --insecure -X PUT -H "X-Vault-Namespace: $VAULT_NAMESPACE" \
 -H "X-Vault-Token: $VAULT_TOKEN" -H "X-Vault-Request: true" \
 -d '{ 
  "batch_input":[ 
    { "value" : "Nome Exemplo", "transformation" : "nome" , "reference": "nome" },
    { "value" : "123.456.789-09", "transformation" : "cpf","reference": "cpf" },
    { "value" : "76.537.694/0001-62", "transformation" : "cnpj","reference": "cnpj" },
    { "value" : "myreal@email.com", "transformation" : "email", "ttl" : "8h", "metadata" : { "Organization" : "IBM", "Purpose" : "Finance", "Type" : "BR_PII" },"reference": "email" },
    { "value" : "345678-9", "transformation" : "conta","reference": "conta" },
    { "value" : "1234", "transformation" : "agencia","reference": "agencia" },
    { "value" : "123456789012345", "transformation" : "contrato","reference": "contrato" },
    { "value" : "emprestimo", "transformation" : "produto","reference": "produto" }
  ] 
}' \
$VAULT_ADDR/v1/org/encode/agent | jq .data.batch_results

vault write -format=json org/decode/agent - <<EOF

{
    "batch_input": [
      {
        "value": "DaCJhefr1oZxxAV54F7gQqtMUhRuvLvhwQpvBGzEhFPWb5afuKkTBV4dzyLk8VDjrphZsiBTcgb6",
        "transformation": "nome"
      },
      {
        "value": "416.274.782-09",
        "transformation": "cpf",
        "tweak": "S599FhLd8g=="
      },
      {
        "value": "76.716.926/2120-62",
        "transformation": "cnpj"
      },
      {
        "value": "I1-gDB@abMy%0w6h",
        "transformation": "email",
        "tweak": "P6ACJLUjZQ=="
      },
      {
        "value": "667561-9",
        "transformation": "conta"
      },
      {
        "value": "**34",
        "transformation": "agencia"
      },
      {
        "value": "Q4tYgFXHxUXPVcDB2fNm4N4CdaonXExudnpF7HdKnzHDVtqJFYhmTW",
        "transformation": "contrato"
      },
      {
        "value": "Q4tYgFXHxUbyHUhq7K75WiJDZzhg94jqEngUmdCt73rmhU845prcGT",
        "transformation": "produto"
      }
    ]
  }
EOF



vault write org/encode/agent value="345678-9" transformation=masking-conta

vault write org/encode/agent value="345678-9" transformation=conta

{ "value" : "Rua das Palmeiras, 145 - São Paulo/SP", "transformation" : "endereco","reference": "endereco" },

# Single API call
curl  --insecure -X PUT -H "X-Vault-Namespace: $VAULT_NAMESPACE" \
 -H "X-Vault-Token: $VAULT_TOKEN" -H "X-Vault-Request: true" \
 -d '{"transformation":"ticket","value":'[{"encoded_value":"DaCJhefr1oZxxAV54F7gQqtMUhRuvLvhwQpvBGzEhFPWb5afuKkTBV4dzyLk8VDjrphZsiBTcgb6","reference":"nome"},{"encoded_value":"634.094.043-09","reference":"cpf","tweak":"dlj0gYEkrg=="},{"encoded_value":"76.716.926/2120-62","reference":"cnpj"},{"encoded_value":"UbjKcX@aWwfPEd\u0026E","reference":"email","tweak":"mXLhwGyqTw=="},{"encoded_value":"Q4tYgFXHxUQuKib2qod9768kZbMEL88f1xsrJH8rgPKWBxqvgDQdvy","reference":"endereco"},{"encoded_value":"667561-9","reference":"conta"},{"encoded_value":"734463","reference":"agencia"},{"encoded_value":"Q4tYgFXHxUNQ8G9cuJRo9au1wsA9Bg7Jh9NfAVrAJWV8AZ7Q6eDCNH","reference":"contrato"},{"encoded_value":"Q4tYgFXHxUc4xPxkm8kgLmK67qhK5enyBhLwwEU8MMDv963WUY55iT","reference":"produto"}]'}' \
$VAULT_ADDR/v1/org/encode/agent | jq .

vault write org/encode/agent transformation=ticket value='[{"encoded_value":"DaCJhefr1oZxxAV54F7gQqtMUhRuvLvhwQpvBGzEhFPWb5afuKkTBV4dzyLk8VDjrphZsiBTcgb6","reference":"nome"},{"encoded_value":"634.094.043-09","reference":"cpf","tweak":"dlj0gYEkrg=="},{"encoded_value":"76.716.926/2120-62","reference":"cnpj"},{"encoded_value":"UbjKcX@aWwfPEd\u0026E","reference":"email","tweak":"mXLhwGyqTw=="},{"encoded_value":"Q4tYgFXHxUQuKib2qod9768kZbMEL88f1xsrJH8rgPKWBxqvgDQdvy","reference":"endereco"},{"encoded_value":"667561-9","reference":"conta"},{"encoded_value":"734463","reference":"agencia"},{"encoded_value":"Q4tYgFXHxUNQ8G9cuJRo9au1wsA9Bg7Jh9NfAVrAJWV8AZ7Q6eDCNH","reference":"contrato"},{"encoded_value":"Q4tYgFXHxUc4xPxkm8kgLmK67qhK5enyBhLwwEU8MMDv963WUY55iT","reference":"produto"}]'

vault write /sys/wrapping/wrap value="this is a test" ttl=30m

curl --insecure -X PUT -H "X-Vault-Request: true" -H "X-Vault-Namespace: root/" -H "X-Vault-Token: $(vault print token)" -H "X-Vault-Wrap-Ttl: 5m" -d '{"ttl":"30m","value":"this is a test"}' https://vault-for-rfi-ibm-itau-a23a5e6b02259ac6.elb.us-east-2.amazonaws.com:8200/v1/sys/wrapping/wrap


 vault write -output-curl-string org/encode/agent transformation=ticket value='[{"encoded_value":"DaCJhefr1oZxxAV54F7gQqtMUhRuvLvhwQpvBGzEhFPWb5afuKkTBV4dzyLk8VDjrphZsiBTcgb6","reference":"nome"},{"encoded_value":"634.094.043-09","reference":"cpf","tweak":"dlj0gYEkrg=="},{"encoded_value":"76.716.926/2120-62","reference":"cnpj"},{"encoded_value":"UbjKcX@aWwfPEd\u0026E","reference":"email","tweak":"mXLhwGyqTw=="},{"encoded_value":"Q4tYgFXHxUQuKib2qod9768kZbMEL88f1xsrJH8rgPKWBxqvgDQdvy","reference":"endereco"},{"encoded_value":"667561-9","reference":"conta"},{"encoded_value":"734463","reference":"agencia"},{"encoded_value":"Q4tYgFXHxUNQ8G9cuJRo9au1wsA9Bg7Jh9NfAVrAJWV8AZ7Q6eDCNH","reference":"contrato"},{"encoded_value":"Q4tYgFXHxUc4xPxkm8kgLmK67qhK5enyBhLwwEU8MMDv963WUY55iT","reference":"produto"}]'

 curl --insecure -X PUT -H "X-Vault-Namespace: root/" \
 -H "X-Vault-Request: true" -H "X-Vault-Token: $(vault print token)" \
  -d '{"transformation":"ticket","value":""}' \
   $VAULT_ADDR/v1/org/encode/agent | jq .


 curl --insecure -X PUT -H "X-Vault-Namespace: root/" \
 -H "X-Vault-Request: true" -H "X-Vault-Token: $(vault print token)" \
  -d '{"transformation":"ticket","value":"{"batch_results":[{"encoded_value":"DaCJhefr1oZxxAV54F7gQqtMUhRuvLvhwQpvBGzEhFPWb5afuKkTBV4dzyLk8VDjrphZsiBTcgb6","reference":"nome"},{"encoded_value":"740.223.740-09","reference":"cpf","tweak":"Vg19awnu9w=="},{"encoded_value":"76.716.926/2120-62","reference":"cnpj"},{"encoded_value":"20rBF-@x9bj3mAWS","reference":"email","tweak":"P9S8+f5IKw=="},{"encoded_value":"Q4tYgFXHxUT9Shhms8GvzkcvesY9oeK7pujgcSwLKryxdrFMbS5vE2","reference":"endereco"},{"encoded_value":"667561-9","reference":"conta"},{"encoded_value":"734463","reference":"agencia"},{"encoded_value":"Q4tYgFXHxUSseeYVgvCShEk56ZbawyHUaV1JjYTBv6MXssH9JHXMtx","reference":"contrato"},{"encoded_value":"Q4tYgFXHxUWKfH3k73BTKBHDbtskhRCQdgJtMgJwHKoMiERX8zXmt5","reference":"produto"}]}"}' \
   $VAULT_ADDR/v1/sys/wrapping/wrap | jq .
