with
    splitByChar(',', replaceAll('{filter_by}', ' ', '')) as columns,
    length(columns) as columns_count,
    (
        select groupArray(tuple({filter_by}))
        from (
            select distinct {filter_by}
            from {table_temp}
        )
    ) as values_tuples
select
    true as is_avaliable,
    'ALTER TABLE {table_dest} DELETE WHERE ' ||
    if(columns_count > 1, '(' || arrayStringConcat(columns, ', ') || ')', arrayStringConcat(columns, ', ')) ||
    ' IN (' ||
    arrayStringConcat(
        arrayDistinct(
            arrayMap(
                tuple ->
                    if(columns_count = 1,
                        (case
                            when isNull(tuple.1) then 'NULL'
                            when toTypeName(tuple.1) REGEXP 'U?Int|B?Float|Decimal|Bool' then toString(tuple.1)
                            else '\'' || replaceAll(toString(tuple.1), '\'', '\\\'') || '\''
                        end),
                    if(columns_count = 2,
                        '(' ||
                        (case
                            when isNull(tuple.1) then 'NULL'
                            when toTypeName(tuple.1) REGEXP 'U?Int|B?Float|Decimal|Bool' then toString(tuple.1)
                            else '\'' || replaceAll(toString(tuple.1), '\'', '\\\'') || '\''
                        end) || ', ' ||
                        (case
                            when isNull(tuple.2) then 'NULL'
                            when toTypeName(tuple.2) REGEXP 'U?Int|B?Float|Decimal|Bool' then toString(tuple.2)
                            else '\'' || replaceAll(toString(tuple.2), '\'', '\\\'') || '\''
                        end) || ')',
                    if(columns_count = 3,
                        '(' ||
                        (case
                            when isNull(tuple.1) then 'NULL'
                            when toTypeName(tuple.1) REGEXP 'U?Int|B?Float|Decimal|Bool' then toString(tuple.1)
                            else '\'' || replaceAll(toString(tuple.1), '\'', '\\\'') || '\''
                        end) || ', ' ||
                        (case
                            when isNull(tuple.2) then 'NULL'
                            when toTypeName(tuple.2) REGEXP 'U?Int|B?Float|Decimal|Bool' then toString(tuple.2)
                            else '\'' || replaceAll(toString(tuple.2), '\'', '\\\'') || '\''
                        end) || ', ' ||
                        (case
                            WHEN isNull(tuple.3) THEN 'NULL'
                            WHEN toTypeName(tuple.3) REGEXP 'U?Int|B?Float|Decimal|Bool' THEN toString(tuple.3)
                            ELSE '\'' || replaceAll(toString(tuple.3), '\'', '\\\'') || '\''
                        END) || ')',
                        '(' ||
                        (CASE
                            WHEN isNull(tuple.1) THEN 'NULL'
                            WHEN toTypeName(tuple.1) REGEXP 'U?Int|B?Float|Decimal|Bool' THEN toString(tuple.1)
                            ELSE '\'' || replaceAll(toString(tuple.1), '\'', '\\\'') || '\''
                        END) || ', ' ||
                        (CASE
                            WHEN isNull(tuple.2) THEN 'NULL'
                            WHEN toTypeName(tuple.2) REGEXP 'U?Int|B?Float|Decimal|Bool' THEN toString(tuple.2)
                            ELSE '\'' || replaceAll(toString(tuple.2), '\'', '\\\'') || '\''
                        END) || ', ' ||
                        (case
                            when isNull(tuple.3) then 'NULL'
                            when toTypeName(tuple.3) REGEXP 'U?Int|B?Float|Decimal|Bool' then toString(tuple.3)
                            else '\'' || replaceAll(toString(tuple.3), '\'', '\\\'') || '\''
                        end) || ', ' ||
                        (case
                            when isNull(tuple.4) then 'NULL'
                            when toTypeName(tuple.4) REGEXP 'U?Int|B?Float|Decimal|Bool' then toString(tuple.4)
                            else '\'' || replaceAll(toString(tuple.4), '\'', '\\\'') || '\''
                        end) || ')'
                    ))),
                values_tuples
            )
        ),
        ', '
    ) || ');\nINSERT INTO {table_dest}\nSELECT * FROM {table_temp};' as move_query