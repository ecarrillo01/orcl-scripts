declare
    err exception;
    pragma exception_init (err,-02289);
begin
    execute immediate 'drop sequence IFF_VERSION_SEQ';
    exception when err then null;
end;
/