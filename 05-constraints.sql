--------------------------------------------------------
--  Ref Constraints for Table TABLE_OPTIONS
--------------------------------------------------------
declare
    err exception;
    pragma exception_init (err,-02275);
begin
    delete from table_options where FUNCTION_ID not in(select function_id from functions);
    execute immediate 'ALTER TABLE "TABLE_OPTIONS" ADD CONSTRAINT "TABLE_OPTIONS_FN_ID_FK" FOREIGN KEY ("FUNCTION_ID")
REFERENCES "FUNCTIONS" ("FUNCTION_ID")';
    exception when err then null;
end;
/

--------------------------------------------------------
--  TABLE_COLUMNS_CK1
--------------------------------------------------------
declare
    err exception;
    pragma exception_init (err,-02264);
begin
    execute immediate 'ALTER TABLE TABLE_COLUMNS ADD CONSTRAINT "TABLE_COLUMNS_CK1" CHECK (is_primary_key in(0,1))';
    exception when err then null;
end;
/ 
--------------------------------------------------------
--  TABLE_COLUMNS_CK2
--------------------------------------------------------
declare
    err exception;
    pragma exception_init (err,-02264);
begin
    execute immediate 'ALTER TABLE TABLE_COLUMNS ADD CONSTRAINT "TABLE_COLUMNS_CK2" CHECK (auto_insertable in(0,1))';
    exception when err then null;
end;
/ 
--------------------------------------------------------
--  TABLE_COLUMNS_CK3
--------------------------------------------------------
declare
    err exception;
    pragma exception_init (err,-02264);
begin
    execute immediate 'ALTER TABLE TABLE_COLUMNS ADD CONSTRAINT "TABLE_COLUMNS_CK3" CHECK (is_filter in(0,1))';
    exception when err then null;
end;
/ 
--------------------------------------------------------
--  TABLE_COLUMNS_UK1
--------------------------------------------------------
declare
    err exception;
    pragma exception_init (err,-02261);
begin
    execute immediate 'ALTER TABLE TABLE_COLUMNS ADD CONSTRAINT TABLE_COLUMNS_UK1 UNIQUE(TABLE_ID,COLUMN_NAME)';
    exception when err then null;
end;
/ 
--------------------------------------------------------
--  TABLE_COLUMNS_PK
--------------------------------------------------------  
declare
    err exception;
    pragma exception_init (err,-02260);
begin
    execute immediate 'ALTER TABLE TABLE_COLUMNS ADD CONSTRAINT TABLE_COLUMNS_PK PRIMARY KEY(TABLE_ID,COLUMN_ID)';
    exception when err then null;
end;
/ 
--------------------------------------------------------
--  ROLE_TABLES_PK
--------------------------------------------------------
declare
    err exception;
    pragma exception_init (err,-02260);
begin
    execute immediate 'ALTER TABLE ROLE_TABLES ADD CONSTRAINT ROLE_TABLES_PK PRIMARY KEY(ROLE_ID,TABLE_ID)';
    exception when err then null;
end;
/ 
--------------------------------------------------------
--  MENU_ITEM_GROUP_PK
--------------------------------------------------------
declare
    err exception;
    pragma exception_init (err,-02260);
begin
    execute immediate 'ALTER TABLE MENU_ITEM_GROUP ADD CONSTRAINT MENU_ITEM_GROUP_PK PRIMARY KEY(GROUP_ID)';
    exception when err then null;
end;
/ 
--------------------------------------------------------
--   PARAMS_PK
--------------------------------------------------------
delete   FROM
   PARAMS t1
WHERE
  t1.rowid >
   ANY (
     SELECT
        t2.rowid
     FROM
          PARAMS t2
     WHERE
        t1.PARAM_KEY = t2.PARAM_KEY
        ); 
declare
    err exception;
    pragma exception_init (err,-02260);
begin
    execute immediate 'alter table params add constraint params_pk primary key(param_key)';
    exception when err then null;
end;
/ 
--------------------------------------------------------
--   ROLE_MENU_ITEMS_PK
--------------------------------------------------------
declare
    err exception;
    pragma exception_init (err,-02260);
