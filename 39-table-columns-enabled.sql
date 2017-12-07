declare
    err exception;
    pragma exception_init (err,-01430);
begin
    execute immediate 'alter table iff_table_columns add(enabled number default 1 not null)';
    exception 
    when err then null;
end;
/

declare
    err exception;
    pragma exception_init (err,-02264);
begin
    execute immediate 'alter table iff_table_columns add constraint iff_tbl_cols_enabled_ck CHECK( enabled IN (0,1))';
    exception 
    when err then null;
end;
/
