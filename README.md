# terraform-vault-transform-cpf
(this documentation is AI generated and the only part of the code which is AI generated.. sorry - GB)

Codebase to provision **HashiCorp Vault Transform** configurations (FPE/tokenization/masking) for **Brazilian CPF**, **CNPJ**, and **email** using **Terraform**.

> This project is aimed at teams who want to manage Transform engine configuration as code (roles, templates, alphabets, and transformations) and quickly test encoding/decoding via CLI or cURL.

---

## ✨ What this repo sets up

- Enables the **Transform** secrets engine at a configurable mount path.
- Creates **regex templates** for:
  - **CPF** (Cadastro de Pessoas Físicas)
  - **CNPJ** (Cadastro Nacional da Pessoa Jurídica)
  - **Email** (with option to transform the domain as well)
- Creates **FPE transformations** (FF3‑1) bound to a Transform **role** so clients can `encode`/`decode` values.
- (Optional) Demonstrates **masking** and/or **tokenization** variants if enabled in the *.tf files.
- Includes a small **helper script** to try encode/decode requests from the shell.

> ℹ️ The **Transform** engine is an **Enterprise/HCP Vault** feature (Advanced Data Protection). It is not available in OSS Vault.

---

## 📦 Repository layout

```
.
├── main.tf            # Provider, mount of the Transform engine, common wiring
├── variables.tf       # Input variables (mount path, role name, allow_decode, etc.)
├── outputs.tf         # Useful outputs (role name, transformation names, mount path)
├── cpf.tf             # CPF regex template + FPE transformation + role binding
├── cnpj.tf            # CNPJ regex template + FPE transformation + role binding
├── email.tf           # Email template/transformation; option to transform domain
└── helper.sh          # Quick test script: encode/decode samples against Vault
```

---

## 🔧 Prerequisites

- **Vault Enterprise** (or **HCP Vault Dedicated Plus**) with **Transform** enabled for your license.
- A Vault admin/operator token with permissions on `sys/mounts` and `transform/*`.
- **Terraform** v1.5+ and the **hashicorp/vault** provider.
- Network access from your machine/automation to the Vault API endpoint.

> Minimal policy for day‑one setup (example):
>
> ```hcl
> path "transform/*"     { capabilities = ["create","read","update","delete","list"] }
> path "sys/mounts/*"    { capabilities = ["create","read","update","delete","list"] }
> path "sys/mounts"      { capabilities = ["read","list"] }
> ```

---

## 🚀 Quick start

1. **Configure environment**
   
   Set the Vault address and an admin token in your environment (or use your preferred auth method):
   
   ```bash
   export VAULT_ADDR="https://<your-vault-host>:8200"
   export VAULT_TOKEN="<your-admin-or-setup-token>"
   ```

2. **Clone and initialize**
   
   ```bash
   git clone https://github.com/GuyBarros/terraform-vault-transform-cpf.git
   cd terraform-vault-transform-cpf
   terraform init
   ```

3. **Review variables** (override via `-var` or `*.tfvars`)
   
   Common variables exposed by `variables.tf` typically include:
   
   | Variable | Purpose | Example default |
   |---|---|---|
   | `transform_mount_path` | Where to mount/use the Transform engine | `"transform"` |
   | `role_name` | Name of the Transform role that clients call | `"pii"` |
   | `allow_decode` | Whether decode is permitted for the transformation | `true` |
   | `create_alphabet` | Whether to create a custom alphabet | `false` |
   | `email_transform_domain` | Transform the domain portion of emails | `true` |

4. **Apply**
   
   ```bash
   terraform apply
   ```
   Confirm the plan and create resources.

5. **Test**
   
   Use **helper.sh** or the Vault CLI/cURL examples below to encode/decode sample values.

---

## 🧩 What gets created (conceptually)

- **Mount**: `vault_mount.transform` at `${var.transform_mount_path}` (default `transform/`).
- **Templates** (regex):
  - **CPF**: recognises either plain digits or formatted `###.###.###-##`.
  - **CNPJ**: recognises either plain digits or formatted `##.###.###/####-##`.
  - **Email**: captures local-part and (optionally) domain; template used by the email transformation.
- **Transformations (FPE)**: `cpf`, `cnpj`, and `email` bound to the **role** `${var.role_name}`.
  - Typical settings: `tweak_source = "internal"`, `deletion_allowed = false`, optional `allowed_roles = [var.role_name]`, and `allow_decode` controlled by a variable.
