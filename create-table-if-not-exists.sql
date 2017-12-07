declare
procedure sp_create_table(sql_str varchar2) is
err exception;
pragma exception_init (err,-00955);
begin
execute immediate(sql_str);
exception when err then null;
end sp_create_table;
begin
sp_create_table('CREATE TABLE "APP_AUDIT" ("USERNAME" VARCHAR2(30 BYTE), "ACTION" VARCHAR2(30 BYTE), "ACTION_TYPE" VARCHAR2(30 BYTE), "TABLE_NAME" VARCHAR2(30 BYTE), "DETAIL" VARCHAR2(2000 BYTE), "RECORD_DATE" TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP )');
--Allow table to be imported empty in to dmp file
for x in (select table_name from user_tables WHERE segment_created = 'NO') loop
  execute immediate ('ALTER TABLE '||x.table_name||' ALLOCATE EXTENT');
end loop;
end;
/