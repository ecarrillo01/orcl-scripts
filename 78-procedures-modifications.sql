--------------------------------------------------------
-- Archivo creado  - domingo-mayo-07-2017   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure IFF_SP_DELETE_TABLE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "IFF_SP_DELETE_TABLE" (table_id_var varchar2) as
  begin
    declare no_data_found exception;
    pragma EXCEPTION_INIT (no_data_found,-06512);
    sql_var varchar(200);
    begin
       sql_var:='delete from iff_role_menu_items where item_id in(select item_id from iff_menu_items where parameters='''||table_id_var||''')';
       Dbms_Output.Put_Line('sp_delete_table: '||sql_var);
       execute immediate(sql_var);
       sql_var:='delete from iff_menu_items where parameters='''||table_id_var||'''';
       Dbms_Output.Put_Line('sp_delete_table: '||sql_var);
       execute immediate(sql_var);
       sql_var:='delete from iff_role_tables where table_id='||table_id_var;
       Dbms_Output.Put_Line('sp_delete_table: '||sql_var);
       execute immediate(sql_var);
       sql_var:='delete from iff_tables where table_id='||table_id_var;
       Dbms_Output.Put_Line('sp_delete_table: '||sql_var);
       execute immediate(sql_var);
    end;
    EXCEPTION when no_data_found then
    Dbms_Output.Put_Line('sp_delete_table:No data found for '||table_id_var);
end;

/
--------------------------------------------------------
--  DDL for Procedure IFF_SP_DELETE_TABLE_COLUMN
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "IFF_SP_DELETE_TABLE_COLUMN" (table_id_var varchar2,column_name_var varchar2) as
  begin
    declare no_data_found exception;
    pragma EXCEPTION_INIT (no_data_found,-06512);
    sql_var varchar(200);
    c_id_var number:=0;
    begin
      select t1.column_id into c_id_var from iff_table_columns t1 join iff_tables t2 on t1.table_id=t2.table_id
      where t2.table_id=table_id_var and t1.column_name=column_name_var;
       sql_var:='delete from iff_role_table_columns where table_id='||table_id_var||' and column_id='||c_id_var;
       Dbms_Output.Put_Line('sp_delete_table_column: '||sql_var);
       execute immediate(sql_var);
       sql_var:='delete from iff_table_columns where table_id='||table_id_var||' and column_id='||c_id_var;
       Dbms_Output.Put_Line('sp_delete_table_column: '||sql_var);
       execute immediate(sql_var);
    end;
    EXCEPTION when no_data_found then
    Dbms_Output.Put_Line('sp_delete_table_column: no data found for '||table_id_var||' with '||column_name_var);
  end;

/
--------------------------------------------------------
--  DDL for Procedure IFF_SP_DROP_FOREIGN_KEY
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
--------------------------------------------------------
--  DDL for Procedure IFF_SP_DROP_PRIMARY_KEY
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "IFF_SP_DROP_PRIMARY_KEY" (table_name_in varchar2) as
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
  Dbms_Output.Put_Line('iff_sp_drop_primary_key: '||sql_var);
  execute immediate(sql_var);
end if;
exception when NO_DATA_FOUND then null;
end;
end;

/
--------------------------------------------------------
--  DDL for Procedure IFF_SP_INSERT_MENU_ITEMS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "IFF_SP_INSERT_MENU_ITEMS" (table_name_in IN varchar2)
IS
function_id_var pls_integer;
menu_type_id_var pls_integer;
item_name_var varchar2(30);
already_exists pls_integer:=0;
BEGIN
    item_name_var:= REPLACE(table_name_in, '_', ' ');
    SELECT function_id into function_id_var
    FROM iff_functions where function_name= 'iffUser.get_table' and rownum < 2 ;
     SELECT menu_type_id into menu_type_id_var
     FROM iff_menu_item_types where rownum < 2 ;
select count(*) into already_exists from IFF_MENU_ITEMS where parameters=table_name_in;
if(already_exists=0) then
    INSERT INTO IFF_MENU_ITEMS(ITEM_NAME,FUNCTION_ID,PARAMETERS,MENU_TYPE_ID) VALUES(item_name_var,function_id_var,table_name_in,menu_type_id_var);
end if;
END;

/
--------------------------------------------------------
--  DDL for Procedure IFF_SP_INSERT_RL_TBL_COLS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "IFF_SP_INSERT_RL_TBL_COLS" (role_id_in IN varchar2,table_id_in IN varchar2) AS
BEGIN
  DECLARE
  CURSOR iff_cursor IS
  SELECT * FROM IFF_TABLE_COLUMNS WHERE table_id = table_id_in;
  BEGIN
   FOR x in iff_cursor
   LOOP
   INSERT INTO IFF_ROLE_TABLE_COLUMNS (role_id,table_id,column_id,editable,visible) VALUES(role_id_in,table_id_in,x.COLUMN_ID,1,1);
   END LOOP;
  END;
  END;

/
--------------------------------------------------------
--  DDL for Procedure IFF_SP_INSERT_ROLE_MENU_ITEMS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "IFF_SP_INSERT_ROLE_MENU_ITEMS" (role_id_in in number,out_val out number) AS
BEGIN
  DECLARE
  var1 number;
  var2 number;
  CURSOR iff_cur IS
select item_id from iff_menu_items where item_id not in (select item_id from iff_role_menu_items where role_id=role_id_in);
  BEGIN
  out_val:=0;
   FOR x in iff_cur
   LOOP
   INSERT INTO IFF_ROLE_MENU_ITEMS VALUES(role_id_in,x.ITEM_ID);
   END LOOP;
   select count(*) into var1 from iff_menu_items;
   select count(*) into var2 from iff_role_menu_items where role_id=role_id_in;
   if(var1=var2) then
     out_val:=1;
   end if;
  END;
  END;

/
--------------------------------------------------------
--  DDL for Procedure IFF_SP_INSERT_ROLE_TABLES
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "IFF_SP_INSERT_ROLE_TABLES" (role_id_in in varchar2,out_val out number) AS
BEGIN
  DECLARE
  var1 number;
  var2 number;
  CURSOR iff_cur IS
select table_id from iff_tables where table_id not in (select table_id from iff_role_tables where role_id=role_id_in);
  BEGIN
  out_val:=0;
   FOR x in iff_cur
   LOOP
   INSERT INTO IFF_ROLE_TABLES VALUES(role_id_in,x.TABLE_ID);
   END LOOP;
   select count(*) into var1 from iff_tables;
   select count(*) into var2 from iff_role_tables where role_id=role_id_in;
   if(var1=var2) then
     out_val:=1;
   end if;
  END;
  END;

/
--------------------------------------------------------
--  DDL for Procedure IFF_SP_INSERT_TABLE_COLUMNS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "IFF_SP_INSERT_TABLE_COLUMNS" (table_id_in IN varchar2) as
BEGIN
  DECLARE
  display_value_var varchar(30);
 CURSOR iff_tables_cur IS
  SELECT column_name,column_id FROM user_tab_cols WHERE table_name = table_id_in and column_id is not null order by column_id;
  BEGIN
   FOR x in iff_tables_cur
   LOOP
    --Replace underscore
    display_value_var:= REPLACE(x.column_name, '_', ' ');
    -- Convert the firts letter to upper and the rest to lower
   --display_value_var:=UPPER(SUBSTR(display_value_var,1,1)) ||  LOWER(SUBSTR(display_value_var,2,LENGTH(display_value_var)));
   -- verify if the column is primary key
   INSERT INTO IFF_TABLE_COLUMNS (TABLE_ID,COLUMN_ID,COLUMN_NAME,DISPLAY_VALUE,AUTO_INSERTABLE,IS_PRIMARY_KEY)
   VALUES(table_id_in,x.column_id,x.column_name,display_value_var,'0','0');
   END LOOP;
   for x in(SELECT
cons.table_name,
cols.column_name
  FROM all_constraints cons
  join all_cons_columns cols on cons.constraint_name = cols.constraint_name AND cons.owner = cols.owner and cons.constraint_type = 'P' and cons.owner=(select user from dual)
  join user_tables on user_tables.table_name=cols.table_name
  where cons.table_name=table_id_in
) loop
     update iff_table_columns set is_primary_key=1 where table_id=table_id_in and column_name=x.column_name;
   end loop;
   IFF_SP_SET_TABLE_FOREIGN_KEYS(table_id_in);
  END;
  END;

/
--------------------------------------------------------
--  DDL for Procedure IFF_SP_INSRT_RL_USR_TBL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "IFF_SP_INSRT_RL_USR_TBL" (role_id_in in varchar2,table_id_in in VARCHAR2) AS
BEGIN
 DECLARE
 already_exists NUMBER;
 CURSOR cur1 IS
  select username from iff_role_users where role_id=role_id_in;
    BEGIN
     FOR x in cur1
     LOOP
      select count(*) into  already_exists from iff_role_user_tables where username=x.username and table_id=table_id_in;
     if(already_exists=0) then
       insert into iff_role_user_tables values(role_id_in,x.username,table_id_in,null,null);
       end if;
      END LOOP;
    END;
END;

/
--------------------------------------------------------
--  DDL for Procedure IFF_SP_IS_PRIMARY_KEY_COLUMN
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "IFF_SP_IS_PRIMARY_KEY_COLUMN" (table_name_in in varchar2,column_name_in in varchar2,is_primary_key out number)
AS
BEGIN
select count(*) into is_primary_key from(
 SELECT
cols.table_name,
cols.column_name
FROM all_constraints cons
join all_cons_columns cols on cons.constraint_name = cols.constraint_name AND cons.owner = cols.owner and cons.constraint_type = 'P'
join user_tables on user_tables.table_name=cols.table_name
where cols.column_name=column_name_in and cols.table_name=table_name_in
and cons.owner=(select user from dual)
GROUP BY cols.table_name,cols.column_name);
END;

/
--------------------------------------------------------
--  DDL for Procedure IFF_SP_ON_IFF_STARTS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "IFF_SP_ON_IFF_STARTS" as
lTime date:=sysdate;
begin
-- close sessions
update iff_session set session_ended_at=current_timestamp where session_ended_at is null;
--verify foreign keys
  for x in(
  with base as(
  select
  t1.table_id,
  t1.table_name,
  t2.referenced_table,
  t2.referenced_key_column t2_referenced_key_column,
  t2.column_id,
  t2.column_name,
  t3.dest_table,
  t3.dest_column referenced_key_column,
  t4.column_name referenced_value_column from iff_tables t1
  join iff_table_columns t2 on t1.table_id=t2.table_id
  join iff_v_table_foreign_keys t3 on t3.src_table=t1.table_name and t3.src_column=t2.column_name
  join user_tab_cols t4 on t4.table_name=t3.dest_table and t4.data_type in('CHAR','VARCHAR2') and t4.column_id<3
  where t2.REFERENCED_TABLE is null and t1.table_name not like 'IFF_%' or t2.referenced_key_column!=t3.dest_column
  ) select * from base --where rownum=1
  ) loop
  if(x.referenced_table is null) then
  update iff_table_columns set
  referenced_table=x.dest_table,
  referenced_key_column=x.referenced_key_column,
  referenced_value_column=x.referenced_value_column
  where table_id=x.table_id and column_id=x.column_id and referenced_table is null;
  elsif(x.t2_referenced_key_column!=x.referenced_key_column) then
  update iff_table_columns set referenced_key_column=x.referenced_key_column
  where table_id=x.table_id and column_id=x.column_id and referenced_key_column=x.t2_referenced_key_column;
  end if;
   exit when sysdate = lTime + interval '10' second;
  end loop;
   lTime :=sysdate;
   begin
 --verify primary keys
   for x in(SELECT cons.table_name,cols.column_name,iff_table_columns.table_id,iff_table_columns.column_id,iff_table_columns.column_name t_cols_col_name,
   case when cons.table_name is null then 0 else 1 end as is_primary_key_col
    FROM all_constraints cons
    join all_cons_columns cols on cons.constraint_name = cols.constraint_name AND cons.owner = cols.owner and cons.constraint_type = 'P' and cons.owner=(select user from dual)
    join user_tables on user_tables.table_name=cols.table_name
    right join iff_tables on iff_tables.table_name=cons.TABLE_NAME
    right join iff_table_columns on iff_table_columns.table_id=iff_tables.table_id and iff_table_columns.column_name=cols.column_name) loop
       update iff_table_columns set is_primary_key=x.is_primary_key_col where table_id=x.table_id and column_id=x.column_id;
        exit when sysdate = lTime + interval '10' second;
    end loop;
  end;
end;

/
--------------------------------------------------------
--  DDL for Procedure IFF_SP_RESET_SEQ
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "IFF_SP_RESET_SEQ" ( p_seq_name in varchar2 )
is
    l_val number;
begin
    execute immediate
    'select ' || p_seq_name || '.nextval from dual' INTO l_val;

    execute immediate
    'alter sequence ' || p_seq_name || ' increment by -' || l_val ||
                                                          ' minvalue 0';

    execute immediate
    'select ' || p_seq_name || '.nextval from dual' INTO l_val;

    execute immediate
    'alter sequence ' || p_seq_name || ' increment by 1 minvalue 0';
end;

/
--------------------------------------------------------
--  DDL for Procedure IFF_SP_SET_AUTO_INSERTABLE_COL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "IFF_SP_SET_AUTO_INSERTABLE_COL" (table_id_var varchar2,column_name_var varchar2,auto_insertable_val number default 1) as
begin
    declare
    sql_var varchar(100);
	begin
		sql_var:='update iff_table_columns set auto_insertable='||auto_insertable_val||' where table_id='||table_id_var ||' and column_name='||column_name_var;
		Dbms_Output.Put_Line('sp_set_auto_insertable_column: '||sql_var);
		execute immediate(sql_var);
	end;
end;

/
--------------------------------------------------------
--  DDL for Procedure IFF_SP_SET_TABLE_FOREIGN_KEYS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "IFF_SP_SET_TABLE_FOREIGN_KEYS" (table_id_in IN varchar2) as
BEGIN
  DECLARE
 CURSOR iff_table_columns_cur IS
     SELECT t1.src_table,t1.src_column,t1.dest_table,t1.dest_column,t2.column_name referenced_value_column from iff_v_table_foreign_keys t1
  join user_tab_cols t2 on t1.dest_table=t2.table_name
  WHERE t1.src_table = table_id_in
  and t2.column_id=2;
  BEGIN
   FOR x in iff_table_columns_cur
   LOOP
   update iff_table_columns set
   referenced_table=x.dest_table,
   referenced_key_column=x.dest_column,
   referenced_value_column=x.referenced_value_column
   where table_id=table_id_in and column_name=x.src_column;
   END LOOP;
  END;
  END;

/
--------------------------------------------------------
--  DDL for Procedure IFF_SP_SET_TBL_COL_ATTR
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "IFF_SP_SET_TBL_COL_ATTR" (
table_name_in varchar2,
column_name_in varchar2,
attr_name_in varchar2,
attr_value_in char) as
begin
declare plsql_block varchar(500):='UPDATE (SELECT
t1.table_name,
t2.*
FROM iff_tables t1
join iff_table_columns t2 on t2.table_id=t1.table_id
) t
SET
t.'||attr_name_in||'=:attr_value
where t.table_name=:table_name
and t.column_name=:column_name';
begin
--Dbms_Output.Put_Line(plsql_block);
execute immediate plsql_block USING
attr_value_in,
table_name_in,
column_name_in;
end;
end;

/
--------------------------------------------------------
--  DDL for Procedure IFF_SP_SORT_RL_USR_TBL_CLMNS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "IFF_SP_SORT_RL_USR_TBL_CLMNS" (role_id_in varchar2,table_id_in varchar2,username_in varchar2,position_in int) is
max_position int;
position_var int:=1;
begin
	select max(position) into max_position from iff_role_user_table_columns where
	role_id=role_id_in and table_id=table_id_in and username=username_in;
	if(max_position>position_in) then
		for x in (select *  from iff_role_user_table_columns where
		role_id=role_id_in and table_id=table_id_in and username=username_in order by position) loop
			update iff_role_user_table_columns set position=position_var  where
			role_id=x.role_id and table_id=x.table_id and username=x.username and column_id=x.column_id;
			position_var:=position_var+1;
		end loop;
    end if;
end;

/
