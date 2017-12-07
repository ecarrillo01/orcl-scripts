declare
    column_doesnt_exists exception;
    pragma exception_init (column_doesnt_exists ,-00904);
begin
    execute immediate 'ALTER TABLE IFF_USERS DROP COLUMN GROUP_FORM_CONTROLS_BY';
    exception when column_doesnt_exists then null;
end;
/
alter table iff_users modify lastname varchar(40);