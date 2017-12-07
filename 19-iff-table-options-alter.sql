declare
    err exception;
    pragma exception_init (err,-01430);
begin
    execute immediate 'alter table iff_table_options add position number';
    exception when err then null;
end;
/