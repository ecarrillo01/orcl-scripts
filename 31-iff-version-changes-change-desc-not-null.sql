declare
    err exception;
    pragma exception_init (err,-01442);
begin
    execute immediate 'alter table iff_version_changes modify(change_description not null)';
    exception when err then null;
end;
/