variable "transform_path" {
  description = "the path to mount the transform path"
  default     = "transform_cpf"
}

variable "fpe_transformation_name" {
  description = "the name to give the custom fpe transformation"
  default     = "fpe_cpf"
}

variable "masking_transformation_name" {
  description = "the name to give the custom masking transformation"
  default     = "masking_cpf"
}

variable "tokenization_transformation_name" {
  description = "the name to give the custom tokenization transformation"
  default     = "tokenization_cpf"
}

variable "transformation_template_name" {
  description = "the name to give the custom transformation template"
  default     = "brazilian_cpf"
}

variable "transformation_role_name" {
  description = "the name to give the transformation tole"
  default     = "cpf"
}

variable "template_regex_pattern" {
  description = "the regex the transformation template will use"
  default     = "(\\d{3}).(\\d{3}).(\\d{3})-(\\d{2})"
}