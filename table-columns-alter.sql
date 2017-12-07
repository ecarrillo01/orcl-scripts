alter table iff_table_columns modify display_value varchar(40);
declare
    duplicate_column exception;
    pragma exception_init (duplicate_column,-00957);
begin
    execute immediate 'alter table iff_table_columns rename column depending_filter to depending_column';
    exception when duplicate_column then null;
end;
/
declare
    handle_error exception;
    pragma exception_init (handle_error,-00904);
begin
    execute immediate 'alter table iff_table_columns drop column visible';
      execute immediate 'alter table iff_table_columns drop column GENERATE_DAO';
    exception when handle_error  then null;
end;
/
declare
    err exception;
    pragma exception_init (err,-01430);
begin
    execute immediate 'alter table iff_table_columns add form_control_type varchar(40)';
    exception when err then null;
end;
/
BEGIN
for x in(select DATA_TYPE,COLUMN_NAME from user_tab_cols where table_name='IFF_TABLE_COLUMNS' and column_name
in('REFERENCED_VALUE_COLUMN','DEPENDING_COLUMN','REFERENCED_KEY_COLUMN','REFERENCED_TABLE')
) loop
if(x.DATA_TYPE!='VARCHAR2') then
  execute immediate ('update iff_table_columns set '||x.COLUMN_NAME||'=null');
  execute immediate ('alter table  iff_table_columns modify '||x.COLUMN_NAME||' varchar(50)');
  end if;
end loop;
END;
/