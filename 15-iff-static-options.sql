declare
    err exception;
    pragma exception_init (err,-01430);
begin
    execute immediate 'alter table iff_table_columns add static_options varchar(500)';
    exception when err then null;
end;
/