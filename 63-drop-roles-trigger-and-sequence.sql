declare
    err exception;
    pragma exception_init (err,-02289);
begin
    execute immediate 'drop sequence IFF_ROLES_SEQ';
    exception when err then null;
end;
/

declare
    err exception;
    pragma exception_init (err,-04080);
begin
    execute immediate 'drop trigger IFF_TGR_ROLES_BI';
    exception when err then null;
end;
/