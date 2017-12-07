declare
    duplicate_column exception;
    pragma exception_init (duplicate_column,-00957);
begin
    execute immediate 'alter table iff_params rename column key to param_key';
    execute immediate 'alter table iff_params rename column value to param_value';
    exception when duplicate_column then null;
end;
/
declare
    err exception;
    pragma exception_init (err,-01430);
begin
    execute immediate 'alter table iff_params add param_description varchar(200)';
    exception when err then null;
end;
/