--------------------------------------------------------
--  Drop table column foreign key
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "IFF_SP_DROP_FOREIGN_KEY" (table_name_in varchar2,column_name_in varchar2) as
begin
for x in(SELECT
c.constraint_name
  FROM all_cons_columns a
  JOIN all_constraints c ON a.owner = c.owner
AND a.constraint_name = c.constraint_name
 WHERE c.constraint_type = 'R' and a.TABLE_NAME=table_name_in and a.COLUMN_NAME=column_name_in
 and c.r_owner=(select user from dual) group by c.constraint_name) loop
	  execute immediate 'alter table '|| table_name_in ||' drop constraint '|| x.constraint_name;
end loop;
end;
/