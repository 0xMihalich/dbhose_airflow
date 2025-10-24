with 
    filter_columns as (
    select
        array_length(string_to_array('{filter_by}', ', '), 1) as col_count
)
  , placeholders as (
    select
        string_agg('%L', ', ') as values_placeholders
    from generate_series(1, (select col_count from filter_columns))
)
  , values_list as (
    select 
        string_agg(
            format('(' || (select values_placeholders from placeholders) || ')', {filter_by}), 
            ', '
        ) as in_values
    from {table_temp}
)
select
    true as is_avaliable
  , 'delete from {table_dest} where ({filter_by}) in (' ||
    in_values || ')' as move_query
from values_list