SET SERVEROUTPUT ON;
  CREATE TABLE IFF_INSTALL_LOG_SCRIPT
   (SCRIPT_NAME VARCHAR2(35), 
	STATUS NUMBER DEFAULT 0 NOT NULL
   );
ALTER TABLE "IFF_INSTALL_LOG_SCRIPT" ADD CONSTRAINT "IFF_INSTALL_LOG_SCRIPT_PK" PRIMARY KEY ("SCRIPT_NAME");

Insert into IFF_INSTALL_LOG_SCRIPT (SCRIPT_NAME,STATUS) values ('admin-group-created','0');
Insert into IFF_INSTALL_LOG_SCRIPT (SCRIPT_NAME,STATUS) values ('iff-admin-tables-grouped','0');
Insert into IFF_INSTALL_LOG_SCRIPT (SCRIPT_NAME,STATUS) values ('administrator-user-created','0');
Insert into IFF_INSTALL_LOG_SCRIPT (SCRIPT_NAME,STATUS) values ('administrator-user-assigned','0');

begin 
    declare   
    script_status number:=0;
    begin
      select status into script_status  from iff_install_log_script where script_name='admin-group-created';
      if(script_status=0) then
      insert into iff_menu_item_group(group_id,group_name) values('system-settings','SYSTEM SETTINGS');
      update iff_install_log_script set status=1 where script_name='admin-group-created';
        Dbms_Output.Put_Line('Admin group created');
      else
       Dbms_Output.Put_Line('Admin group is already created');
      end if;
    end;
end ;
/

begin 
    declare   
    script_status number:=0;
    begin
      select status into script_status  from iff_install_log_script where script_name='iff-admin-tables-grouped';
      if(script_status=0) then
      update iff_menu_items set group_id=(select group_id from iff_menu_item_group where group_id='system-settings') where parameters like 'IFF_%';
      update iff_install_log_script set status=1 where script_name='iff-admin-tables-grouped';
      Dbms_Output.Put_Line('iff tables grouped');
      else
       Dbms_Output.Put_Line('iff tables already grouped');
      end if;
    end;
end ;
/
begin 
    declare   
      script_status number:=0;
        begin
          select status into script_status  from iff_install_log_script where script_name='administrator-user-created';
          if(script_status=0) then
          Insert into IFF_USERS (USERNAME,PASSWORD,NAME,LASTNAME,PASSWORD_ALGORITHM_VERSION) VALUES('Administrator','sdf9D08DThJOJ+GH5oEs+A==','Administrator','Administrator','v2');
          update iff_install_log_script set status=1 where script_name='administrator-user-created';
          Dbms_Output.Put_Line('administrator user created');
          else
           Dbms_Output.Put_Line('administrator user already created');
          end if;
      end;
end ;
/
begin 
    declare   
      script_status number:=0;
        begin
          select status into script_status  from iff_install_log_script where script_name='administrator-user-assigned';
          if(script_status=0) then
          insert into iff_role_users values((select role_id from iff_roles where role_name='ADMIN'),'Administrator');
            Dbms_Output.Put_Line('administrator user assigned');
            update iff_install_log_script set status=1 where script_name='administrator-user-assigned';
          else
          Dbms_Output.Put_Line('administrator user already assigned');
          end if;
      end;
end ;
/