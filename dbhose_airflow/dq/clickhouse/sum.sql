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
      , toBool(countIf(type in (
            'Int8'
          , 'Int16'
          , 'Int32'
          , 'Int64'
          , 'Int128'
          , 'Int256'
          , 'UInt8'
          , 'UInt16'
          , 'UInt32'
          , 'UInt64'
          , 'UInt128'
          , 'UInt256'
          , 'Float32'
          , 'Float64'
          , 'Decimal32'
          , 'Decimal64'
          , 'Decimal128'
          , 'Decimal256'
        ))) as have_test
    from system.columns
    where database = table_parts[1]
        and table = table_parts[2]
    group by 1, 2
) as ht
left join (
    select 
        name as column_name
      , format(
            'select round(sum({{}}), 2) as value \n' ||
            'from {{}}'
          , column_name
          , table_name
        ) as query
      , database
      , table
    from system.columns
    where database = table_parts[1]
        and table = table_parts[2]
        and type in (
            'Int8'
          , 'Int16'
          , 'Int32'
          , 'Int64'
          , 'Int128'
          , 'Int256'
          , 'UInt8'
          , 'UInt16'
          , 'UInt32'
          , 'UInt64'
          , 'UInt128'
          , 'UInt256'
          , 'Float32'
          , 'Float64'
          , 'Decimal32'
          , 'Decimal64'
          , 'Decimal128'
          , 'Decimal256'
        )
) as qt
using(database, table)