begin
    execute immediate 'ALTER TABLE ROLE_MENU_ITEMS ADD CONSTRAINT ROLE_MENU_ITEMS_PK PRIMARY KEY(ROLE_ID,ITEM_ID)';
    exception when err then null;
end;
/ 
--------------------------------------------------------
--   ROLES_PK
--------------------------------------------------------
declare
    err exception;
    pragma exception_init (err,-02260);
begin
    execute immediate 'alter table roles add constraint roles_pk primary key(role_id)';
    exception when err then null;
end;
/ 
--------------------------------------------------------
--   FUNCTIONS_PK
--------------------------------------------------------  
declare
    err exception;
    pragma exception_init (err,-02260);
begin
    execute immediate 'alter table functions add constraint functions_pk primary key(function_id)';
    exception when err then null;
end;
/
--------------------------------------------------------
--  Ref Constraints for Table MENU_ITEMS
--------------------------------------------------------
delete from menu_items where FUNCTION_ID not in(select function_id from functions);
declare
    err exception;
    pragma exception_init (err,-02275);
begin
    execute immediate 'ALTER TABLE "MENU_ITEMS" ADD CONSTRAINT "MENU_ITEMS_FK1" FOREIGN KEY ("MENU_TYPE_ID")
REFERENCES "MENU_ITEM_TYPES" ("MENU_TYPE_ID")';
    exception when err then null;
end;
/

declare
    err exception;
    pragma exception_init (err,-02275);
begin
    execute immediate 'ALTER TABLE "MENU_ITEMS" ADD CONSTRAINT "MENU_ITEMS_FK2" FOREIGN KEY ("FUNCTION_ID")
	  REFERENCES "FUNCTIONS" ("FUNCTION_ID")';
    exception when err then null;
end;
/    
    
declare
    err exception;
    pragma exception_init (err,-02275);
begin
    execute immediate 'ALTER TABLE "MENU_ITEMS" ADD CONSTRAINT "MENU_ITEMS_FK_GROUP_ID" FOREIGN KEY ("GROUP_ID")
	  REFERENCES "MENU_ITEM_GROUP" ("GROUP_ID")';
    exception when err then null;
end;
/  
--------------------------------------------------------
--  Ref Constraints for Table ROLE_MENU_ITEMS
--------------------------------------------------------
declare
    err exception;
    pragma exception_init (err,-02275);
begin
    execute immediate 'ALTER TABLE "ROLE_MENU_ITEMS" ADD CONSTRAINT "ROLE_MENU_ITEMS_FK1" FOREIGN KEY ("ROLE_ID")
	  REFERENCES "ROLES" ("ROLE_ID")';
    exception when err then null;
end;
/ 

declare
    err exception;
    pragma exception_init (err,-02275);
begin
    execute immediate 'ALTER TABLE "ROLE_MENU_ITEMS" ADD CONSTRAINT "ROLE_MENU_ITEMS_FK2" FOREIGN KEY ("ITEM_ID")
REFERENCES "MENU_ITEMS" ("ITEM_ID")';
    exception when err then null;
end;
/ 
--------------------------------------------------------
--  Ref Constraints for Table ROLE_TABLE_COLUMNS
--------------------------------------------------------
declare
    err exception;
    pragma exception_init (err,-02275);
begin
    execute immediate 'ALTER TABLE "ROLE_TABLE_COLUMNS" ADD CONSTRAINT "ROLE_TABLE_COLUMNS_FK1" FOREIGN KEY ("ROLE_ID", "TABLE_ID")
REFERENCES "ROLE_TABLES" ("ROLE_ID", "TABLE_ID") ON DELETE CASCADE';
    exception when err then null;
end;
/ 
declare
    err exception;
    pragma exception_init (err,-02275);
begin
    execute immediate 'ALTER TABLE "ROLE_TABLE_COLUMNS" ADD CONSTRAINT "ROLE_TABLE_COLUMNS_FK2" FOREIGN KEY ("TABLE_ID", "COLUMN_ID")
	  REFERENCES "TABLE_COLUMNS" ("TABLE_ID", "COLUMN_ID")';
    exception when err then null;
