-- ****** NOTE ******
-- You MUST run this as "dbadmin"
-- and you should run this only once

-- Created a Vertica database: dw
-- Put directories (catalog, dta) under /data/db_dw

-- The root pwd for "dw" database is that for dbadmin's vsql pwd.

-- create roles, users; and assign privileges, etc.
create role dw_dev;
create role dw_readonly;

create user jasper_report identified by 'jshdfp98yhf4';
grant dw_readonly to jasper_report;
alter user jasper_report default role dw_readonly;

create user bing identified by 'seattle';
grant dw_dev to bing;
alter user bing default role dw_dev;

create user nick identified by 'nicklockerz';
grant dw_dev to nick;
alter user nick default role dw_dev;

