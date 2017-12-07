--------------------------------------------------------
--  IFF_MENU_ITEMS_PK
--------------------------------------------------------
declare
    err exception;
    pragma exception_init (err,-02260);
begin
    execute immediate 'ALTER TABLE IFF_MENU_ITEMS ADD CONSTRAINT IFF_MENU_ITEMS_PK PRIMARY KEY(ITEM_ID)';
    exception when err then null;
end;
/
--------------------------------------------------------
--  IFF_MENU_ITEM_TYPES_PK
--------------------------------------------------------
declare
    err exception;
    pragma exception_init (err,-02260);
begin
    execute immediate 'ALTER TABLE IFF_MENU_ITEM_TYPES ADD CONSTRAINT IFF_MENU_ITEM_TYPES_PK PRIMARY KEY(MENU_TYPE_ID)';
    exception when err then null;
end;
/
--------------------------------------------------------
--  IFF_FUNCTIONS_UK1
--------------------------------------------------------
delete   FROM
   IFF_FUNCTIONS t1
WHERE
t1.rowid >
ANY (
 SELECT
    t2.rowid
 FROM
      IFF_FUNCTIONS t2
 WHERE
    t1.FUNCTION_NAME = t2.FUNCTION_NAME
); 

declare
    err exception;
    pragma exception_init (err,-02261);
begin
    execute immediate 'ALTER TABLE IFF_FUNCTIONS ADD CONSTRAINT IFF_FUNCTIONS_UK1 UNIQUE(FUNCTION_NAME)';
    exception when err then null;
end;
/      
--------------------------------------------------------
--   IFF_ROLES UK
--------------------------------------------------------
delete   FROM
   iff_roles t1
WHERE
  t1.rowid >
   ANY (
     SELECT
        t2.rowid
     FROM
         iff_roles t2
     WHERE
        t1.role_name = t2.role_name
        ); 
declare
    err exception;
    pragma exception_init (err,-02261);
begin
    execute immediate 'ALTER TABLE iff_roles ADD CONSTRAINT iff_roles_uk1  unique(role_name)';
    exception when err then null;
end;
/ 
--------------------------------------------------------
--   VERSION_CHANGE_TYPES_UK
--------------------------------------------------------
declare
    err exception;
    pragma exception_init (err,-02261);
begin
    execute immediate 'alter table iff_version_change_types add constraint iff_version_change_types_uk1 unique(change_type_name)';
    exception when err then null;
end;
/ 
--------------------------------------------------------
--   IFF_MENU_ITEM_TYPES UK
--------------------------------------------------------
delete   FROM
   IFF_MENU_ITEM_TYPES t1
WHERE
  t1.rowid >
   ANY (
     SELECT
        t2.rowid
     FROM
          IFF_MENU_ITEM_TYPES t2
     WHERE
        t1.menu_type_name = t2.menu_type_name
        ); 
declare
    err exception;
    pragma exception_init (err,-02261);
begin
    execute immediate 'ALTER TABLE IFF_MENU_ITEM_TYPES ADD CONSTRAINT IFF_MENU_ITEM_TYPES_uk1  unique(menu_type_name)';
    exception when err then null;
end;
/ 
--------------------------------------------------------
--   IFF_MENU_ITEM_GROUP UK
--------------------------------------------------------
delete   FROM
   IFF_MENU_ITEM_GROUP t1
WHERE
  t1.rowid >
   ANY (
     SELECT
        t2.rowid
     FROM
         IFF_MENU_ITEM_GROUP t2
     WHERE
        t1.GROUP_NAME = t2.GROUP_NAME
        ); 
declare
    err exception;
    pragma exception_init (err,-02261);
begin
    execute immediate 'ALTER TABLE IFF_MENU_ITEM_GROUP ADD CONSTRAINT IFF_MENU_ITEM_GROUP_UK  UNIQUE(GROUP_NAME)';
    exception when err then null;
end;
/ 
--------------------------------------------------------
--  IFF_MENU_ITEMS_UK1
--------------------------------------------------------
declare
    err exception;
    pragma exception_init (err,-02261);
begin
    execute immediate 'ALTER TABLE IFF_MENU_ITEMS ADD CONSTRAINT IFF_MENU_ITEMS_UK1 UNIQUE(ITEM_NAME)';
    exception when err then null;
