with 
    matching_partitions as (
        select
            table_partition
          , partition_constraint
        from (
            select
                child.relname as table_partition
              , pg_get_expr(child.relpartbound, child.oid) as partition_constraint
            from pg_inherits
            join pg_class child
                on pg_inherits.inhrelid = child.oid
            where pg_inherits.inhparent = '{table_dest}'::regclass
        ) as dest_tbl
        join (
            select
                pg_get_expr(child.relpartbound, child.oid) as partition_constraint
              , child.oid as partition_oid
            from pg_inherits
            join pg_class child
                on pg_inherits.inhrelid = child.oid
            where pg_inherits.inhparent = '{table_temp}'::regclass
        ) as temp_tbl
        using(partition_constraint)
        where exists (
            select 1
            from pg_class
            where oid = temp_tbl.partition_oid
                and reltuples > 0
        )
    ),
    detach_commands as (
        select string_agg(
            'ALTER TABLE {table_dest} DETACH PARTITION ' ||
            table_partition || ';'
          , E'\n'
        ) as commands
        from matching_partitions
    ),
    attach_commands as (
        select string_agg(
            'ALTER TABLE {table_dest} ATTACH PARTITION {table_temp} ' ||
            partition_constraint || ';'
          , E'\n'
        ) as commands
        from matching_partitions
    ),
    drop_commands as (
        select string_agg(
            'DROP TABLE ' || table_partition || ';'
          , E'\n'
        ) as commands
        from matching_partitions
    )
select
    (select case when count(*) > 0 then true else false end
     from matching_partitions) as is_avaliable
  , (select commands from detach_commands) || E'\n' ||
    (select commands from attach_commands) || E'\n' ||
    (select commands from drop_commands) as move_query