declare
    column_doesnt_exists exception;
    pragma exception_init (column_doesnt_exists,-00904);
begin
    execute immediate 'alter table iff_tables drop column save_history';
    exception when column_doesnt_exists then null;
end;
/