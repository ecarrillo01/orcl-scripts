declare
    err exception;
    pragma exception_init (err,-01430);
begin
    execute immediate 'alter table iff_users add(account_status number default 1)';
    exception when err then null;
end;
/

declare
    err exception;
    pragma exception_init (err,-02264);
begin
    execute immediate 'alter table iff_users add constraint iff_users_ck1 check(account_status in(0,1))';
    exception when err then null;
end;
/

declare
    err exception;
    pragma exception_init (err,-01430);
begin
    execute immediate 'alter table iff_users add(email varchar(45))';
    exception when err then null;
end;
/