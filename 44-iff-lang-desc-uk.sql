declare
    err exception;
    pragma exception_init (err,-02261);
begin
    execute immediate 'alter table iff_lang add constraint iff_lang_desk_uk unique(lang_description)';
    exception when err then null;
end;
/