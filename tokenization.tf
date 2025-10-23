# ----- VARIABLES (example) -----
variable "db_host" {
  type = string
}
variable "db_port" {
  type    = number
  default = 5432
}
variable "db_name" {
  type    = string
  default = "tokens"
}
variable "db_schema" {
  type    = string
  default = "public"
}
variable "db_user" {
  type = string
} # least-priv user (SELECT/INSERT/UPDATE)
variable "db_password" {
  type      = string
  sensitive = true
}

# DDL-capable user to create/update the schema (one-time)
variable "ddl_user" {
  type = string
}
variable "ddl_password" {
  type      = string
  sensitive = true
}



locals {
  # Example PostgreSQL connection URI — note {{username}} / {{password}} template slots
  pg_conn = "postgresql://{{username}}:{{password}}@${var.db_host}:${var.db_port}/${var.db_name}?sslmode=require"
}

# 2) Create the tokenization STORE (type=sql; driver=postgres/mysql/mssql)
# API: POST /transform/stores/:name
resource "vault_generic_endpoint" "nome_store" {
  path                 = "${vault_mount.transform.path}/stores/nome_store"
  ignore_absent_fields = true
  # Many endpoints don't return all fields; avoid spurious drift:
  disable_read = true

  data_json = jsonencode({
    type                 = "sql",
    driver               = "postgres",
    connection_string    = local.pg_conn,
    username             = var.db_user,
    password             = var.db_password,
    supported_transformations = ["tokenization"]
  })

  depends_on = [vault_mount.transform]
}

# 3) Initialize/Update the STORE SCHEMA (one-time DDL)
# API: POST /transform/stores/:name/schema
resource "vault_generic_endpoint" "nome_store_schema" {
  path                 = "${vault_mount.transform.path}/stores/nome_store/schema"
  ignore_absent_fields = true
  disable_read         = true

  data_json = jsonencode({
    username            = var.ddl_user,
    password            = var.ddl_password,
    transformation_type = "tokenization"
  })

  depends_on = [vault_generic_endpoint.nome_store]
}

# 4) Create a TOKENIZATION transformation that USES this store
# API: POST /transform/transformations/tokenization/:name
# mapping_mode: "default" (strongest) or "exportable" (emergency export-decoded).
# Tokenization Convergente
resource "vault_generic_endpoint" "nome_tokenization" {
  path                 = "${vault_mount.transform.path}/transformations/tokenization/nome"
  ignore_absent_fields = true
  disable_read         = true

  data_json = jsonencode({
    mapping_mode  = "default",
    convergent    = true,           # set true for deterministic tokens (with caveats)
    allowed_roles = ["*"], # who may use this transform
    stores        = ["nome_store"],
    deletion_allowed = true
  })

  depends_on = [vault_generic_endpoint.nome_store_schema]
}
###############################
resource "vault_generic_endpoint" "endereco_store" {
  path                 = "${vault_mount.transform.path}/stores/endereco_store"
  ignore_absent_fields = true
  # Many endpoints don't return all fields; avoid spurious drift:
  disable_read = true

  data_json = jsonencode({
    type                 = "sql",
    driver               = "postgres",
    connection_string    = local.pg_conn,
    username             = var.db_user,
    password             = var.db_password,
    supported_transformations = ["tokenization"]
  })

  depends_on = [vault_mount.transform]
}

# Tokenization Nao Convergente
resource "vault_generic_endpoint" "endereco_tokenization" {
  path                 = "${vault_mount.transform.path}/transformations/tokenization/endereco"
  ignore_absent_fields = true
  disable_read         = true

  data_json = jsonencode({
    mapping_mode  = "default",
    convergent    = false,           # set true for deterministic tokens (with caveats)
    allowed_roles = ["${vault_transform_role.role.name}"], # who may use this transform
    stores        = ["endereco_store"],
    deletion_allowed = true
  })

  depends_on = [vault_generic_endpoint.nome_store_schema]
}
###############################
# Tokenization Nao Convergente Irreversivel
resource "vault_generic_endpoint" "valores_store" {
  path                 = "${vault_mount.transform.path}/stores/valores_store"
  ignore_absent_fields = true
  # Many endpoints don't return all fields; avoid spurious drift:
  disable_read = true

  data_json = jsonencode({
    type                 = "sql",
    driver               = "postgres",
    connection_string    = local.pg_conn,
    username             = var.db_user,
    password             = var.db_password,
    supported_transformations = ["tokenization"]
  })

  depends_on = [vault_mount.transform]
}

