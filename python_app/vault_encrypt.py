import pandas as pd
import hvac
import os
import json

VAULT_ADDR = os.getenv("VAULT_ADDR", "").rstrip("/")
VAULT_TOKEN = os.getenv("VAULT_TOKEN", "")
VAULT_NAMESPACE = os.getenv("VAULT_NAMESPACE","root")
VAULT_TRANSFORM_PATH = os.getenv("VAULT_TRANSFORM_PATH", "org")
VAULT_TRANSFORM_ROLE = os.getenv("VAULT_TRANSFORM_ROLE", "agent")

TEST_VALUE="327.456.789-19"
TEST_TRANSFORMATION="cpf"

#record = json.dumps
record =json.loads("""{ 
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
}""")

print(record["batch_input"] )

client = hvac.Client(
    url=VAULT_ADDR,
    token=VAULT_TOKEN,
    namespace=VAULT_NAMESPACE,
    verify='./certs/bundle.pem'
    )

print(client.is_authenticated())

encoded=""

encode_response = client.secrets.transform.encode(
    mount_point=VAULT_TRANSFORM_PATH,
    role_name=VAULT_TRANSFORM_ROLE,
    batch_input=record["batch_input"],
    transformation=TEST_TRANSFORMATION
)
print(encode_response)
# print('The encoded value is: %s' % encode_response['data']['encoded_value'])

