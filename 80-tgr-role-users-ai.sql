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
    insert into iff_role_user_table_columns values(:new.role_id,:new.username,x.table_id,y.column_id,y.column_id);
    end loop;
  end loop;
END;
/