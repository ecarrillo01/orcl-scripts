declare
    err exception;
    pragma exception_init (err,-00955);
begin
    execute immediate 'CREATE SEQUENCE "MY_SEQUENCE" START WITH 1 INCREMENT BY 1 NOMAXVALUE';
    exception when err then null;
end;
/
