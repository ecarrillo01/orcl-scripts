-- Not null column of empty table
update table_columns set display_value=column_name where display_value is null;
DECLARE
  is_already_not_null exception;
  pragma EXCEPTION_INIT (is_already_not_null,-01442);
  BEGIN
	execute immediate('alter table table_columns modify display_value not null');
  EXCEPTION when is_already_not_null then null;
end;
/

-- Not null column with data


begin
declare 
is_varchar2 number:=0;
begin
SELECT count(*) into is_varchar2 FROM user_tab_cols where table_name='MENU_ITEM_GROUP' and column_name='GROUP_ID' and data_type='VARCHAR2';
if(is_varchar2=0) then
 begin
    sp_drop_foreign_key('MENU_ITEMS','GROUP_ID');
    sp_drop_primary_key('MENU_ITEM_GROUP');
  for x in (select GROUP_ID from MENU_ITEM_GROUP) LOOP
   update MENU_ITEM_GROUP set menu_items_tmp_col=x.GROUP_ID where GROUP_ID=x.GROUP_ID;
   END LOOP;
    DECLARE
    is_null exception;
    pragma EXCEPTION_INIT (is_null,-01451);
    BEGIN
    execute immediate 'alter table menu_item_group modify(group_id null)';
    EXCEPTION when is_null then null;
    end;
    update MENU_ITEM_GROUP set GROUP_ID=null;
   execute immediate 'alter table MENU_ITEM_GROUP modify GROUP_ID varchar(30)';
  FOR x in (select * from menu_item_group) LOOP
    update menu_item_group set group_id=x.menu_items_tmp_col where menu_items_tmp_col=x.menu_items_tmp_col;
     END LOOP;
   end;
    execute immediate 'alter table menu_item_group modify(group_id not null)';
    execute immediate 'alter table menu_item_group add constraint menu_item_group_pk primary key(GROUP_ID)';
end if;  
end;
end;
/

alter table MENU_ITEM_GROUP drop COLUMN menu_items_tmp_col;