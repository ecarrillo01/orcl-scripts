declare
    err exception;
    pragma exception_init (err,-01430);
begin
    execute immediate 'alter table iff_users add(password_history varchar(2500))';
    exception when err then null;
end;
/