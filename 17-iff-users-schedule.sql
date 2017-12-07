declare
    err exception;
    pragma exception_init (err,-01430);
begin
    execute immediate 'alter table iff_users add schedule varchar(100)';
    exception when err then null;
end;
/