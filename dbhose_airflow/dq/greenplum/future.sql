with cte as (
    select '{table}'::regclass as table_class
)
select
    have_test
  , column_name
  , query
from (
    select 
        n.nspname::text as schema_name
      , c.relname::text as table_name
      , count(*) filter(
            where format_type(a.atttypid, a.atttypmod) in (
                'date'
              , 'timestamp with time zone'
              , 'timestamp without time zone'
            )
        ) > 0 as have_test
    from pg_class as c
    join pg_namespace as n
        on n.oid = c.relnamespace
    join pg_attribute as a
        on a.attrelid = c.oid
    where c.oid = (select table_class from cte)
        and a.attnum > 0
        and not a.attisdropped
    group by 1, 2
) as ht
left join (
    select 
        a.attname::text as column_name
      , n.nspname::text as schema_name
      , c.relname::text as table_name
      , format(
            e'select count(*) as value, case when count(*) = 0 then ''Pass'' else ''Fail'' end as result \n' ||
            e'from %I.%I where %I > (current_date + interval ''1 month'')'
          , n.nspname
          , c.relname
          , a.attname
        ) as query
    from pg_attribute as a
    join pg_class as c
        on a.attrelid = c.oid
    join pg_namespace as n
        on n.oid = c.relnamespace
    where c.oid = (select table_class from cte)
        and a.attnum > 0 
        and not a.attisdropped
        and format_type(a.atttypid, a.atttypmod) in (
            'date'
          , 'timestamp with time zone'
          , 'timestamp without time zone'
        )
) as qt
using(schema_name, table_name)