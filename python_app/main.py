# main.py
from __future__ import annotations
import argparse
import logging
from parquet_reader import read_parquet_to_json
from vault_transformer import encode_json_records
from parquet_writer import write_parquet_from_json_encoded

logging.basicConfig(level=logging.ERROR)

def run(in_path: str, out_path: str, engine: str, suffix: str, chunk_size: int):
    # Step 1: Parquet -> JSON
    records = read_parquet_to_json(in_path, engine=engine)
    logging.debug("read from parquet file: ", records)
    # Step 2: JSON -> encoded JSON
    encoded_records = encode_json_records(records, suffix=suffix)
    logging.debug("encrypted values: ", encoded_records)
    # Step 3: encoded JSON -> Parquet
    write_parquet_from_json_encoded(encoded_records, out_path, engine=engine)
    print(f"Saved {out_path}")

if __name__ == "__main__":
    ap = argparse.ArgumentParser(description="Parquet -> Vault Transform -> Parquet")
    ap.add_argument("--in", dest="in_path", required=True, help="Input Parquet path")
    ap.add_argument("--out", dest="out_path", required=True, help="Output Parquet path")
    ap.add_argument("--engine", default="fastparquet", help="Parquet engine (fastparquet)")
    ap.add_argument("--suffix", default="_enc", help="Suffix for encoded fields (default: _enc)")
    ap.add_argument("--chunk-size", type=int, default=500, help="Vault batch size (default: 500)")
    args = ap.parse_args()
    run(args.in_path, args.out_path, args.engine, args.suffix, args.chunk_size)

# Example 
# python main.py --in loan_application.parquet --out loan_application_encoded.parquet
