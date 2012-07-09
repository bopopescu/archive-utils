\! rm -f /tmp/_gen_privileges_ddl.sql
\r
\t
\o /tmp/_gen_privileges_ddl.sql
select 'grant all privileges on "' || table_name || '" to dw_dev;' from
v_catalog.tables where table_schema='public';
select 'grant select on "' || table_name || '" to dw_readonly;' from
v_catalog.tables where table_schema='public';
\o
\i /tmp/_gen_privileges_ddl.sql