end;
/ 
--------------------------------------------------------
--  Ref Constraints for Table ROLE_TABLE_OPTIONS
--------------------------------------------------------
declare
    err exception;
    pragma exception_init (err,-02275);
begin
    execute immediate 'ALTER TABLE "ROLE_TABLE_OPTIONS" ADD CONSTRAINT "ROLE_TABLE_OPTIONS_FK1" FOREIGN KEY ("TABLE_OPTION_ID")
REFERENCES "TABLE_OPTIONS" ("TABLE_OPTION_ID")';
    exception when err then null;
end;
/ 
declare
    err exception;
    pragma exception_init (err,-02275);
begin
    execute immediate 'ALTER TABLE "ROLE_TABLE_OPTIONS" ADD CONSTRAINT "ROLE_TABLE_OPTIONS_FK2" FOREIGN KEY ("ROLE_ID", "TABLE_ID")
REFERENCES "ROLE_TABLES" ("ROLE_ID", "TABLE_ID") ON DELETE CASCADE';
    exception when err then null;
end;
/ 
--------------------------------------------------------
--  Ref Constraints for Table ROLE_TABLES
--------------------------------------------------------
declare
    err exception;
    pragma exception_init (err,-02275);
begin
    execute immediate 'ALTER TABLE "ROLE_TABLES" ADD CONSTRAINT "ROLE_TABLES_FK1" FOREIGN KEY ("ROLE_ID")
REFERENCES "ROLES" ("ROLE_ID")';
    exception when err then null;
end;
/ 
declare
    err exception;
    pragma exception_init (err,-02275);
begin
    execute immediate 'ALTER TABLE "ROLE_TABLES" ADD CONSTRAINT "ROLE_TABLES_FK2" FOREIGN KEY ("TABLE_ID")
REFERENCES "TABLES" ("TABLE_ID")';
    exception when err then null;
end;
/
--------------------------------------------------------
--  Ref Constraints for Table ROLE_USERS
--------------------------------------------------------
declare
    err exception;
    pragma exception_init (err,-02275);
begin
    execute immediate 'ALTER TABLE "ROLE_USERS" ADD CONSTRAINT "ROLE_USERS_FK1" FOREIGN KEY ("ROLE_ID")
REFERENCES "ROLES" ("ROLE_ID")';
    exception when err then null;
end;
/

declare
    err exception;
    pragma exception_init (err,-02275);
begin
    execute immediate 'ALTER TABLE "ROLE_USERS" ADD CONSTRAINT "ROLE_USERS_FK2" FOREIGN KEY ("USERNAME")
REFERENCES "USERS" ("USERNAME") ON DELETE CASCADE';
    exception when err then null;
end;
/
--------------------------------------------------------
--  Ref Constraints for Table ROLE_USER_TABLE_COLUMNS
--------------------------------------------------------
declare
    err exception;
    pragma exception_init (err,-02275);
begin
    execute immediate 'ALTER TABLE "ROLE_USER_TABLE_COLUMNS" ADD CONSTRAINT "RL_USR_TBL_COLUMNS_FK1" FOREIGN KEY ("ROLE_ID", "TABLE_ID", "COLUMN_ID")
REFERENCES "ROLE_TABLE_COLUMNS" ("ROLE_ID", "TABLE_ID", "COLUMN_ID") ON DELETE CASCADE';
    exception when err then null;
end;
/

declare
    err exception;
    pragma exception_init (err,-02275);
begin
    execute immediate 'ALTER TABLE "ROLE_USER_TABLE_COLUMNS" ADD CONSTRAINT "RL_USR_TBL_COLUMNS_FK2" FOREIGN KEY ("USERNAME", "TABLE_ID")
REFERENCES "ROLE_USER_TABLES" ("USERNAME", "TABLE_ID") ON DELETE CASCADE ENABLE';
    exception when err then null;
end;
/

--------------------------------------------------------
--  Ref Constraints for Table ROLE_USER_TABLES
--------------------------------------------------------
declare
    err exception;
    pragma exception_init (err,-02275);
