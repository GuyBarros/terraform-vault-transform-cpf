resource "vault_transform_alphabet" "complete_brazil_alphabet" {
  path     = vault_mount.transform.path
  name     = "complete_brazil_alphabet"
  alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz ÁÂÃÇÉÊÌÍÓÔÕÚÛáâãçéêíòóôõùúû.,-/0123456789ºª;%"
}

resource "vault_transform_alphabet" "general_email_alphabet" {
  path     = vault_mount.transform.path
  name     = "general_email_alphabet"
  alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789._%+-&"
}

resource "vault_transform_alphabet" "basic_brazil_alphabet" {
  path     = vault_mount.transform.path
  name     = "basic_brazil_alphabet"
  alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzÀÁÂÃÄÅÇÈÉÊËÌÍÎÏÑÒÓÔÕÖÙÚÛÝàáâãäåçèéêëìíîïñòóôõöùúûýÿ -'"
}