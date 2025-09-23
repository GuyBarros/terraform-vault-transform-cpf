# vault_transformer.py
from __future__ import annotations
import os
import json
from typing import Any, Dict, List
import hvac
from dotenv import load_dotenv

load_dotenv()

# -------------------- Vault config --------------------
VAULT_ADDR = os.getenv("VAULT_ADDR", "").rstrip("/")
VAULT_TOKEN = os.getenv("VAULT_TOKEN", "")
VAULT_NAMESPACE = os.getenv("VAULT_NAMESPACE", "root")
VAULT_TRANSFORM_PATH = os.getenv("VAULT_TRANSFORM_PATH", "org")
VAULT_TRANSFORM_ROLE = os.getenv("VAULT_TRANSFORM_ROLE", "agent")

# -------------------- Transform mapping --------------------
_TRANSFORM_FIELD_MAP_RAW = os.getenv("TRANSFORM_FIELD_MAP", "").strip()
if _TRANSFORM_FIELD_MAP_RAW:
    try:
        TRANSFORM_FIELD_MAP: Dict[str, str] = json.loads(_TRANSFORM_FIELD_MAP_RAW)
    except json.JSONDecodeError as e:
        raise RuntimeError(f"TRANSFORM_FIELD_MAP is not valid JSON: {e}")
else:
    TRANSFORM_FIELD_MAP = {
        k: v for k, v in {
            "cpf": os.getenv("CPF_TRANSFORMATION"),
            "bank_account_number": os.getenv("BANK_ACCOUNT_TRANSFORMATION"),
            "bank_agency": os.getenv("BANK_AGENCY_TRANSFORMATION"),
            "name": os.getenv("NAME_TRANSFORMATION"),
            "address": os.getenv("ADDRESS_TRANSFORMATION"),
            "cnpj": os.getenv("CNPJ_TRANSFORMATION"),
            "email": os.getenv("EMAIL_TRANSFORMATION"),
            "contract_id": os.getenv("CONTRACT_TRANSFORMATION"),
            "product": os.getenv("PRODUCT_TRANSFORMATION"),
        }.items() if v
    }

# Optional TTL & metadata
TRANSFORM_TTL = os.getenv("TRANSFORM_TTL", "").strip() or None
_METADATA_RAW = os.getenv("TRANSFORM_METADATA_JSON", "").strip()
if _METADATA_RAW:
    try:
        TRANSFORM_METADATA = json.loads(_METADATA_RAW)
    except json.JSONDecodeError as e:
        raise RuntimeError(f"TRANSFORM_METADATA_JSON is not valid JSON: {e}")
else:
    TRANSFORM_METADATA = None

# -------------------- HVAC client --------------------
def _get_client() -> hvac.Client:
    if not VAULT_ADDR or not VAULT_TOKEN:
        raise RuntimeError("VAULT_ADDR and VAULT_TOKEN must be set.")
    client = hvac.Client(url=VAULT_ADDR, token=VAULT_TOKEN, namespace=VAULT_NAMESPACE, verify=False)
    if not client.is_authenticated():
        raise RuntimeError("Vault authentication failed.")
    return client

# -------------------- Core API --------------------
def encode_json_records(
    records: List[Dict[str, Any]],
    suffix: str = "_enc",
) -> List[Dict[str, Any]]:
    """
    Encodes fields in each record using Vault Transform.
    Returns ONLY the encoded fields (with suffix).
    """
    if not records or not TRANSFORM_FIELD_MAP:
        return records

    client = _get_client()
    encoded_records: List[Dict[str, Any]] = []

    for rec in records:
        batch_input: List[Dict[str, Any]] = []
        field_order: List[str] = []

        for field, transformation in TRANSFORM_FIELD_MAP.items():
            if field in rec and rec[field] is not None:
                item: Dict[str, Any] = {
                    "value": str(rec[field]),
                    "transformation": transformation,
                    "reference": field,
                }
                if TRANSFORM_TTL:
                    item["ttl"] = TRANSFORM_TTL
                if TRANSFORM_METADATA:
                    item["metadata"] = TRANSFORM_METADATA
                batch_input.append(item)
                field_order.append(field)

        if not batch_input:
            encoded_records.append({})
            continue

        resp = client.secrets.transform.encode(
            mount_point=VAULT_TRANSFORM_PATH,
            role_name=VAULT_TRANSFORM_ROLE,
            batch_input=batch_input,
        )
        results = (resp or {}).get("data", {}).get("batch_results", [])
        if len(results) != len(batch_input):
            raise RuntimeError(
                f"Vault response size mismatch: got {len(results)} results for {len(batch_input)} inputs."
            )

        out: Dict[str, Any] = {}
        for field, result in zip(field_order, results):
            enc = result.get("encoded_value")
            out[f"{field}{suffix}"] = enc if enc is not None else None
        encoded_records.append(out)

    return encoded_records

# -------------------- CLI --------------------
if __name__ == "__main__":
    import sys
    import argparse

    ap = argparse.ArgumentParser(description="Encode JSON via Vault Transform (return only encoded fields).")
    ap.add_argument("--suffix", default="_enc", help="Suffix for encoded fields (default: _enc)")
    args = ap.parse_args()

    raw = sys.stdin.read().strip()
    if not raw:
        print("[]")
        sys.exit(0)

    data = json.loads(raw)
    if isinstance(data, dict):
        data = [data]

    out = encode_json_records(data, suffix=args.suffix)
    
