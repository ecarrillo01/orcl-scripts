declare
    err exception;
    pragma exception_init (err,-01430);
begin
    execute immediate 'alter table iff_app_audit add source_ip varchar(40)';
    exception when err then null;
end;
/
