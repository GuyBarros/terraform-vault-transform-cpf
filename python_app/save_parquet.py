import json
import pandas as pd

# ---- Load data from example.json --------------------------------------------
with open("example.json", "r", encoding="utf-8") as f:
    record = json.load(f)

# ---- Build DataFrame --------------------------------------------------------
df = pd.DataFrame([record])

# Optional: also include a JSON-string version of the list for portability
if isinstance(df.at[0, "proof_of_income"], list):
    df["proof_of_income_json"] = df["proof_of_income"].apply(lambda x: json.dumps(x, ensure_ascii=False))

# ---- Save as Parquet with fastparquet --------------------------------------
out_path = "loan_application.parquet"
df.to_parquet(out_path, engine="fastparquet", index=False)

print(f"Saved {out_path}")
