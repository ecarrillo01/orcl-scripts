declare
    err exception;
    pragma exception_init (err,-02261);
begin
    execute immediate 'alter table version_changes add constraint vs_changes_v_ctype_cdesc_uk unique(version_id,change_type_id,change_description)';
    exception when err then null;
end;
end;
/
