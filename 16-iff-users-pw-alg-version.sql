declare
    err exception;
    pragma exception_init (err,-01430);
begin
    execute immediate 'alter table iff_users add password_algorithm_version varchar(20) default ''v2''';
    exception when err then null;
end;
/
