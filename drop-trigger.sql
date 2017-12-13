declare
    err exception;
    pragma exception_init (err,-04080);
begin
    execute immediate 'drop trigger TGR_ROLE_USER_TABLES_AI';
    exception when err then null;
end;
/