- **Role**: `${var.role_name}` with `transformations = ["cpf","cnpj","email"]`.

> Notes
> - FF3‑1 FPE preserves input length/format within the template’s alphabet constraints.
> - `tweak_source` can be `internal` or `supplied`. Internal avoids passing a tweak at runtime; supplied is used if your apps manage tweaks explicitly.

---

## ✅ Usage examples

### Encode/Decode via Vault CLI

> Replace `pii` with your chosen role name; replace `${MOUNT}` with your actual mount path (default `transform`).

```bash
# Encode a CPF
vault write ${MOUNT}/encode/pii transformation=cpf value="123.456.789-09"

# Decode a CPF (if allow_decode=true)
vault write ${MOUNT}/decode/pii transformation=cpf value="<encoded-value>"

# Encode plain‑digits CPF
vault write ${MOUNT}/encode/pii transformation=cpf value=12345678909

# Encode a CNPJ
vault write ${MOUNT}/encode/pii transformation=cnpj value="12.345.678/0001-90"

# Encode an email (domain transformed too when configured)
vault write ${MOUNT}/encode/pii transformation=email value="guy.barros@example.com.br"
```

### Encode/Decode via cURL

```bash
# Encode using the role
curl -sS -H "X-Vault-Token: $VAULT_TOKEN" \
  -X POST "$VAULT_ADDR/v1/${MOUNT}/encode/pii" \
  -d '{"value":"123.456.789-09","transformation":"cpf"}' | jq .

# Decode (if allowed)
curl -sS -H "X-Vault-Token: $VAULT_TOKEN" \
  -X POST "$VAULT_ADDR/v1/${MOUNT}/decode/pii" \
  -d '{"value":"<encoded>","transformation":"cpf"}' | jq .
```

### Using `helper.sh`

A tiny wrapper to make quick requests; usage typically looks like:

```bash
./helper.sh encode cpf 123.456.789-09
./helper.sh decode cpf <encoded>
./helper.sh encode cnpj 12.345.678/0001-90
./helper.sh encode email guy.barros@example.com.br
```

> Open the script and adjust: `VAULT_ADDR`, `VAULT_TOKEN`, mount path, and role as needed.

---

## 🔒 Policies for applications

When calling from applications, grant **only** encode (and optionally decode) for the role path:

```hcl
# Encode for specific role
path "${var.transform_mount_path}/encode/pii" {
  capabilities = ["update"]
}

# (Optional) Allow decode
path "${var.transform_mount_path}/decode/pii" {
  capabilities = ["update"]
}
```

Use Vault Agent or your platform’s auth method to authenticate and fetch short‑lived tokens.

---

## 🧪 Validation tips

- Try both **formatted** and **digits‑only** CPFs/CNPJs to ensure your regex templates match as expected.
- Confirm that `allow_decode` behaves as intended (decode 403s when disabled).
- Review the generated transformation details:
  
  ```bash
  vault read ${MOUNT}/transformations/fpe/cpf
  vault read ${MOUNT}/transformations/fpe/cnpj
  vault read ${MOUNT}/transformations/fpe/email
  ```

---

## 🧹 Teardown

```bash
terraform destroy
```

---

## 🧭 References

- Vault Transform engine overview and tutorial (requires Enterprise/HCP).  
- Terraform Vault provider resources for Transform roles, templates, and transformations.  
- Transform API reference for encode/decode and configuration endpoints.

---

## ❓ FAQ

**Q: Can I make this one‑way so it cannot be decoded?**  
A: Use **tokenization** (non‑reversible) instead of FPE, or set transformations so that only `encode` is exposed to apps and **do not grant** decode permissions. (Masking is another non‑reversible option but is lossy by design.)

**Q: Can I ensure only the local‑part of emails is transformed?**  
A: Yes — the email template/transform can be configured to either include or exclude the domain. Control this with the template/regex groups and the `email_transform_domain` variable.

**Q: Do I need a custom alphabet?**  
A: Usually not for numeric CPFs/CNPJs and typical emails. You only need a custom alphabet when your template allows characters outside the built‑ins.

---

## 📝 License

Apache 2.0 – see `LICENSE`.

---

## 👀 Contributing

Issues and PRs welcome. If you spot a regex edge case for CPF/CNPJ or want additional templates (e.g., phone numbers, RG, passport), open an issue with examples.
