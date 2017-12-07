declare
    duplicate_column exception;
    pragma exception_init (duplicate_column,-00957);
begin
    execute immediate 'alter table my_params rename column value to param_value';
    exception when duplicate_column then null;
end;
/