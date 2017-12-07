--  Procedure for drop table primary key by table name
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SP_DROP_PRIMARY_KEY" (table_name_in varchar2) as
begin
declare
sql_var varchar(200):=null;
constraint_name_var varchar(30):=null;
begin
SELECT
cons.constraint_name into constraint_name_var
FROM all_constraints cons
join all_cons_columns cols on cons.constraint_name = cols.constraint_name AND cons.owner = cols.owner and cons.constraint_type = 'P'
join user_tables on user_tables.table_name=cols.table_name
where cols.table_name=table_name_in and cols.owner=(select user from dual)
GROUP BY
cons.constraint_name;
if(constraint_name_var is not null) then
  sql_var:='alter table '||table_name_in||' drop constraint '||constraint_name_var;
  execute immediate(sql_var);
end if;
exception when NO_DATA_FOUND then null;
end;
end;
/