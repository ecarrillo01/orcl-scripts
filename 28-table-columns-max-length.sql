declare
    err exception;
    pragma exception_init (err,-01430);
begin
    execute immediate 'alter table iff_table_columns add max_length number';
    exception when err then null;
end;
/
begin 
	for x in(select t2.table_id,t2.column_id,t3.data_length from iff_tables t1 
	join iff_table_columns t2 on t1.table_id=t2.table_id
	join user_tab_cols t3 on t3.table_name=t1.table_name and t3.column_name=t2.column_name) loop
		update iff_table_columns set max_length=x.data_length where table_id=x.table_id and column_id=x.column_id and max_length is null;
	end loop;
end;
/