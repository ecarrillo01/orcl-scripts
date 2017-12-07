declare
    err exception;
    pragma exception_init (err,-01430);
begin
    execute immediate 'alter table audit add audit_description varchar(200)';
    exception when err then null;
end;
/