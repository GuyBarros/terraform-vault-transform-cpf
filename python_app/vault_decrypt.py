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

record = "this is a test"

# ---- Load data from example.json --------------------------------------------
with open("batch.json") as f:
    record = json.load(f)


print(record["batch_input"] )

# client = hvac.Client(
#     url=VAULT_ADDR,
#     token=VAULT_TOKEN,
#     namespace=VAULT_NAMESPACE,
#     verify=False
#     )

# print(client.is_authenticated())

# encoded=""

# decode_response = client.secrets.transform.decode(
#     mount_point=VAULT_TRANSFORM_PATH,
#     role_name=VAULT_TRANSFORM_ROLE,
#     transformation=TEST_TRANSFORMATION,
#     tweak=encoded['data']['tweak'],
#     value=encoded['data']['encoded_value']
# )
# print('The decoded value is: %s' % decode_response['data']['decoded_value'])

