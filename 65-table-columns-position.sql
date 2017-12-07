SET SERVEROUTPUT ON;
declare
    err exception;
    pragma exception_init (err,-01430);
begin
    execute immediate 'alter table iff_table_columns add(position number default 0 not null)';
    exception when err then null;
end;
/

begin
  for x in(select t1.table_name,t3.column_name,t3.column_id from user_tables t1
   join iff_tables t2 on t1.table_name=t2.table_name
   join user_tab_cols t3 on t3.table_name=t1.table_name order by t1.table_name,t3.column_id) loop
      iff_sp_set_tbl_col_attr(x.table_name,x.column_name,'POSITION',x.COLUMN_ID);
   end loop;
end;

declare
    err exception;
    pragma exception_init (err,-00904);
begin
    execute immediate 'alter table iff_role_user_table_columns drop column position';
    exception when err then null;
end;
/