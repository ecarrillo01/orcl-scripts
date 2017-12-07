-- 37-menu-items-groups-group-id-varchar2

SET SERVEROUTPUT ON;
DECLARE
  col_already_exist exception;
  pragma EXCEPTION_INIT (col_already_exist, -01430);
  BEGIN
 execute immediate('ALTER TABLE iff_menu_item_group add iff_menu_items_tmp_col varchar(30)');
  EXCEPTION when col_already_exist then null;
end;
/

begin
declare 
is_varchar2 number:=0;
begin
SELECT count(*) into is_varchar2 FROM user_tab_cols where table_name='IFF_MENU_ITEM_GROUP' and column_name='GROUP_ID' and data_type='VARCHAR2';
if(is_varchar2=0) then
 begin
    iff_sp_drop_foreign_key('IFF_MENU_ITEMS','GROUP_ID');
    iff_sp_drop_primary_key('IFF_MENU_ITEM_GROUP');
  for x in (select GROUP_ID from IFF_MENU_ITEM_GROUP) LOOP
   update IFF_MENU_ITEM_GROUP set iff_menu_items_tmp_col=x.GROUP_ID where GROUP_ID=x.GROUP_ID;
   END LOOP;
    DECLARE
    is_null exception;
    pragma EXCEPTION_INIT (is_null,-01451);
    BEGIN
    execute immediate 'alter table iff_menu_item_group modify(group_id null)';
    EXCEPTION when is_null then null;
    end;
    update IFF_MENU_ITEM_GROUP set GROUP_ID=null;
   execute immediate 'alter table IFF_MENU_ITEM_GROUP modify GROUP_ID varchar(30)';
  FOR x in (select * from iff_menu_item_group) LOOP
    update iff_menu_item_group set group_id=x.iff_menu_items_tmp_col where iff_menu_items_tmp_col=x.iff_menu_items_tmp_col;
     END LOOP;
   end;
    execute immediate 'alter table iff_menu_item_group modify(group_id not null)';
    execute immediate 'alter table iff_menu_item_group add constraint iff_menu_item_group_pk primary key(GROUP_ID)';
end if;  
end;
end;
/

alter table IFF_MENU_ITEM_GROUP drop COLUMN iff_menu_items_tmp_col;

DECLARE
  col_already_exist exception;
  pragma EXCEPTION_INIT (col_already_exist, -01430);
  BEGIN
 execute immediate('ALTER TABLE iff_menu_items add iff_menu_items_tmp_col varchar(30)');
  EXCEPTION when col_already_exist then null;
end;
/
begin
declare 
is_varchar2 number:=0;
constraint_exists exception;
pragma EXCEPTION_INIT (constraint_exists,-02275);
begin
SELECT count(*) into is_varchar2 FROM user_tab_cols where table_name='IFF_MENU_ITEMS' and column_name='GROUP_ID' and data_type='VARCHAR2';
if(is_varchar2=0) then
 begin
  iff_sp_drop_foreign_key('IFF_MENU_ITEMS','GROUP_ID');
  for x in (select GROUP_ID,ITEM_ID from IFF_MENU_ITEMS where group_id is not null) LOOP
   update IFF_MENU_ITEMS set iff_menu_items_tmp_col=x.GROUP_ID where ITEM_ID=x.ITEM_ID;
   END LOOP;
    DECLARE
    is_null exception;
    pragma EXCEPTION_INIT (is_null,-01451);
    BEGIN
    execute immediate 'alter table iff_menu_items modify(group_id null)';
    EXCEPTION when is_null then
    Dbms_Output.Put_Line('IFF_MENU_ITEMS.GROUP_ID is alreay nullable');
    end;
    update IFF_MENU_ITEMS set GROUP_ID=null;
   execute immediate 'alter table IFF_MENU_ITEMS modify GROUP_ID varchar(30)';
  FOR x in (select * from iff_menu_items) LOOP
    update iff_menu_items set group_id=x.iff_menu_items_tmp_col where item_id=x.item_id;
     END LOOP;
   end;
end if;
    execute immediate 'alter table iff_menu_items add constraint iff_menu_items_fk_group_id foreign key(GROUP_ID) references IFF_MENU_ITEM_GROUP(GROUP_ID)';
    exception when constraint_exists then null;
end;
end;
/

alter table IFF_MENU_ITEMS drop COLUMN iff_menu_items_tmp_col;

declare
    err exception;
    pragma exception_init (err,-04080);
begin
    execute immediate 'drop TRIGGER IFF_TGR_MENU_ITEM_GROUP_BI';
    exception when err then null;
end;
/

declare
    err exception;
    pragma exception_init (err,-02289);
begin
    execute immediate 'drop sequence IFF_MENU_ITEM_GROUP_SEQ';
    exception when err then null;
end;
/