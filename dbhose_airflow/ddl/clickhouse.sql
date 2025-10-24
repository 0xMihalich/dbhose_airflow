WITH
    split_table AS (
        SELECT 
            splitByChar('.', '{table}')[1] as db,
            splitByChar('.', '{table}')[2] as tbl
    ),
    original_ddl AS (
        SELECT create_table_query
        FROM system.tables 
        WHERE database = (SELECT db FROM split_table)
          AND name = (SELECT tbl FROM split_table)
    ),
    columns_data AS (
        SELECT 
            groupArray(
                tuple(name, type, default_expression, comment)
            ) as cols
        FROM (
            SELECT 
                name,
                type,
                default_expression,
                comment
            FROM system.columns 
            WHERE database = (SELECT db FROM split_table)
              AND table = (SELECT tbl FROM split_table)
            ORDER BY position
        )
    ),
    table_info AS (
        SELECT 
            partition_key,
            sorting_key,
            primary_key
        FROM system.tables 
        WHERE database = (SELECT db FROM split_table)
          AND name = (SELECT tbl FROM split_table)
    ),
    order_by_clause AS (
        SELECT 
            if((SELECT sorting_key FROM table_info) != '', 
               concat('ORDER BY (', (SELECT sorting_key FROM table_info), ')'),
               if((SELECT primary_key FROM table_info) != '',
                  concat('ORDER BY (', (SELECT primary_key FROM table_info), ')'),
                  'ORDER BY tuple()'
               )
            ) as order_by
    )
SELECT
    (SELECT create_table_query FROM original_ddl) as ddl,
    concat(
        'CREATE TABLE IF NOT EXISTS ',
        (SELECT db FROM split_table),
        '.',
        (SELECT tbl FROM split_table),
        '_temp\n(\n',
        arrayStringConcat(
            arrayMap(
                c -> concat('    ', c.1, ' ', c.2,
                           if(c.3 != '', concat(' DEFAULT ', c.3), ''),
                           if(c.4 != '', concat(' COMMENT ''', c.4, ''''), '')
                ),
                (SELECT cols FROM columns_data)
            ),
            ',' || '\n'
        ),
        '\n)\nENGINE = MergeTree()',
        if((SELECT partition_key FROM table_info) != '', 
           concat('\nPARTITION BY ', (SELECT partition_key FROM table_info)), 
           ''),
        if((SELECT order_by FROM order_by_clause) != '', 
           concat('\n', (SELECT order_by FROM order_by_clause)), 
           ''),
        '\nSETTINGS index_granularity = 8192'
    ) as temp_ddl,
    concat(
        (SELECT db FROM split_table),
        '.',
        (SELECT tbl FROM split_table),
        '_temp'
    ) as table_temp