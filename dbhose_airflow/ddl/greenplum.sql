WITH table_info AS (
    SELECT 
        CASE
            WHEN c.relkind = 'r' THEN 'TABLE'
            WHEN c.relkind = 'p' THEN 'TABLE'
            WHEN c.relkind = 'u' THEN 'UNLOGGED TABLE'
            WHEN c.relkind = 'v' THEN 'VIEW'
            WHEN c.relkind = 'm' THEN 'MATERIALIZED VIEW'
            ELSE 'UNKNOWN'
        END as object_type,
        quote_ident(n.nspname) as schema_name,
        quote_ident(c.relname) as table_name,
        pg_get_partkeydef(c.oid) as partition_by,
        col_description(c.oid, 0) as table_comment,
        am.amname as storage_type,
        c.reloptions as with_options,
        c.oid as table_oid,
        c.relkind as relkind,
        pg_get_viewdef(c.oid) as view_definition
    FROM pg_class as c
    JOIN pg_namespace as n ON c.relnamespace = n.oid
    LEFT JOIN pg_am as am ON c.relam = am.oid
    WHERE c.oid = '{table}'::regclass
),
partitions_info AS (
    SELECT
        child.relname as table_partition,
        pg_get_expr(child.relpartbound, child.oid) as partition_constraint
    FROM pg_inherits
    JOIN pg_class child ON pg_inherits.inhrelid = child.oid
    WHERE pg_inherits.inhparent = '{table}'::regclass
),
partitions_ddl AS (
    SELECT 
        string_agg(
            'CREATE TABLE IF NOT EXISTS ' || (SELECT schema_name FROM table_info) || '.' ||
            CASE
                WHEN (SELECT table_name FROM table_info) ~ '^".*"$' THEN
                    '"' || regexp_replace(table_partition, '^"|"$', '', 'g') || '_temp"'
                ELSE
                    table_partition || '_temp'
            END || 
            ' PARTITION OF ' || (SELECT schema_name FROM table_info) || '.' || 
            CASE
                WHEN (SELECT table_name FROM table_info) ~ '^".*"$' THEN
                    '"' || regexp_replace((SELECT table_name FROM table_info), '^"|"$', '', 'g') || '_temp"'
                ELSE
                    (SELECT table_name FROM table_info) || '_temp'
            END || ' ' || partition_constraint || ';',
            E'\n'
        ) as ddl
    FROM partitions_info
),
columns_info AS (
    SELECT
        quote_ident(pa.attname) as column_name,
        format_type(pa.atttypid, pa.atttypmod) as data_type,
        pg_get_expr(ad.adbin, ad.adrelid) as default_value,
        pa.attnotnull as not_null,
        col_description(pa.attrelid, pa.attnum) as column_comment,
        pa.attnum as column_order
    FROM pg_attribute as pa
    LEFT JOIN pg_attrdef as ad ON pa.attrelid = ad.adrelid AND pa.attnum = ad.adnum
    WHERE pa.attrelid = '{table}'::regclass
        AND pa.attnum > 0
        AND NOT pa.attisdropped
),
constraints_info AS (
    SELECT DISTINCT
        conname as constraint_name,
        pg_get_constraintdef(oid) as constraint_definition
    FROM pg_constraint
    WHERE conrelid = '{table}'::regclass
),
constraints_list AS (
    SELECT 
        string_agg(
            '    CONSTRAINT ' || quote_ident(constraint_name) || ' ' || constraint_definition,
            ',' || E'\n'
        ) as constraints_ddl
    FROM constraints_info
),
indexes_info AS (
    SELECT
        indexname,
        indexdef
    FROM pg_indexes 
    WHERE schemaname = 'mart'
        AND tablename = 'dim_branch'
),
indexes_ddl AS (
    SELECT 
        string_agg(indexdef || ';', E'\n') as ddl
    FROM indexes_info
),
distribution_info AS (
    SELECT
        CASE 
            WHEN policytype = 'r' THEN 'DISTRIBUTED RANDOMLY'
            WHEN policytype = 'p' THEN 'DISTRIBUTED BY (' || 
                (SELECT string_agg(quote_ident(a.attname), ', ' ORDER BY pos.ordinality)
                 FROM gp_distribution_policy p2
                 CROSS JOIN LATERAL unnest(p2.distkey) WITH ORDINALITY AS pos(attnum, ordinality)
                 JOIN pg_attribute a ON a.attrelid = p2.localoid AND a.attnum = pos.attnum
                 WHERE p2.localoid = '{table}'::regclass) || ')'
            ELSE 'DISTRIBUTED UNKNOWN'
        END as distribution_clause
    FROM gp_distribution_policy
    WHERE localoid = '{table}'::regclass
),
table_ddl AS (
    SELECT 
        'CREATE ' || 
        CASE 
            WHEN (SELECT storage_type FROM table_info) = 'heap' THEN '' 
            ELSE 'UNLOGGED ' 
        END ||
        'TABLE ' || (SELECT schema_name FROM table_info) || '.' || (SELECT table_name FROM table_info) || ' (' || E'\n' ||
        string_agg(
            '    ' || ci.column_name || ' ' || ci.data_type ||
            CASE WHEN ci.default_value IS NOT NULL THEN ' DEFAULT ' || ci.default_value ELSE '' END ||
            CASE WHEN ci.not_null THEN ' NOT NULL' ELSE '' END,
            ',' || E'\n' ORDER BY ci.column_order
        ) ||
        CASE 
            WHEN (SELECT constraints_ddl FROM constraints_list) IS NOT NULL THEN 
                ',' || E'\n' || (SELECT constraints_ddl FROM constraints_list)
            ELSE ''
        END ||
        E'\n' || ')' ||
        CASE WHEN (SELECT partition_by FROM table_info) IS NOT NULL THEN E'\nPARTITION BY ' || (SELECT partition_by FROM table_info) ELSE '' END ||
        CASE WHEN (SELECT storage_type FROM table_info) IS NOT NULL THEN E'\n' || 'USING ' || (SELECT storage_type FROM table_info) ELSE '' END ||
        CASE WHEN (SELECT with_options FROM table_info) IS NOT NULL THEN E'\n' || 'WITH (' || array_to_string((SELECT with_options FROM table_info), ', ') || ')' ELSE '' END ||
        E'\n' || (SELECT distribution_clause FROM distribution_info) || ';' as ddl
    FROM columns_info ci
    WHERE (SELECT relkind FROM table_info) IN ('r', 'p', 'u')
),
view_ddl AS (
    SELECT 
        'CREATE VIEW ' || (SELECT schema_name FROM table_info) || '.' || (SELECT table_name FROM table_info) || 
        ' AS ' || (SELECT view_definition FROM table_info) as ddl
    WHERE (SELECT relkind FROM table_info) = 'v'
),
matview_ddl AS (
    SELECT 
        'CREATE MATERIALIZED VIEW ' || (SELECT schema_name FROM table_info) || '.' || (SELECT table_name FROM table_info) || 
        ' AS ' || (SELECT view_definition FROM table_info) || 
        CASE WHEN (SELECT distribution_clause FROM distribution_info) IS NOT NULL THEN 
            E'\n' || (SELECT distribution_clause FROM distribution_info)
        ELSE '' END as ddl
    WHERE (SELECT relkind FROM table_info) = 'm'
),
column_comments_ddl AS (
    SELECT 
        string_agg(
            'COMMENT ON COLUMN ' || (SELECT schema_name FROM table_info) || '.' || (SELECT table_name FROM table_info) || 
            '.' || column_name || ' IS ' || quote_literal(column_comment) || ';',
            E'\n'
        ) as ddl
    FROM columns_info
    WHERE column_comment IS NOT NULL
),
table_comment_ddl AS (
    SELECT 
        CASE 
            WHEN (SELECT table_comment FROM table_info) IS NOT NULL THEN
                'COMMENT ON TABLE ' || (SELECT schema_name FROM table_info) || '.' || (SELECT table_name FROM table_info) || 
                ' IS ' || quote_literal((SELECT table_comment FROM table_info)) || ';'
            ELSE ''
        END as ddl
),
temp_table_ddl AS (
    SELECT 
        'CREATE UNLOGGED TABLE IF NOT EXISTS ' || (SELECT schema_name FROM table_info) || '.' || 
        CASE
            WHEN (SELECT table_name FROM table_info) ~ '^".*"$' THEN
                '"' || regexp_replace((SELECT table_name FROM table_info), '^"|"$', '', 'g') || '_temp"'
            ELSE
                (SELECT table_name FROM table_info) || '_temp'
        END || ' (' || E'\n' ||
        string_agg(
            '    ' || ci.column_name || ' ' || ci.data_type ||
            CASE WHEN ci.default_value IS NOT NULL THEN ' DEFAULT ' || ci.default_value ELSE '' END ||
            CASE WHEN ci.not_null THEN ' NOT NULL' ELSE '' END,
            ',' || E'\n' ORDER BY ci.column_order
        ) || E'\n' || ')' ||
        CASE WHEN (SELECT partition_by FROM table_info) IS NOT NULL THEN 
            E'\nPARTITION BY ' || (SELECT partition_by FROM table_info)
        ELSE '' END || ';' ||
        CASE 
            WHEN (SELECT ddl FROM partitions_ddl) IS NOT NULL THEN 
                E'\n' || E'\n' || (SELECT ddl FROM partitions_ddl)
            ELSE ''
        END as ddl
    FROM columns_info ci
),
final_original_ddl AS (
    SELECT 
        COALESCE(
            (SELECT ddl FROM table_ddl),
            (SELECT ddl FROM view_ddl),
            (SELECT ddl FROM matview_ddl)
        ) ||
        CASE 
            WHEN (SELECT ddl FROM indexes_ddl) IS NOT NULL THEN 
                E'\n' || (SELECT ddl FROM indexes_ddl)
            ELSE ''
        END ||
        CASE 
            WHEN (SELECT ddl FROM table_comment_ddl) != '' THEN 
                E'\n' || (SELECT ddl FROM table_comment_ddl)
            ELSE ''
        END ||
        CASE 
            WHEN (SELECT ddl FROM column_comments_ddl) IS NOT NULL THEN 
                E'\n' || (SELECT ddl FROM column_comments_ddl)
            ELSE ''
        END as original_ddl
)
SELECT
    (SELECT original_ddl FROM final_original_ddl) as ddl,
    (SELECT ddl FROM temp_table_ddl) as temp_ddl,
    (SELECT schema_name FROM table_info) || '.' || 
        CASE
            WHEN (SELECT table_name FROM table_info) ~ '^".*"$' THEN
                '"' || regexp_replace((SELECT table_name FROM table_info), '^"|"$', '', 'g') || '_temp"'
            ELSE
                (SELECT table_name FROM table_info) || '_temp'
        END as table_temp