# Tokenization Nao Convergente
resource "vault_generic_endpoint" "valores_tokenization" {
  path                 = "${vault_mount.transform.path}/transformations/tokenization/valores"
  ignore_absent_fields = true
  disable_read         = true

  data_json = jsonencode({
    mapping_mode  = "default",
    convergent    = false,           # set true for deterministic tokens (with caveats)
    allowed_roles = ["${vault_transform_role.role.name}"], # who may use this transform
    stores        = ["valores_store"],
    deletion_allowed = true
  })

  depends_on = [vault_generic_endpoint.nome_store_schema]
}
###############################
resource "vault_generic_endpoint" "contrato_store" {
  path                 = "${vault_mount.transform.path}/stores/contrato_store"
  ignore_absent_fields = true
  # Many endpoints don't return all fields; avoid spurious drift:
  disable_read = true

  data_json = jsonencode({
    type                 = "sql",
    driver               = "postgres",
    connection_string    = local.pg_conn,
    username             = var.db_user,
    password             = var.db_password,
    supported_transformations = ["tokenization"]
  })

  depends_on = [vault_mount.transform]
}


# Tokenization Nao Convergente Irreversivel
resource "vault_generic_endpoint" "contrato_tokenization" {
  path                 = "${vault_mount.transform.path}/transformations/tokenization/contrato"
  ignore_absent_fields = true
  disable_read         = true

  data_json = jsonencode({
    mapping_mode  = "default",
    convergent    = false,           # set true for deterministic tokens (with caveats)
  allowed_roles = ["${vault_transform_role.role.name}"], # who may use this transform
    stores        = ["contrato_store"],
    deletion_allowed = true
  })

  depends_on = [vault_generic_endpoint.contrato_store]
}
################################
resource "vault_generic_endpoint" "produto_store" {
  path                 = "${vault_mount.transform.path}/stores/produto_store"
  ignore_absent_fields = true
  # Many endpoints don't return all fields; avoid spurious drift:
  disable_read = true

  data_json = jsonencode({
    type                 = "sql",
    driver               = "postgres",
    connection_string    = local.pg_conn,
    username             = var.db_user,
    password             = var.db_password,
    supported_transformations = ["tokenization"]
  })

  depends_on = [vault_mount.transform]
}


# Tokenization Nao Convergente Irreversivel
resource "vault_generic_endpoint" "produto_tokenization" {
  path                 = "${vault_mount.transform.path}/transformations/tokenization/produto"
  ignore_absent_fields = true
  disable_read         = true

  data_json = jsonencode({
    mapping_mode  = "default",
    convergent    = false,           # set true for deterministic tokens (with caveats)
  allowed_roles = ["${vault_transform_role.role.name}"], # who may use this transform
    stores        = ["produto_store"],
    deletion_allowed = true
  })

  depends_on = [vault_generic_endpoint.produto_store]
}
################################
resource "vault_generic_endpoint" "ticket_store" {
  path                 = "${vault_mount.transform.path}/stores/ticket_store"
  ignore_absent_fields = true
  # Many endpoints don't return all fields; avoid spurious drift:
  disable_read = true

  data_json = jsonencode({
    type                 = "sql",
    driver               = "postgres",
    connection_string    = local.pg_conn,
    username             = var.db_user,
    password             = var.db_password,
    supported_transformations = ["tokenization"]
  })

  depends_on = [vault_mount.transform]
}


