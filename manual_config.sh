#VAULT ENVIRONMENT VARIABLES
export VAULT_TOKEN=<YOUR_VAULT_TOKEN>
export VAULT_NAMESPACE=root
export VAULT_ADDR=<YOUR_VAULT_ADDRESS>
export VAULT_SKIP_VERIFY=true
#Transform Engine Variables
export TRANSFORM_PATH_NAME=org
export TRANSFORM_ROLE_NAME=agent
export DEFAULT_TOKENIZATION_TTL=1h
#Tokenization Store Variables
export POSTGRES_ADDR=<POSTGRES_URL>:5432
export POSTGRES_DATABASE=<POSTGRES_DATABASE_NAME>
export POSTGRES_USERNAME=<POSTGRES_USERNAME>
export POSTGRES_PASSWORD=<POSTGRES_PASSWORD>


#Secret Engine
vault secrets enable -path=$TRANSFORM_PATH_NAME transform 

#Role
vault write $TRANSFORM_PATH_NAME/role/$TRANSFORM_ROLE_NAME \
 transformations=cpf,cnpj,email,telefone,conta,data,agencia,nome,endereco,valores,contrato,produto,ticket

#Custom Alphabets
  vault write $TRANSFORM_PATH_NAME/alphabet/general_email_alphabet \
    alphabet="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789._%+-&ÀÁÂÃÄÅÇÈÉÊËÌÍÎÏÑÒÓÔÕÖÙÚÛÝàáâãäåçèéêëìíîïñòóôõöùúûýÿ"

#Transformation Templates
vault write $TRANSFORM_PATH_NAME/template/cnpj \
  type=regex \
  pattern='(\d{2})\.(\d{3})\.(\d{3})\/(\d{4})-(\d{2})' \
  deletion_allowed=true \
  alphabet=builtin/numeric

vault write $TRANSFORM_PATH_NAME/template/cpf \
  type=regex \
  pattern='(\d{3}).(\d{3}).(\d{3})-(\d{2})' \
  deletion_allowed=true \
  alphabet=builtin/numeric

vault write $TRANSFORM_PATH_NAME/template/email \
  type=regex \
  pattern='([A-Za-zÀ-ÿ0-9_+]+)(?:\.([A-Za-zÀ-ÿ0-9_+]+))?(?:\.([A-Za-zÀ-ÿ0-9_+]+))?(?:\.([A-Za-zÀ-ÿ0-9_+]+))?@([A-Za-zÀ-ÿ0-9-]+)(?:\.([A-Za-zÀ-ÿ0-9-]+))?(?:\.([A-Za-zÀ-ÿ0-9-]+))?\.([A-Za-zÀ-ÿ]{2,24})' \
  deletion_allowed=true \
  alphabet=general_email_alphabet

vault write $TRANSFORM_PATH_NAME/template/data \
  type=regex \
  pattern='(\d{2})/(\d{2})/(\d{4})' \
  deletion_allowed=true \
  alphabet=builtin/numeric

vault write $TRANSFORM_PATH_NAME/template/telefone \
  type=regex \
  pattern='^\+?(\d{0,3})[ \.-]?\(?(\d{2})\)?[ \.-]?(\d{4,5})[ \.-]?(\d{4})$' \
  deletion_allowed=true \
  alphabet=builtin/numeric

vault write $TRANSFORM_PATH_NAME/template/conta-bancaria \
  type=regex \
  pattern='(\d{6})(?:-?)(?:\d{1})' \
  deletion_allowed=true \
  alphabet=builtin/numeric

vault write $TRANSFORM_PATH_NAME/template/agencia-bancaria \
  type=regex \
  pattern='^\d+([-\/]?\d+)+$' \
  deletion_allowed=true \
  alphabet=builtin/numeric

# FPE Transformations
vault write $TRANSFORM_PATH_NAME/transformations/fpe/cpf \
  template=cpf \
  tweak_source=generated \
  deletion_allowed=true \
  allowed_roles=$TRANSFORM_ROLE_NAME

vault write $TRANSFORM_PATH_NAME/transformations/fpe/cnpj \
  template=cnpj \
  tweak_source=internal \
  deletion_allowed=true \
  allowed_roles=$TRANSFORM_ROLE_NAME

vault write $TRANSFORM_PATH_NAME/transformations/fpe/email \
  template=email \
  tweak_source=generated \
  deletion_allowed=true \
  allowed_roles=$TRANSFORM_ROLE_NAME

vault write $TRANSFORM_PATH_NAME/transformations/fpe/telefone \
  template=telefone \
  tweak_source=generated \
  deletion_allowed=true \
  allowed_roles=$TRANSFORM_ROLE_NAME

vault write $TRANSFORM_PATH_NAME/transformations/fpe/conta \
  template=conta-bancaria \
  tweak_source=internal \
  deletion_allowed=true \
  allowed_roles=$TRANSFORM_ROLE_NAME

vault write $TRANSFORM_PATH_NAME/transformations/fpe/data \
  template=data \
  tweak_source=internal \
  deletion_allowed=true \
  allowed_roles=$TRANSFORM_ROLE_NAME

# Masking Transformations
vault write $TRANSFORM_PATH_NAME/transformations/masking/agencia \
  template=agencia-bancaria \
  tweak_source=internal \
  deletion_allowed=true \
  allowed_roles=$TRANSFORM_ROLE_NAME
