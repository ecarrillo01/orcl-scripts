declare
    err exception;
    pragma exception_init (err,-01430);
begin
    execute immediate 'alter table iff_table_columns add description varchar(80)';
    exception when err then null;
end;
/