# Tokenization Nao Convergente Reversivel
resource "vault_generic_endpoint" "ticket_tokenization" {
  path                 = "${vault_mount.transform.path}/transformations/tokenization/ticket"
  ignore_absent_fields = true
  disable_read         = true

  data_json = jsonencode({
    mapping_mode  = "default",
    convergent    = false,           # set true for deterministic tokens (with caveats)
    allowed_roles = ["${vault_transform_role.role.name}"], # who may use this transform
    stores        = ["ticket_store"],
    deletion_allowed = true
  })

  depends_on = [vault_generic_endpoint.ticket_store]
}

###############################
# Tokenization Convergente Reversível
resource "vault_generic_endpoint" "pix_store" {
  path                 = "${vault_mount.transform.path}/stores/pix_store"
  ignore_absent_fields = true
  # Many endpoints don't return all fields; avoid spurious drift:
  disable_read = true

  data_json = jsonencode({
    type                 = "sql",
    driver               = "postgres",
    connection_string    = local.pg_conn,
    username             = var.db_user,
    password             = var.db_password,
    supported_transformations = ["tokenization"]
  })

  depends_on = [vault_mount.transform]
}

# Tokenization Convergente
resource "vault_generic_endpoint" "pix_tokenization" {
  path                 = "${vault_mount.transform.path}/transformations/tokenization/pix"
  ignore_absent_fields = true
  disable_read         = true

  data_json = jsonencode({
    mapping_mode  = "default",
    convergent    = true,           # set true for deterministic tokens (with caveats)
    allowed_roles = ["${vault_transform_role.role.name}"], # who may use this transform
    stores        = ["pix_store"],
    deletion_allowed = true
  })

  depends_on = [vault_generic_endpoint.nome_store_schema]
}

###############################
# Tokenization Convergente Reversível
resource "vault_generic_endpoint" "empresa_store" {
  path                 = "${vault_mount.transform.path}/stores/empresa_store"
  ignore_absent_fields = true
  # Many endpoints don't return all fields; avoid spurious drift:
  disable_read = true

  data_json = jsonencode({
    type                 = "sql",
    driver               = "postgres",
    connection_string    = local.pg_conn,
    username             = var.db_user,
    password             = var.db_password,
    supported_transformations = ["tokenization"]
  })

  depends_on = [vault_mount.transform]
}

# Tokenization Convergente
resource "vault_generic_endpoint" "empresa_tokenization" {
  path                 = "${vault_mount.transform.path}/transformations/tokenization/empresa"
  ignore_absent_fields = true
  disable_read         = true

  data_json = jsonencode({
    mapping_mode  = "default",
    convergent    = true,           # set true for deterministic tokens (with caveats)
    allowed_roles = ["${vault_transform_role.role.name}"], # who may use this transform
    stores        = ["empresa_store"],
    deletion_allowed = true
  })

  depends_on = [vault_generic_endpoint.nome_store_schema]
}

###############################
# Tokenization Convergente Reversível
resource "vault_generic_endpoint" "outros_store" {
  path                 = "${vault_mount.transform.path}/stores/outros_store"
  ignore_absent_fields = true
  # Many endpoints don't return all fields; avoid spurious drift:
  disable_read = true

  data_json = jsonencode({
    type                 = "sql",
    driver               = "postgres",
    connection_string    = local.pg_conn,
    username             = var.db_user,
    password             = var.db_password,
    supported_transformations = ["tokenization"]
  })

  depends_on = [vault_mount.transform]
}

# Tokenization Convergente
resource "vault_generic_endpoint" "outros_tokenization" {
  path                 = "${vault_mount.transform.path}/transformations/tokenization/outros"
  ignore_absent_fields = true
  disable_read         = true

  data_json = jsonencode({
    mapping_mode  = "default",
    convergent    = true,           # set true for deterministic tokens (with caveats)
    allowed_roles = ["${vault_transform_role.role.name}"], # who may use this transform
    stores        = ["outros_store"],
    deletion_allowed = true
  })

  depends_on = [vault_generic_endpoint.nome_store_schema]
}