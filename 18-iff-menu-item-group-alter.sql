declare
    err exception;
    pragma exception_init (err,-01430);
begin
    execute immediate 'alter table iff_menu_item_group add position number';
    exception when err then null;
end;
/