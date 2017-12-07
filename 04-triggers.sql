create or replace TRIGGER "IFF_TGR_TABLES_AI" AFTER INSERT ON IFF_TABLES
FOR EACH ROW
BEGIN
IFF_SP_INSERT_TABLE_COLUMNS(:new.TABLE_ID,:new.TABLE_NAME);
IFF_SP_INSERT_MENU_ITEMS(:new.TABLE_NAME);
END;
/

--role user ai, insert role user tables and role user table columns because role user tables doesnt triggers insert into role user table columns

create or replace TRIGGER IFF_TGR_ROLE_USERS_AI AFTER INSERT ON IFF_ROLE_USERS
FOR EACH ROW
BEGIN
  for x in (SELECT t1.role_id,t1.table_id FROM IFF_ROLE_TABLES t1
  where t1.table_id not in (select table_id from iff_role_user_tables where username=:new.username) and t1.role_id=:new.role_id)
  loop
    insert into iff_role_user_tables values(:new.role_id,:new.username,x.table_id,null,null);
    -- Insert role user table columns
    for y in(select t3.column_id,t4.column_id position from iff_tables t2
    join iff_table_columns t3 on t3.table_id=t2.table_id
    join user_tab_cols t4 on t4.table_name=t2.table_name and t4.column_name=t3.column_name
    join iff_role_table_columns t5 on t5.table_id=t2.table_id and t5.column_id=t3.column_id
    join iff_role_user_tables t6 on t6.role_id=t5.role_id  and t6.table_id=t5.table_id
    where t5.role_id=:new.role_id and t5.table_id=x.table_id and t6.username=:new.username) loop
    insert into iff_role_user_table_columns values(:new.role_id,:new.username,x.table_id,y.column_id);
    end loop;
  end loop;
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

create or replace TRIGGER "IFF_TGR_ROLE_TABLES_AI" AFTER INSERT ON IFF_ROLE_TABLES
FOR EACH ROW
BEGIN
  IFF_SP_INSRT_RL_USR_TBL(:new.ROLE_ID,:new.TABLE_ID);
  IFF_SP_INSERT_RL_TBL_COLS(:new.ROLE_ID,:new.TABLE_ID);
 for x in (select t1.item_id,t2.table_id from iff_menu_items t1
  join iff_tables t2 on t2.table_name=t1.parameters
  where t2.table_id=:new.table_id
  group by t1.item_id,t2.table_id)
  loop
  declare
    err exception;
    pragma exception_init (err,-00001);
    begin
        insert into iff_role_menu_items values(:new.role_id,x.item_id);
        exception when err then null;
    end;
  end loop;
END;
/

create or replace trigger IFF_TGR_ROLE_USER_TABLES_AD AFTER DELETE ON IFF_ROLE_USER_TABLES
BEGIN
for x in(select * from iff_role_tables) 
loop
IFF_SP_INSRT_RL_USR_TBL(x.role_id,x.table_id);
end loop;
END;
/

create or replace TRIGGER "IFF_TGR_ROLE_TABLES_AD" AFTER DELETE ON IFF_ROLE_TABLES
  FOR EACH ROW
BEGIN
DELETE FROM IFF_ROLE_MENU_ITEMS WHERE ROLE_ID=:old.role_id
AND ITEM_ID=(SELECT t2.item_id FROM IFF_TABLES t1 join IFF_MENU_ITEMS t2 on t1.table_name=t2.parameters WHERE t1.table_id=:old.table_id);
END;
/

CREATE OR REPLACE TRIGGER "IFF_TGR_TABLES_AU" AFTER UPDATE ON IFF_TABLES
FOR EACH ROW
BEGIN
  IF(:NEW.TABLE_NAME!=:OLD.TABLE_NAME) THEN
    UPDATE IFF_MENU_ITEMS SET PARAMETERS=:NEW.TABLE_NAME WHERE PARAMETERS=:OLD.TABLE_NAME;
    UPDATE IFF_TABLE_COLUMNS SET REFERENCED_TABLE=:NEW.TABLE_NAME WHERE REFERENCED_TABLE=:OLD.TABLE_NAME;
  END IF;
END;
/