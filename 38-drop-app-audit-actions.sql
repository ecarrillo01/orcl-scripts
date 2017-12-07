declare
    err exception;
    pragma exception_init (err,-00942);
begin
    execute immediate 'drop table IFF_APP_AUDIT_ACTIONS';
    exception when err then null;
end;
/

exec iff_sp_delete_table('IFF_APP_AUDIT_ACTIONS');