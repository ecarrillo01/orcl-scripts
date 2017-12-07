--------------------------------------------------------
--  Primary key constraint with one column
--------------------------------------------------------
declare
    err exception;
    pragma exception_init (err,-02260);
begin
    execute immediate 'ALTER TABLE EMPLOYEE ADD CONSTRAINT EMPLOYEE_PK PRIMARY KEY(ID)';
    exception when err then null;
end;
/

--------------------------------------------------------
--  Compound primary key
--------------------------------------------------------
declare
    err exception;
    pragma exception_init (err,-02260);
begin
    execute immediate 'ALTER TABLE EMPLOYEE_ROLE ADD CONSTRAINT EROLE_PK PRIMARY KEY(EMPLOYEE_ID,ROLE_ID)';
    exception when err then null;
end;
/ 