end;
/ 
--------------------------------------------------------
--  IFF_VERSION_CHANGE_TYPES_PK
-------------------------------------------------------- 
declare
    err exception;
    pragma exception_init (err,-02260);
begin
    execute immediate 'ALTER TABLE IFF_VERSION_CHANGE_TYPES ADD CONSTRAINT IFF_VERSION_CHANGE_TYPES_PK PRIMARY KEY(CHANGE_TYPE_ID)';
    exception when err then null;
end;
/ 
--------------------------------------------------------
--  IFF_VERSION_PK
--------------------------------------------------------
declare
    err exception;
    pragma exception_init (err,-02260);
begin
    execute immediate 'ALTER TABLE IFF_VERSION ADD CONSTRAINT IFF_VERSION_PK PRIMARY KEY(VERSION_ID)';
    exception when err then null;
end;
/ 
--------------------------------------------------------
--  IFF_ROLE_USERS_PK
--------------------------------------------------------
declare
    err exception;
    pragma exception_init (err,-02260);
begin
    execute immediate 'ALTER TABLE IFF_ROLE_USERS ADD CONSTRAINT IFF_ROLE_USERS_PK PRIMARY KEY(ROLE_ID,USERNAME)';
    exception when err then null;
end;
/ 
--------------------------------------------------------
--  IFF_ROLE_USER_TABLES_PK
--------------------------------------------------------
declare
    err exception;
    pragma exception_init (err,-02260);
begin
    execute immediate 'ALTER TABLE IFF_ROLE_USER_TABLES ADD CONSTRAINT IFF_ROLE_USER_TABLES_PK PRIMARY KEY ("USERNAME", "TABLE_ID")';
    exception when err then null;
end;
/ 
--------------------------------------------------------
--  IFF_ROLE_TABLE_COLUMNS_PK
--------------------------------------------------------
declare
    err exception;
    pragma exception_init (err,-02260);
begin
    execute immediate 'ALTER TABLE IFF_ROLE_TABLE_COLUMNS ADD CONSTRAINT IFF_ROLE_TABLE_COLUMNS_PK PRIMARY KEY(ROLE_ID,TABLE_ID,COLUMN_ID)';
    exception when err then null;
end;
/ 
--------------------------------------------------------
--  IFF_USERS_PK
--------------------------------------------------------
delete   FROM
   IFF_USERS t1
WHERE
  t1.rowid >
   ANY (
     SELECT
        t2.rowid
     FROM
         IFF_USERS t2
     WHERE
        t1.USERNAME = t2.USERNAME
        );   
declare
    err exception;
    pragma exception_init (err,-02260);
begin
    execute immediate 'alter table iff_users add CONSTRAINT iff_users_pk primary key(username)';
    exception when err then null;
end;
/ 
--------------------------------------------------------
--  IFF_TABLES_UK1
--------------------------------------------------------
declare
    err exception;
    pragma exception_init (err,-02261);
begin
    execute immediate 'ALTER TABLE IFF_TABLES ADD CONSTRAINT IFF_TABLES_UK1 UNIQUE(TABLE_NAME)';
    exception when err then null;
end;
/ 
--------------------------------------------------------
--  IFF_TABLES_PK
-------------------------------------------------------- 
declare
    err exception;
    pragma exception_init (err,-02260);
begin
    execute immediate 'ALTER TABLE IFF_TABLES ADD CONSTRAINT IFF_TABLES_PK PRIMARY KEY(TABLE_ID)';
    exception when err then null;
end;
/ 
--------------------------------------------------------
--  IFF_TABLE_OPTIONS_PK
--------------------------------------------------------
declare
    err exception;
    pragma exception_init (err,-02260);
begin
    execute immediate 'ALTER TABLE IFF_TABLE_OPTIONS ADD CONSTRAINT IFF_TABLE_OPTIONS_PK PRIMARY KEY(TABLE_OPTION_ID)';
    exception when err then null;
end;
/ 

--------------------------------------------------------
--  Ref Constraints for Table IFF_TABLE_OPTIONS
--------------------------------------------------------
declare
    err exception;
    pragma exception_init (err,-02275);
