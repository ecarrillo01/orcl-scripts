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
	  insert into iff_role_user_table_columns values(x.role_id,x.username,x.table_id,:new.column_id,:new.column_id);
    --iff_sp_sort_rl_usr_tbl_clmns(:new.role_id,:new.table_id,x.username,x.position);
	end loop;
END;
/