declare
    err exception;
    pragma exception_init (err,-02289);
begin
    execute immediate 'drop sequence IFF_TABLE_OPTIONS_SEQ';
    exception when err then null;
end;
/
declare
    err exception;
    pragma exception_init (err,-04080);
begin
    execute immediate 'drop trigger IFF_TGR_TABLE_OPTIONS_BI';
    exception when err then null;
end;
/
declare
    err exception;
    pragma exception_init (err,-02261);
begin
    execute immediate 'alter table iff_table_options add constraint function_id_uk unique(function_id)';
    exception when err then null;
end;
/
