declare
    err exception;
    pragma exception_init (err,-01430);
begin
    execute immediate 'alter table iff_app_audit add(iff_version varchar(20))';
    exception when err then null;
end;
/