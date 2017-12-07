SET SERVEROUTPUT ON;
begin
declare fix_system_settings number:=0;
  begin
  select count(*) into fix_system_settings from iff_menu_item_group where group_id='sistem-settings';
    if(fix_system_settings>0) then
      DBMS_OUTPUT.PUT_LINE('going to fix mispelled word');
      execute immediate('alter table iff_menu_items drop constraint IFF_MENU_ITEMS_FK_GROUP_ID');
      update iff_menu_items set group_id =null where group_id='sistem-settings';
      delete from iff_menu_item_group where group_id='sistem-settings';
      update iff_menu_item_group set group_id='system-settings' where group_name='SYSTEM SETTINGS';
      execute immediate('alter table iff_menu_items add constraint IFF_MENU_ITEMS_FK_GROUP_ID foreign key(group_id) references iff_menu_item_group(group_id)');
      update iff_install_log_script set status=0;
      delete from iff_menu_item_group where group_id='sistem-settings' or group_name='System settings';
    end if;
  end;
end;
/