begin
    delete from iff_table_options where FUNCTION_ID not in(select function_id from iff_functions);
    execute immediate 'ALTER TABLE "IFF_TABLE_OPTIONS" ADD CONSTRAINT "IFF_TABLE_OPTIONS_FN_ID_FK" FOREIGN KEY ("FUNCTION_ID")
REFERENCES "IFF_FUNCTIONS" ("FUNCTION_ID")';
    exception when err then null;
end;
/

--------------------------------------------------------
--  IFF_TABLE_COLUMNS_CK1
--------------------------------------------------------
declare
    err exception;
    pragma exception_init (err,-02264);
begin
    execute immediate 'ALTER TABLE IFF_TABLE_COLUMNS ADD CONSTRAINT "IFF_TABLE_COLUMNS_CK1" CHECK (is_primary_key in(0,1))';
    exception when err then null;
end;
/ 
--------------------------------------------------------
--  IFF_TABLE_COLUMNS_CK2
--------------------------------------------------------
declare
    err exception;
    pragma exception_init (err,-02264);
begin
    execute immediate 'ALTER TABLE IFF_TABLE_COLUMNS ADD CONSTRAINT "IFF_TABLE_COLUMNS_CK2" CHECK (auto_insertable in(0,1))';
    exception when err then null;
end;
/ 
--------------------------------------------------------
--  IFF_TABLE_COLUMNS_CK3
--------------------------------------------------------
declare
    err exception;
    pragma exception_init (err,-02264);
begin
    execute immediate 'ALTER TABLE IFF_TABLE_COLUMNS ADD CONSTRAINT "IFF_TABLE_COLUMNS_CK3" CHECK (is_filter in(0,1))';
    exception when err then null;
end;
/ 
--------------------------------------------------------
--  IFF_TABLE_COLUMNS_UK1
--------------------------------------------------------
declare
    err exception;
    pragma exception_init (err,-02261);
begin
    execute immediate 'ALTER TABLE IFF_TABLE_COLUMNS ADD CONSTRAINT IFF_TABLE_COLUMNS_UK1 UNIQUE(TABLE_ID,COLUMN_NAME)';
    exception when err then null;
end;
/ 
--------------------------------------------------------
--  IFF_TABLE_COLUMNS_PK
--------------------------------------------------------  
declare
    err exception;
    pragma exception_init (err,-02260);
begin
    execute immediate 'ALTER TABLE IFF_TABLE_COLUMNS ADD CONSTRAINT IFF_TABLE_COLUMNS_PK PRIMARY KEY(TABLE_ID,COLUMN_ID)';
    exception when err then null;
end;
/ 
--------------------------------------------------------
--  IFF_ROLE_TABLES_PK
--------------------------------------------------------
declare
    err exception;
    pragma exception_init (err,-02260);
begin
    execute immediate 'ALTER TABLE IFF_ROLE_TABLES ADD CONSTRAINT IFF_ROLE_TABLES_PK PRIMARY KEY(ROLE_ID,TABLE_ID)';
    exception when err then null;
end;
/ 
--------------------------------------------------------
--  IFF_MENU_ITEM_GROUP_PK
--------------------------------------------------------
declare
    err exception;
    pragma exception_init (err,-02260);
begin
    execute immediate 'ALTER TABLE IFF_MENU_ITEM_GROUP ADD CONSTRAINT IFF_MENU_ITEM_GROUP_PK PRIMARY KEY(GROUP_ID)';
    exception when err then null;
end;
/ 
--------------------------------------------------------
--   IFF_PARAMS_PK
--------------------------------------------------------
delete   FROM
   IFF_PARAMS t1
WHERE
  t1.rowid >
   ANY (
     SELECT
        t2.rowid
     FROM
          IFF_PARAMS t2
     WHERE
        t1.PARAM_KEY = t2.PARAM_KEY
        ); 
declare
    err exception;
    pragma exception_init (err,-02260);
begin
    execute immediate 'alter table iff_params add constraint iff_params_pk primary key(param_key)';
    exception when err then null;
end;
/ 
--------------------------------------------------------
--   IFF_ROLE_MENU_ITEMS_PK
--------------------------------------------------------
declare
    err exception;
    pragma exception_init (err,-02260);
begin
    execute immediate 'ALTER TABLE IFF_ROLE_MENU_ITEMS ADD CONSTRAINT IFF_ROLE_MENU_ITEMS_PK PRIMARY KEY(ROLE_ID,ITEM_ID)';
    exception when err then null;
