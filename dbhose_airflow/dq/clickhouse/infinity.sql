with
    replaceAll('{table}', '`', '') as table_name
  , splitByChar('.', table_name) as table_parts
select
    have_test
  , column_name
  , query
from (
    select
        database
      , table
      , toBool(countIf(type like 'Float%')) as have_test
    from system.columns
    where database = table_parts[1]
        and table = table_parts[2]
    group by 1, 2
) as ht
left join (
    select 
        name as column_name
      , format(
            'select count(*) as value, if(count() = 0, ''Pass'', ''Fail'') as result \n' ||
            'from {{}} where isInfinite({{}})'
          , table_name
          , column_name
        ) as query
      , database
      , table
    from system.columns
    where database = table_parts[1]
        and table = table_parts[2]
        and type like 'Float%'
) as qt
using(database, table)