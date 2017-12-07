declare
    already_exists exception;
    pragma exception_init (already_exists,-02261);
begin
    execute immediate 'alter table iff_menu_items add constraint iff_menu_items_uk2 unique(function_id,parameters)';
    exception when already_exists then null;
end;
/