end;
/ 
--------------------------------------------------------
--   IFF_ROLES_PK
--------------------------------------------------------
declare
    err exception;
    pragma exception_init (err,-02260);
begin
    execute immediate 'alter table iff_roles add constraint iff_roles_pk primary key(role_id)';
    exception when err then null;
end;
/ 
--------------------------------------------------------
--   IFF_FUNCTIONS_PK
--------------------------------------------------------  
declare
    err exception;
    pragma exception_init (err,-02260);
begin
    execute immediate 'alter table iff_functions add constraint iff_functions_pk primary key(function_id)';
    exception when err then null;
end;
/
--------------------------------------------------------
--  Ref Constraints for Table IFF_MENU_ITEMS
--------------------------------------------------------
delete from iff_menu_items where FUNCTION_ID not in(select function_id from iff_functions);
declare
    err exception;
    pragma exception_init (err,-02275);
begin
    execute immediate 'ALTER TABLE "IFF_MENU_ITEMS" ADD CONSTRAINT "IFF_MENU_ITEMS_FK1" FOREIGN KEY ("MENU_TYPE_ID")
REFERENCES "IFF_MENU_ITEM_TYPES" ("MENU_TYPE_ID")';
    exception when err then null;
end;
/

declare
    err exception;
    pragma exception_init (err,-02275);
begin
    execute immediate 'ALTER TABLE "IFF_MENU_ITEMS" ADD CONSTRAINT "IFF_MENU_ITEMS_FK2" FOREIGN KEY ("FUNCTION_ID")
	  REFERENCES "IFF_FUNCTIONS" ("FUNCTION_ID")';
    exception when err then null;
end;
/    
    
declare
    err exception;
    pragma exception_init (err,-02275);
begin
    execute immediate 'ALTER TABLE "IFF_MENU_ITEMS" ADD CONSTRAINT "IFF_MENU_ITEMS_FK_GROUP_ID" FOREIGN KEY ("GROUP_ID")
	  REFERENCES "IFF_MENU_ITEM_GROUP" ("GROUP_ID")';
    exception when err then null;
end;
/  
--------------------------------------------------------
--  Ref Constraints for Table IFF_ROLE_MENU_ITEMS
--------------------------------------------------------
declare
    err exception;
    pragma exception_init (err,-02275);
begin
    execute immediate 'ALTER TABLE "IFF_ROLE_MENU_ITEMS" ADD CONSTRAINT "IFF_ROLE_MENU_ITEMS_FK1" FOREIGN KEY ("ROLE_ID")
	  REFERENCES "IFF_ROLES" ("ROLE_ID")';
    exception when err then null;
end;
/ 

declare
    err exception;
    pragma exception_init (err,-02275);
begin
    execute immediate 'ALTER TABLE "IFF_ROLE_MENU_ITEMS" ADD CONSTRAINT "IFF_ROLE_MENU_ITEMS_FK2" FOREIGN KEY ("ITEM_ID")
REFERENCES "IFF_MENU_ITEMS" ("ITEM_ID")';
    exception when err then null;
end;
/ 
--------------------------------------------------------
--  Ref Constraints for Table IFF_ROLE_TABLE_COLUMNS
--------------------------------------------------------
declare
    err exception;
    pragma exception_init (err,-02275);
begin
    execute immediate 'ALTER TABLE "IFF_ROLE_TABLE_COLUMNS" ADD CONSTRAINT "IFF_ROLE_TABLE_COLUMNS_FK1" FOREIGN KEY ("ROLE_ID", "TABLE_ID")
REFERENCES "IFF_ROLE_TABLES" ("ROLE_ID", "TABLE_ID") ON DELETE CASCADE';
    exception when err then null;
end;
/ 
declare
    err exception;
    pragma exception_init (err,-02275);
begin
    execute immediate 'ALTER TABLE "IFF_ROLE_TABLE_COLUMNS" ADD CONSTRAINT "IFF_ROLE_TABLE_COLUMNS_FK2" FOREIGN KEY ("TABLE_ID", "COLUMN_ID")
	  REFERENCES "IFF_TABLE_COLUMNS" ("TABLE_ID", "COLUMN_ID")';
    exception when err then null;
