import pandas as pd
import hvac


df = pd.read_parquet("loan_application_encoded.parquet", engine="fastparquet")
record = df.iloc[0].to_dict()
print(record)

