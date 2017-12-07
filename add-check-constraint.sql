declare
    err exception;
    pragma exception_init (err,-02264);
begin
    execute immediate 'alter table session add constraint session_ck1 check (session_ended_at > session_started_at)';
    exception when err then null;
end;
/
