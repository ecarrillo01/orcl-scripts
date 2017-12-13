declare
    err exception;
    pragma exception_init (err,-02275);
begin
    execute immediate 'ALTER TABLE "ROLE_USER_TABLE_COLUMNS" ADD CONSTRAINT "RL_USR_TBL_COLUMNS_FK2" FOREIGN KEY ("USERNAME", "TABLE_ID")
REFERENCES "ROLE_USER_TABLES" ("USERNAME", "TABLE_ID") ON DELETE CASCADE ENABLE';
    exception when err then null;
end;
/