end;
/ 
--------------------------------------------------------
--  Ref Constraints for Table IFF_ROLE_TABLE_OPTIONS
--------------------------------------------------------
declare
    err exception;
    pragma exception_init (err,-02275);
begin
    execute immediate 'ALTER TABLE "IFF_ROLE_TABLE_OPTIONS" ADD CONSTRAINT "IFF_ROLE_TABLE_OPTIONS_FK1" FOREIGN KEY ("TABLE_OPTION_ID")
REFERENCES "IFF_TABLE_OPTIONS" ("TABLE_OPTION_ID")';
    exception when err then null;
end;
/ 
declare
    err exception;
    pragma exception_init (err,-02275);
begin
    execute immediate 'ALTER TABLE "IFF_ROLE_TABLE_OPTIONS" ADD CONSTRAINT "IFF_ROLE_TABLE_OPTIONS_FK2" FOREIGN KEY ("ROLE_ID", "TABLE_ID")
REFERENCES "IFF_ROLE_TABLES" ("ROLE_ID", "TABLE_ID") ON DELETE CASCADE';
    exception when err then null;
end;
/ 
--------------------------------------------------------
--  Ref Constraints for Table IFF_ROLE_TABLES
--------------------------------------------------------
declare
    err exception;
    pragma exception_init (err,-02275);
begin
    execute immediate 'ALTER TABLE "IFF_ROLE_TABLES" ADD CONSTRAINT "IFF_ROLE_TABLES_FK1" FOREIGN KEY ("ROLE_ID")
REFERENCES "IFF_ROLES" ("ROLE_ID")';
    exception when err then null;
end;
/ 
declare
    err exception;
    pragma exception_init (err,-02275);
begin
    execute immediate 'ALTER TABLE "IFF_ROLE_TABLES" ADD CONSTRAINT "IFF_ROLE_TABLES_FK2" FOREIGN KEY ("TABLE_ID")
REFERENCES "IFF_TABLES" ("TABLE_ID")';
    exception when err then null;
end;
/
--------------------------------------------------------
--  Ref Constraints for Table IFF_ROLE_USERS
--------------------------------------------------------
declare
    err exception;
    pragma exception_init (err,-02275);
begin
    execute immediate 'ALTER TABLE "IFF_ROLE_USERS" ADD CONSTRAINT "IFF_ROLE_USERS_FK1" FOREIGN KEY ("ROLE_ID")
REFERENCES "IFF_ROLES" ("ROLE_ID")';
    exception when err then null;
end;
/

declare
    err exception;
    pragma exception_init (err,-02275);
begin
    execute immediate 'ALTER TABLE "IFF_ROLE_USERS" ADD CONSTRAINT "IFF_ROLE_USERS_FK2" FOREIGN KEY ("USERNAME")
REFERENCES "IFF_USERS" ("USERNAME") ON DELETE CASCADE';
    exception when err then null;
end;
/
--------------------------------------------------------
--  Ref Constraints for Table IFF_ROLE_USER_TABLE_COLUMNS
--------------------------------------------------------
declare
    err exception;
    pragma exception_init (err,-02275);
begin
    execute immediate 'ALTER TABLE "IFF_ROLE_USER_TABLE_COLUMNS" ADD CONSTRAINT "IFF_RL_USR_TBL_COLUMNS_FK1" FOREIGN KEY ("ROLE_ID", "TABLE_ID", "COLUMN_ID")
REFERENCES "IFF_ROLE_TABLE_COLUMNS" ("ROLE_ID", "TABLE_ID", "COLUMN_ID") ON DELETE CASCADE';
    exception when err then null;
end;
/

declare
    err exception;
    pragma exception_init (err,-02275);
begin
    execute immediate 'ALTER TABLE "IFF_ROLE_USER_TABLE_COLUMNS" ADD CONSTRAINT "IFF_RL_USR_TBL_COLUMNS_FK2" FOREIGN KEY ("USERNAME", "TABLE_ID")
REFERENCES "IFF_ROLE_USER_TABLES" ("USERNAME", "TABLE_ID") ON DELETE CASCADE ENABLE';
    exception when err then null;
end;
/

--------------------------------------------------------
--  Ref Constraints for Table IFF_ROLE_USER_TABLES
--------------------------------------------------------
declare
    err exception;
    pragma exception_init (err,-02275);
