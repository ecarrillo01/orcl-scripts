--Modified Procedures and triggers

create or replace PROCEDURE "IFF_SP_INSRT_RL_USR_TBL" (role_id_in in varchar2,table_id_in in number) AS
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

create or replace PROCEDURE "IFF_SP_INSERT_RL_TBL_COLS" (role_id_in IN varchar2,table_id_in IN number) AS
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
 
create or replace TRIGGER "IFF_TGR_ROLE_TABLE_COLUMNS_AI" AFTER INSERT ON IFF_ROLE_TABLE_COLUMNS
FOR EACH ROW
declare
cursor cursor1 is select t1.role_id,t1.table_id,t1.username,t4.column_id position from iff_role_user_tables t1
join iff_tables t2 on t2.table_id=t1.table_id
join iff_table_columns t3 on t3.table_id=t2.table_id and t3.column_id=:new.column_id
join user_tab_cols t4 on t4.table_name=t2.table_name and t4.column_name=t3.column_name
where role_id=:new.role_id and table_id=:new.table_id
group by t1.role_id,t1.table_id,t1.username,t4.column_id;
BEGIN
	for x in cursor1 loop
	  insert into iff_role_user_table_columns values(x.role_id,x.username,x.table_id,:new.column_id);
    --iff_sp_sort_rl_usr_tbl_clmns(:new.role_id,:new.table_id,x.username,x.position);
	end loop;
END;
/

create or replace PROCEDURE "IFF_SP_INSERT_TABLE_COLUMNS" (table_id_in IN NUMBER,table_name_in IN varchar2) as
BEGIN
  DECLARE
  display_value_var varchar(30);
 CURSOR iff_tables_cur IS
  SELECT column_name,column_id FROM user_tab_cols WHERE table_name = table_name_in and column_id is not null order by column_id;
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
  where cons.table_name=table_name_in
) loop
     update iff_table_columns set is_primary_key=1 where table_id=table_id_in and column_name=x.column_name;
   end loop;
   IFF_SP_SET_TABLE_FOREIGN_KEYS(table_id_in,table_name_in);
  END;
  END;
/
