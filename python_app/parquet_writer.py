# parquet_writer.py
from __future__ import annotations
import json
from typing import Any, Dict, List
import pandas as pd

def _filter_encoded_only(records: List[Dict[str, Any]], suffix: str) -> List[Dict[str, Any]]:
    """Return new records keeping only keys that end with `suffix`."""
    out: List[Dict[str, Any]] = []
    for r in records:
        out.append({k: v for k, v in r.items() if isinstance(k, str) and k.endswith(suffix)})
    return out

def write_parquet_from_json_encoded(
    records: List[Dict[str, Any]],
    out_path: str,
    suffix: str = "_enc",
    engine: str = "fastparquet",
) -> None:
    """
    Writes ONLY encoded fields (keys ending with `suffix`) to a Parquet file.
    """
    if not records:
        raise ValueError("No records provided.")

    filtered = _filter_encoded_only(records, suffix=suffix)

    # Ensure at least one encoded key exists across records
    has_any_encoded = any(len(r) > 0 for r in filtered)
    if not has_any_encoded:
        raise ValueError(
            f"No encoded fields found with suffix '{suffix}'. "
            "Did you run the transformer and/or set the correct suffix?"
        )

    df = pd.DataFrame(filtered)
    df.to_parquet(out_path, engine=engine, index=False)

if __name__ == "__main__":
    import argparse, sys

    ap = argparse.ArgumentParser(description="Write Parquet from JSON records (encoded fields only).")
    ap.add_argument("--out", dest="out_path", required=True, help="Output Parquet path")
    ap.add_argument("--suffix", default="_enc", help="Suffix for encoded fields (default: _enc)")
    ap.add_argument("--engine", default="fastparquet", help="Parquet engine (default: fastparquet)")
    args = ap.parse_args()

    raw = sys.stdin.read().strip()
    if not raw:
        raise SystemExit("No input JSON provided on stdin.")

    data = json.loads(raw)
    if isinstance(data, dict):
        data = [data]

    write_parquet_from_json_encoded(data, out_path=args.out_path, suffix=args.suffix, engine=args.engine)
    print(f"Saved {args.out_path}")
