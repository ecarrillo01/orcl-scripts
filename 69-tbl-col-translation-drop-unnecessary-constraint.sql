declare
    err exception;
    pragma exception_init (err,-02443);
begin
    execute immediate 'alter table iff_tbl_col_translation drop constraint IFF_TBL_COL_TRANSLATION_UK1';
    exception when err then null;
end;
/