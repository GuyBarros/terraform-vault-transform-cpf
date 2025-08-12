# Vault transform engine paths
TRANSFORM_PATH="transform"
ROLE_NAME="cpf-role"
ALPHABET_NAME="numeric"
TEMPLATE_NAME="cpf-template"
TRANSFORMATION_NAME="cpf-fpe-partial3"


# Enable transform engine
# vault secrets enable -path=$TRANSFORM_PATH transform || true

# Create CPF template (e.g. 123.456.789-09)
vault write $TRANSFORM_PATH/template/$TEMPLATE_NAME \
  pattern="(\\d{3}).(\\d{3}).(\\d{3})-(\\d{2})" \
  alphabet="builtin/numeric" \
  type="regex" \
  encode_format='$1.$2.$3-$4' \
  decode_formats=cpf='$4'


vault write $TRANSFORM_PATH/transformation/$TRANSFORMATION_NAME \
  type="fpe" \
  template="$TEMPLATE_NAME" \
  allowed_roles="$ROLE_NAME" \
  tweak_source="internal" 

# Create role that can use the transformation
vault write $TRANSFORM_PATH/role/$ROLE_NAME \
  transformations="$TRANSFORMATION_NAME"

vault write -format=json $TRANSFORM_PATH/encode/$ROLE_NAME value="123.456.789-99"  transformation=$TRANSFORMATION_NAME

# vault write $TRANSFORM_PATH/decode/$ROLE_NAME value="867.708.197-47"  transformation=$TRANSFORMATION_NAME

# vault write $TRANSFORM_PATH/decode/$ROLE_NAME value="###.###.197-47"  transformation=$TRANSFORMATION_NAME
