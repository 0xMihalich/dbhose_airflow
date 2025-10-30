with filter_columns as (
    select array_length(string_to_array('{filter_by}', ', '), 1) as col_count
)
select
    true as is_avaliable,
    'DELETE FROM {table_dest} WHERE EXISTS(' || E'\nSELECT 1 FROM {table_temp}\nWHERE ' || 
    (select string_agg('{table_dest}.' || trim(col) || ' = {table_temp}.' || trim(col), E'\nAND ') 
     from unnest(string_to_array('{filter_by}', ',')) as col) || E'\n);\n' ||
    E'INSERT INTO {table_dest}\nSELECT * FROM {table_temp};' as move_query
from filter_columns