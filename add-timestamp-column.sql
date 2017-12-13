declare
    clm_already_exists exception;
    pragma exception_init (clm_already_exists,-01430);
begin
    execute immediate 'alter table iff_version add(created_at timestamp default current_timestamp)';
    exception when clm_already_exists then null;
end;
/
