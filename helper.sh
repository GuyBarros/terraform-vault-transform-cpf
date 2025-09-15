export VAULT_ADDR=https://vault-for-rfi-ibm-itau-a23a5e6b02259ac6.elb.us-east-2.amazonaws.com:8200
export VAULT_NAMESPACE=root
export VAULT_TOKEN=""

vault write org/transformations/tokenization/nome \
     allowed_roles="*"     convergent=true deletion_allowed=true
#Nome: Tokenization Convergente
vault write org/encode/agent value="João da Silva" transformation=nome
#CPF: FPE Parcial Nao Deterministico
vault write org/encode/agent value="123.456.789-09"  transformation=cpf
#CNPJ: FPE Parcial Deterministico
vault write org/encode/agent value="76.537.694/0001-62"  transformation=cnpj
#Endereço: Tokenization Nao Convergente
vault write org/encode/agent value="Rua das Palmeiras, 145 - São Paulo/SP" transformation=endereco
#E-mail: FPE Total Nao Deterministico Nao Reversivel
vault write org/encode/agent value="test@myrealemail.com" transformation=email
#Telefone:FPE Total Deterministico Nao Reversivel
vault write org/encode/agent value="(11) 91234-5678" transformation=telefone
#Valores: Tokenization Nao Convergente Irreversivel
vault write org/encode/agent value="13/09/2025" transformation=data
#Número de conta: FPE Parcial Deterministico
vault write org/encode/agent value="345678-9"  transformation=conta
#Número de agência: FPE Parcial Deterministico
vault write org/encode/agent value="1234"  transformation=agencia
#Número de contrato: Tokenization Nao Convergente
vault write org/encode/agent value="123456789012345" transformation=contrato
#Produto/serviço:  Tokenization Nao Convergente
vault write org/encode/agent value="emprestimo" transformation=produto

#vault write org/encode/agent

# Single API call
curl -X PUT -H "X-Vault-Namespace: $VAULT_NAMESPACE" \
 -H "X-Vault-Token: $VAULT_TOKEN" -H "X-Vault-Request: true" \
 -d '{"transformation":"cpf_partial_masking","value":"123.456.789-09"}'\
$VAULT_ADDR/v1/org/encode/agent | jq .


# Batch API call
curl -X PUT -H "X-Vault-Namespace: $VAULT_NAMESPACE" \
 -H "X-Vault-Token: $VAULT_TOKEN" -H "X-Vault-Request: true" \
 -d '{ 
  "batch_input":[ 
    { "value" : "Nome Exemplo", "transformation" : "nome" },
    { "value" : "123.456.789-09", "transformation" : "cpf" },
    { "value" : "76.537.694/0001-62", "transformation" : "cnpj" },
    { "value" : "myreal@email.com", "transformation" : "email", "ttl" : "8h", "metadata" : { "Organization" : "IBM", "Purpose" : "Finance", "Type" : "BR_PII" } } 
    { "value" : ""Rua das Palmeiras, 145 - São Paulo/SP"", "transformation" : "endereco" },
  ] 
}' \
$VAULT_ADDR/v1/org/encode/agent | jq .


vault write org/encode/agent value="345678-9" transformation=masking-conta

vault write org/encode/agent value="345678-9" transformation=conta