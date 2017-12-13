declare
    err exception;
    pragma exception_init (err,-04043);
begin
    execute immediate 'drop procedure SP_INSRT_RL_USR_TBL_CLMNS';
    exception when err then null;
end;
/