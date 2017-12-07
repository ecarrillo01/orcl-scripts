alter table iff_menu_items modify(group_id default null);
declare
    err exception;
    pragma exception_init (err,-01442);
begin
    execute immediate 'alter table iff_menu_items modify(function_id not null)';
    exception when err then null;
end;
/
