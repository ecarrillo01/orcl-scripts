declare
    err exception;
    pragma exception_init (err,-01430);
begin
    execute immediate 'alter table iff_app_audit add(session_id number)';
    exception when err then null;
end;
/

declare
    err exception;
    pragma exception_init (err,-02275);
begin
    execute immediate 'alter table iff_app_audit add constraint iff_app_audit_sid foreign key(session_id) references iff_session(session_id)';
    exception when err then null;
end;
/