begin
    execute immediate 'ALTER TABLE "ROLE_USER_TABLES" ADD CONSTRAINT "ROLE_USER_TABLES_FK1" FOREIGN KEY ("ROLE_ID", "TABLE_ID")
REFERENCES "ROLE_TABLES" ("ROLE_ID", "TABLE_ID") ON DELETE CASCADE';
    exception when err then null;
end;
/
declare
    err exception;
    pragma exception_init (err,-02275);
begin
    execute immediate 'ALTER TABLE "ROLE_USER_TABLES" ADD CONSTRAINT "ROLE_USER_TABLES_FK2" FOREIGN KEY ("USERNAME", "ROLE_ID")
REFERENCES "ROLE_USERS" ("USERNAME", "ROLE_ID") ON DELETE CASCADE';
    exception when err then null;
end;
/
--------------------------------------------------------
--  Ref Constraints for Table TABLE_COLUMNS
--------------------------------------------------------
declare
    err exception;
    pragma exception_init (err,-02275);
begin
    execute immediate 'ALTER TABLE "TABLE_COLUMNS" ADD CONSTRAINT "TABLE_COLUMNS_FK1" FOREIGN KEY ("TABLE_ID")
REFERENCES "TABLES" ("TABLE_ID") ON DELETE CASCADE ENABLE';
    exception when err then null;
end;
/ 
--------------------------------------------------------
--  Ref Constraints for Table VERSION_CHANGES
--------------------------------------------------------
declare
    err exception;
    pragma exception_init (err,-02275);
begin
    execute immediate 'ALTER TABLE "VERSION_CHANGES" ADD CONSTRAINT "VERSION_CHANGES_FK1" FOREIGN KEY ("VERSION_ID")
REFERENCES "VERSION" ("VERSION_ID") ENABLE';
    exception when err then null;
end;
/ 

declare
    err exception;
    pragma exception_init (err,-02275);
begin
    execute immediate 'ALTER TABLE "VERSION_CHANGES" ADD CONSTRAINT "VERSION_CHANGES_FK2" FOREIGN KEY ("CHANGE_TYPE_ID")
REFERENCES "VERSION_CHANGE_TYPES" ("CHANGE_TYPE_ID") ENABLE';
    exception when err then null;
end;
/  
--------------------------------------------------------
--  Ref Constraints for Table LANG
--------------------------------------------------------
declare
    err exception;
    pragma exception_init (err,-02260);
begin
    execute immediate 'ALTER TABLE LANG ADD CONSTRAINT LANG_PK PRIMARY KEY(LANG_ID)';
    exception when err then null;
end;
/ 
--------------------------------------------------------
--  Ref Constraints for Table TBL_COL_TRANSLATION
-------------------------------------------------------- 
declare
    err exception;
    pragma exception_init (err,-02260);
begin
    execute immediate 'ALTER TABLE TBL_COL_TRANSLATION ADD CONSTRAINT TBL_COL_TRANSLATION_PK PRIMARY KEY(TABLE_ID,COLUMN_ID,LANG_ID)';
    exception when err then null;
end;
/ 
declare
    err exception;
    pragma exception_init (err,-02275);
begin
    execute immediate 'ALTER TABLE TBL_COL_TRANSLATION ADD CONSTRAINT TBL_COL_TRANSLATION_FK2 FOREIGN KEY(LANG_ID) REFERENCES LANG(LANG_ID)';
    exception when err then null;
end;
/ 
declare
    err exception;
    pragma exception_init (err,-02443);
begin
    execute immediate 'alter table TBL_COL_TRANSLATION drop constraint TBL_COL_TRANSLATION_FK1';
    exception when err then null;
end;
/
declare
    err exception;
    pragma exception_init (err,-02443);
begin
    execute immediate 'alter table TBL_COL_TRANSLATION add constraint TBL_COL_TRANSLATION_FK1 foreign key(table_id,column_id) references table_columns(table_id,column_id) on delete cascade';
    exception when err then null;
end;
/