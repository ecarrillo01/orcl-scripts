declare
    err exception;
    pragma exception_init (err,-02261);
begin
    execute immediate 'ALTER TABLE USERS ADD CONSTRAINT USERS_UK1 UNIQUE(USERNAME)';
    exception when err then null;
end;
/   