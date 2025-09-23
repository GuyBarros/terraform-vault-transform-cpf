# parquet_reader.py
from __future__ import annotations
import pandas as pd
from typing import List, Dict, Any

def read_parquet_to_json(in_path: str, engine: str = "fastparquet") -> list[dict[str, Any]]:
    """
    Reads a Parquet file and returns a list of dict records (JSON-like).
    """
    df = pd.read_parquet(in_path, engine=engine)
    # Convert to pure Python types
    return df.to_dict(orient="records")

if __name__ == "__main__":
    import argparse, json
    ap = argparse.ArgumentParser(description="Read Parquet and print JSON records.")
    ap.add_argument("--in", dest="in_path", required=True)
    ap.add_argument("--engine", default="fastparquet")
    args = ap.parse_args()

    records = read_parquet_to_json(args.in_path, engine=args.engine)
    print(json.dumps(records, ensure_ascii=False, indent=2))
