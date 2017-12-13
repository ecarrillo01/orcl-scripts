declare
    err exception;
    pragma exception_init (err,-02443);
begin
    execute immediate 'alter table TBL_COL_TRANSLATION drop constraint TBL_COL_TRANSLATION_FK1';
    exception when err then null;
end;
/
