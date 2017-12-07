declare
    handle_error exception;
    pragma exception_init (handle_error,-00904);
begin
      execute immediate 'alter table iff_tables drop column DISPLAY_VALUE';
   exception when handle_error  then null;
end;
/
delete from iff_table_columns where column_name='DISPLAY_VALUE' and table_id in(select table_id from iff_tables where table_name='IFF_TABLES');
    