begin
    execute immediate 'ALTER TABLE "IFF_ROLE_USER_TABLES" ADD CONSTRAINT "IFF_ROLE_USER_TABLES_FK1" FOREIGN KEY ("ROLE_ID", "TABLE_ID")
REFERENCES "IFF_ROLE_TABLES" ("ROLE_ID", "TABLE_ID") ON DELETE CASCADE';
    exception when err then null;
end;
/
declare
    err exception;
    pragma exception_init (err,-02275);
begin
    execute immediate 'ALTER TABLE "IFF_ROLE_USER_TABLES" ADD CONSTRAINT "IFF_ROLE_USER_TABLES_FK2" FOREIGN KEY ("USERNAME", "ROLE_ID")
REFERENCES "IFF_ROLE_USERS" ("USERNAME", "ROLE_ID") ON DELETE CASCADE';
    exception when err then null;
end;
/
--------------------------------------------------------
--  Ref Constraints for Table IFF_TABLE_COLUMNS
--------------------------------------------------------
declare
    err exception;
    pragma exception_init (err,-02275);
begin
    execute immediate 'ALTER TABLE "IFF_TABLE_COLUMNS" ADD CONSTRAINT "IFF_TABLE_COLUMNS_FK1" FOREIGN KEY ("TABLE_ID")
REFERENCES "IFF_TABLES" ("TABLE_ID") ON DELETE CASCADE ENABLE';
    exception when err then null;
end;
/ 
--------------------------------------------------------
--  Ref Constraints for Table IFF_VERSION_CHANGES
--------------------------------------------------------
declare
    err exception;
    pragma exception_init (err,-02275);
begin
    execute immediate 'ALTER TABLE "IFF_VERSION_CHANGES" ADD CONSTRAINT "IFF_VERSION_CHANGES_FK1" FOREIGN KEY ("VERSION_ID")
REFERENCES "IFF_VERSION" ("VERSION_ID") ENABLE';
    exception when err then null;
end;
/ 

declare
    err exception;
    pragma exception_init (err,-02275);
begin
    execute immediate 'ALTER TABLE "IFF_VERSION_CHANGES" ADD CONSTRAINT "IFF_VERSION_CHANGES_FK2" FOREIGN KEY ("CHANGE_TYPE_ID")
REFERENCES "IFF_VERSION_CHANGE_TYPES" ("CHANGE_TYPE_ID") ENABLE';
    exception when err then null;
end;
/  
--------------------------------------------------------
--  Ref Constraints for Table IFF_LANG
--------------------------------------------------------
declare
    err exception;
    pragma exception_init (err,-02260);
begin
    execute immediate 'ALTER TABLE IFF_LANG ADD CONSTRAINT IFF_LANG_PK PRIMARY KEY(LANG_ID)';
    exception when err then null;
end;
/ 
--------------------------------------------------------
--  Ref Constraints for Table IFF_TBL_COL_TRANSLATION
-------------------------------------------------------- 
declare
    err exception;
    pragma exception_init (err,-02260);
begin
    execute immediate 'ALTER TABLE IFF_TBL_COL_TRANSLATION ADD CONSTRAINT IFF_TBL_COL_TRANSLATION_PK PRIMARY KEY(TABLE_ID,COLUMN_ID,LANG_ID)';
    exception when err then null;
end;
/ 
declare
    err exception;
    pragma exception_init (err,-02275);
begin
    execute immediate 'ALTER TABLE IFF_TBL_COL_TRANSLATION ADD CONSTRAINT IFF_TBL_COL_TRANSLATION_FK2 FOREIGN KEY(LANG_ID) REFERENCES IFF_LANG(LANG_ID)';
    exception when err then null;
end;
/ 
declare
    err exception;
    pragma exception_init (err,-02443);
begin
    execute immediate 'alter table IFF_TBL_COL_TRANSLATION drop constraint IFF_TBL_COL_TRANSLATION_FK1';
    exception when err then null;
end;
/
declare
    err exception;
    pragma exception_init (err,-02443);
begin
    execute immediate 'alter table IFF_TBL_COL_TRANSLATION add constraint IFF_TBL_COL_TRANSLATION_FK1 foreign key(table_id,column_id) references iff_table_columns(table_id,column_id) on delete cascade';
    exception when err then null;
end;
/