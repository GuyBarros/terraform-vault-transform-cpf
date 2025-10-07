export POSTGRES_ADDR=<POSTGRES_URL>:5432
export POSTGRES_DATABASE=<POSTGRES_DATABASE_NAME>
export POSTGRES_USERNAME=<POSTGRES_USERNAME>
export POSTGRES_PASSWORD=<POSTGRES_PASSWORD>


psql -h $POSTGRES_HOST -U $POSTGRES_USERNAME -d $POSTGRES_DATABASE

\dt

SELECT table_schema, table_name 
FROM information_schema.tables 
WHERE table_type='BASE TABLE'
ORDER BY table_schema, table_name;






                  List of tables
 Schema |         Name          | Type  |   Owner    
--------+-----------------------+-------+------------
 public | token_schema_versions | table | postgresql
 public | tokens                | table | postgresql

pg_dump -h $POSTGRES_HOST -U $POSTGRES_USERNAME -d $POSTGRES_DATABASE -t your_table_name --schema-only
pg_dump -h $POSTGRES_HOST -U $POSTGRES_USERNAME -d $POSTGRES_DATABASE -t tokens --schema-only > tokens_table.sql
pg_dump -h $POSTGRES_HOST -U $POSTGRES_USERNAME -d $POSTGRES_DATABASE -t token_schema_versions --schema-only > token_schema_versions_table.sql


postgress=> SELECT * FROM tokens;
                            storage_token                            | key_version |                                        ciphertext                                        | encrypted_metadata |                            fingerprint                             | expiration_time |         creation_time         
--------------------------------------------------------------------+-------------+------------------------------------------------------------------------------------------+--------------------+--------------------------------------------------------------------+-----------------+-------------------------------
 \xf0fb79c833f70e1d9cc4f3ef8f3f8892baaed8a69d611fcf29d5e2e5725596f8 |           1 | \x282b8a697d6ddeb3a8e174859ff870bb13ea3b5d9f85b83a0f104bb7213de9a57061c715f659           |                    | \xc8a2a36b3c39a062745fbd037086df23558e677096d8145589bc0ef682e6e538 |                 | 2025-10-07 15:16:06.837951+00
 \xb15bbcf134f26e7339fd8afec9994264c43fdd927bb11bce765b9ced5208b147 |           1 | \xb59a15bd0b40a5cf7c71141239d6c5ba297cffe961606fda66f455f847644ca7ea8cff5456ba2df851a42c |                    | \x40288d5251a99f01e6b3fc11b9bdb762a20105ef2088067774285956bb9fe816 |                 | 2025-10-07 15:16:17.969694+00
 \xe97bceb75efc9e356e9ccf6171851402f2a09991be0452929cd7e4feb01201e0 |           1 | \x7cc52ae7f8b3938ed6b680a38ddd6f8761f0c1b5b9e8293399a5d23ef29dc7d7083969fef4b2           |                    | \xc8a2a36b3c39a062745fbd037086df23558e677096d8145589bc0ef682e6e538 |                 | 2025-10-07 15:16:17.991501+00
 \x069a3d3d691f313a65a3861d8a7306ac5f5130fb679e2d1a0f2ecc865e435491 |           1 | \x66a7b71a52ea889b8547a14c81bc7f7196600e4fc23e2488f7568e7198c22321da841b188e2d8cea       |                    | \x7c6d588a394cd5b545614c5a39ebe0da28f732ea079efe2891b5958eb5de5af7 |                 | 2025-10-07 15:16:18.012766+00
 \xa57d516ef9bf5d6370e355d24237e14bdb51a48bbc195f27db0401afd9fec631 |           1 | \xf7d0e347227824a0ae5c3cf9ae097364d0caffd39851bf2648e06be8731cffd7e1659c276aed           |                    | \x88bfde55ff22105deb95b65dbf309013a0d6dbe0221d207c548cf4786ddc1bf0 |                 | 2025-10-07 15:22:46.188523+00
(5 rows)
postgress=> SELECT * FROM token_schema_versions;
 version 
---------
       1
(1 row)