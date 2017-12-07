SET SERVEROUTPUT ON;

Insert into IFF_TABLE_COLUMN_DATASET (DATASET_ID) values ('link-type');
Insert into IFF_TABLE_COLUMN_DATASET (DATASET_ID) values ('yes-no-combobox');

Insert into IFF_TABLE_COLUMN_DATASET_LIST (DATASET_ID,OPTION_KEY,OPTION_VALUE) values ('yes-no-combobox','0','No');
Insert into IFF_TABLE_COLUMN_DATASET_LIST (DATASET_ID,OPTION_KEY,OPTION_VALUE) values ('yes-no-combobox','1','Yes');
Insert into IFF_TABLE_COLUMN_DATASET_LIST (DATASET_ID,OPTION_KEY,OPTION_VALUE) values ('link-type','0','Client');
Insert into IFF_TABLE_COLUMN_DATASET_LIST (DATASET_ID,OPTION_KEY,OPTION_VALUE) values ('link-type','1','Server');

insert into iff_params(param_key,param_value,param_description) values('session-max-minutes',5,'session max activity time in minutes');
insert into iff_params values('logQuery',0,'set console query log true or false posible values are 0=false,1=true');

Insert into IFF_FUNCTIONS (FUNCTION_ID,FUNCTION_NAME,DESCRIPTION) values ('1','gf.default_insert','Located in general functions, this function is to open a dialogue in order to insert a record');
Insert into IFF_FUNCTIONS (FUNCTION_ID,FUNCTION_NAME,DESCRIPTION) values ('2','gf.default_edit','Located in general functions, this function is to open a dialogue in order to update a record');
Insert into IFF_FUNCTIONS (FUNCTION_ID,FUNCTION_NAME,DESCRIPTION) values ('3','gf.default_delete','Located in general function, when you click on the accept button it will call gf.execute_default_delete function');
Insert into IFF_FUNCTIONS (FUNCTION_ID,FUNCTION_NAME,DESCRIPTION) values ('4','iffUser.get_table','This use the generanl functions get table function');
Insert into IFF_FUNCTIONS (FUNCTION_NAME,DESCRIPTION) values ('iffUser.tableAuditDetail','iffUser.tableAuditDetail');

Insert into IFF_MENU_ITEM_GROUP (GROUP_ID,GROUP_NAME) values ('system-settings','SYSTEM SETTINGS');

Insert into IFF_MENU_ITEM_TYPES (MENU_TYPE_ID,MENU_TYPE_NAME) values ('1','TABLE');

Insert into IFF_ROLES (ROLE_ID,ROLE_NAME) values (1,'ADMIN');

Insert into IFF_USERS (USERNAME,PASSWORD,NAME,LASTNAME,PASSWORD_ALGORITHM_VERSION) VALUES('Administrator','sdf9D08DThJOJ+GH5oEs+A==','Administrator','Administrator','v2');
INSERT INTO IFF_ROLE_USERS VALUES(1,'Administrator');
Insert into IFF_TABLE_OPTIONS (TABLE_OPTION_ID,OPTION_NAME,FUNCTION_ID,OPTION_FOR) values ('1','Insert','1','TABLE ROWS');
Insert into IFF_TABLE_OPTIONS (TABLE_OPTION_ID,OPTION_NAME,FUNCTION_ID,OPTION_FOR) values ('2','Update','2','TABLE');
Insert into IFF_TABLE_OPTIONS (TABLE_OPTION_ID,OPTION_NAME,FUNCTION_ID,OPTION_FOR) values ('3','Delete','3','TABLE');
Insert into IFF_TABLE_OPTIONS (TABLE_OPTION_ID,OPTION_NAME,FUNCTION_ID,OPTION_FOR) values ('4','Audit detail',(select function_id from iff_functions where function_name='iffUser.tableAuditDetail'),'TABLE');

--Register tables with columns 

declare
    err exception;
    pragma exception_init (err,-00001);
begin
    for x in(select t1.* from user_tables t1
left join iff_tables t2 on t1.table_name=t2.table_name
where UPPER(t1.table_name)=t1.table_name
and t2.table_name is null and t1.table_name like 'IFF_%' and t1.table_name not in('IFF_INSTALL_LOG_SCRIPT',
'IFF_ROLE_USER_TABLE_COLUMNS',
'IFF_ROLE_USER_TABLES',
'IFF_SESSION',
'IFF_SESSION_ACTIVITY',
'IFF_VERSION',
'IFF_VERSION_CHANGES',
'IFF_VERSION_CHANGE_TYPES',
'IFF_FUNCTIONS',
'IFF_TABLE_OPTIONS',
'IFF_LANG',
'IFF_TABLE_COLUMN_DATASET',
'IFF_TABLE_COLUMN_DATASET_LIST',
'IFF_MENU_ITEM_TYPES',
'IFF_ROLE_MENU_ITEMS',
'IFF_ROLE_TABLES',
'IFF_ROLE_TABLE_OPTIONS',
'IFF_ROLE_TABLE_COLUMNS',
'IFF_MENU_ITEMS',
'IFF_MENU_ITEM_GROUP',
'IFF_TBL_COL_TRANSLATION'
)
) loop
      insert into iff_tables(table_name) values(x.table_name);
    end loop;
    exception when err then null;
end;
/

--Register new columns to existing tables

declare
    err exception;
    pragma exception_init (err,-00001);
begin
    for x in(select t2.table_id,
t1.table_name,
t1.column_name,
t1.data_length 
from user_tab_cols t1 
join iff_tables t2 on t2.table_name=t1.table_name
left join iff_table_columns t3 on t3.table_id=t2.table_id and t3.column_name=t1.column_name
where t3.column_name is null) loop
     DBMS_OUTPUT.PUT_LINE('my loop with table name ' || x.table_name||' and column_name '||x.column_name);
      insert into iff_table_columns(table_id,column_name,display_value,auto_insertable,is_filter,is_primary_key,max_length) values(x.table_id,x.column_name,x.column_name,0,0,0,x.data_length);
    end loop;
     exception when err then null;
end;
/

-- Add all tables to admin role

declare
    err exception;
    pragma exception_init (err,-00001);
     admin_role_id number:=0;
begin
    select role_id into admin_role_id from iff_roles where ROLE_NAME='ADMIN';
    for x in(select t1.table_id,t1.table_name,t2.role_id from iff_tables t1 
    left join(
    select t2.* from iff_roles t1 join iff_role_tables t2 on t1.role_id=t2.role_id and t1.role_name='ADMIN'
    ) t2 on t1.table_id=t2.table_id
    where t2.table_id is null) loop
      insert into iff_role_tables(role_id,table_id) values(admin_role_id,x.table_id);
    end loop;
    exception when err then null;
end;
/

-- Add all table options to admin role tables

begin
for x in(select t1.*,t2.role_name from iff_role_tables t1
join iff_roles t2 on t1.role_id=t2.role_id
join iff_tables t3 on t3.table_id=t1.table_id where t3.table_name like 'IFF_%'
and t2.role_name='ADMIN' and t3.table_name not in('IFF_APP_AUDIT',
'IFF_SESSION',
'IFF_SESSION_ACTIVITY','IFF_MENU_ITEMS')) loop
  for y in(
  select t1.* from iff_table_options t1 where table_option_id not in(select table_option_id from iff_role_table_options where role_id=x.role_id and table_id=x.table_id)
  ) loop
  insert into iff_role_table_options(role_id,table_id,table_option_id) values(x.role_id,x.table_id,y.table_option_id);
  end loop;
end loop;
end;
/

-- Add all menu items to admin role

begin
declare admin_role_id number:=0;
  begin
    select role_id into admin_role_id from iff_roles where role_name='ADMIN';
    for x in(SELECT t1.ITEM_ID,
    t1.ITEM_NAME FROM IFF_MENU_ITEMS t1 
    left join iff_tables t2 on t2.table_name=t1.parameters 
    left join iff_role_tables t4 on t4.table_id=t2.table_id and t4.role_id=admin_role_id 
    left join iff_role_menu_items t5 on t5.role_id=t4.role_id and t5.item_id=t1.item_id 
    left join iff_role_menu_items t6 on t6.role_id=admin_role_id and t6.item_id=t1.item_id 
    where (t4.role_id=admin_role_id and t5.item_id is null) or (t2.table_id is null and t6.role_id is null)) loop
      insert into iff_role_menu_items(role_id,item_id) values(admin_role_id,x.item_id);
      --update iff_menu_items set group_id='system-settings' where item_id=
    end loop;
  end;
end;
/

-- iff setting

UPDATE
  (SELECT 
t1.table_name,
t2.*
  FROM iff_tables t1
  JOIN iff_table_columns t2
  ON t1.table_id = t2.table_id
) t
SET
 t.is_filter = 1,
 referenced_table='IFF_TABLES',
 referenced_key_column='TABLE_ID',
 referenced_value_column='TABLE_NAME'
where t.table_name='IFF_TABLE_COLUMNS' and t.column_name='TABLE_ID';

UPDATE
  (SELECT t1.table_name,t2.column_id,t2.column_name,t2.is_filter
  FROM iff_tables t1
  JOIN iff_table_columns t2
  ON t1.table_id = t2.table_id
) t
SET is_filter=1 where t.column_name='COLUMN_NAME' and t.table_name='IFF_TABLE_COLUMNS';

--IS_PRIMARY_KEY

UPDATE
  (SELECT t1.table_name,t2.*
  FROM iff_tables t1
  JOIN iff_table_columns t2
  ON t1.table_id = t2.table_id
) t
SET static_options='{"0":"No","1":"Yes"}'
 where t.table_name='IFF_TABLE_COLUMNS' 
 and t.column_name in('IS_PRIMARY_KEY','IS_FILTER');


-- IFF_ROLE_TABLE_COLUMNS

--ROLE_ID 

UPDATE
  (SELECT 
t1.table_name,
t2.*
  FROM iff_tables t1
  JOIN iff_table_columns t2
  ON t1.table_id = t2.table_id
) t
SET
 t.is_filter = 1,
 referenced_table='IFF_ROLES',
 referenced_key_column='ROLE_ID',
 referenced_value_column='ROLE_NAME'
where t.table_name='IFF_ROLE_TABLE_COLUMNS' and t.column_name='ROLE_ID';

-- IFF_TBL_COL_TRANSLATION

--TABLE_ID 

UPDATE
  (SELECT 
t1.table_name,
t2.*
  FROM iff_tables t1
  JOIN iff_table_columns t2
  ON t1.table_id = t2.table_id
) t
SET
 t.referenced_table='IFF_TABLES',
 t.referenced_key_column='TABLE_ID',
 t.referenced_value_column='TABLE_NAME'
where t.table_name='IFF_TBL_COL_TRANSLATION' and t.column_name='TABLE_ID';

--COLUMN_ID

UPDATE
  (SELECT 
t1.table_name,
t2.*
  FROM iff_tables t1
  JOIN iff_table_columns t2
  ON t1.table_id = t2.table_id
) t
SET
 t.referenced_table='IFF_TABLE_COLUMNS',
 t.referenced_key_column='COLUMN_ID',
 t.referenced_value_column='COLUMN_NAME',
 t.depending_column='TABLE_ID'
where t.table_name='IFF_TBL_COL_TRANSLATION' and t.column_name='COLUMN_ID';


--LANG_ID

UPDATE
  (SELECT 
t1.table_name,
t2.*
  FROM iff_tables t1
  JOIN iff_table_columns t2
  ON t1.table_id = t2.table_id
) t
SET
 t.referenced_table='IFF_LANG',
 t.referenced_key_column='LANG_ID',
 t.referenced_value_column='LANG_DESCRIPTION'
where t.table_name='IFF_TBL_COL_TRANSLATION' and t.column_name='LANG_ID';

--IFF_MENU_ITEMS 

UPDATE
  (SELECT 
t1.table_name,
t2.*
  FROM iff_tables t1
  JOIN iff_table_columns t2
  ON t1.table_id = t2.table_id
) t
SET
t.is_filter=1
where t.table_name='IFF_MENU_ITEMS' and t.column_name='ITEM_NAME';


-- Group admin items

update iff_menu_items set group_id='system-settings' where parameters like 'IFF_%';

-- Iff users password

UPDATE
  (SELECT 
t1.table_name,
t2.*
  FROM iff_tables t1
  JOIN iff_table_columns t2
  ON t1.table_id = t2.table_id
) t
SET
t.form_control_type='password'
where t.table_name='IFF_USERS' and t.column_name='PASSWORD';

exec iff_sp_set_auto_insertable_col('IFF_USERS','PASSWORD_ALGORITHM_VERSION');

UPDATE
  (SELECT 
t1.table_name,
t2.*
  FROM iff_tables t1
  JOIN iff_table_columns t2
  ON t1.table_id = t2.table_id
) t
SET
t.enabled=0
where t.table_name='IFF_USERS' and t.column_name='PASSWORD_ALGORITHM_VERSION' or t.column_name='SCHEDULE';

UPDATE
  (SELECT 
t1.table_name,
t2.*
  FROM iff_tables t1
  JOIN iff_table_columns t2
  ON t1.table_id = t2.table_id
) t
SET
t.enabled=0
where t.table_name='IFF_TABLE_COLUMNS' and t.column_name='HAS_STATIC_QUERY';

-- delete disabled columns from role table columns

begin
  for x in(
  select t1.table_id,t1.column_id from iff_table_columns t1
  join iff_role_table_columns t2 on t1.table_id=t2.table_id and t1.column_id=t2.column_id
  where t1.enabled=0) loop
  delete from iff_role_table_columns where table_id=x.table_id and column_id=x.column_id;
  end loop;
end;
/

-- Role tables

UPDATE
  (SELECT 
t1.table_name,
t2.*
  FROM iff_tables t1
  JOIN iff_table_columns t2
  ON t1.table_id = t2.table_id
) t
SET
t.referenced_table='IFF_ROLES',
t.referenced_key_column='ROLE_ID',
t.referenced_value_column='ROLE_NAME'
where t.table_name='IFF_ROLE_TABLES' and t.column_name='ROLE_ID';

UPDATE
  (SELECT 
	t1.table_name,
	t2.*
  FROM iff_tables t1
  JOIN iff_table_columns t2
  ON t1.table_id = t2.table_id
) t
SET
t.referenced_table='IFF_TABLES',
t.referenced_key_column='TABLE_ID',
t.referenced_value_column='TABLE_NAME'
where t.table_name='IFF_ROLE_TABLES' and t.column_name='TABLE_ID';

UPDATE
  (SELECT 
	t1.table_name,
	t2.*
  FROM iff_tables t1
  JOIN iff_table_columns t2
  ON t1.table_id = t2.table_id
) t
SET
t.is_filter=1,
t.referenced_table='IFF_ROLES',
t.referenced_key_column='ROLE_ID',
t.referenced_value_column='ROLE_NAME'
where t.table_name='IFF_ROLE_MENU_ITEMS' and t.column_name='ROLE_ID';

UPDATE
  (SELECT 
	t1.table_name,
	t2.*
  FROM iff_tables t1
  JOIN iff_table_columns t2
  ON t1.table_id = t2.table_id
) t
SET
t.referenced_table='IFF_MENU_ITEMS',
t.referenced_key_column='ITEM_ID',
t.referenced_value_column='ITEM_NAME'
where t.table_name='IFF_MENU_ITEMS' and t.column_name='ITEM_ID';

UPDATE
  (SELECT 
	t1.table_name,
	t2.*
  FROM iff_tables t1
  JOIN iff_table_columns t2
  ON t1.table_id = t2.table_id
) t
SET
t.referenced_table='IFF_ROLES',
t.referenced_key_column='ROLE_ID',
t.referenced_value_column='ROLE_NAME'
where t.table_name='IFF_ROLE_USERS' and t.column_name='ROLE_ID';

UPDATE
  (SELECT 
	t1.table_name,
	t2.*
  FROM iff_tables t1
  JOIN iff_table_columns t2
  ON t1.table_id = t2.table_id
) t
SET
t.referenced_table='IFF_USERS',
t.referenced_key_column='USERNAME',
t.referenced_value_column='USERNAME'
where t.table_name='IFF_ROLE_USERS' and t.column_name='USERNAME';

-- IFF_ROLE_MENU_ITEMS

UPDATE
  (SELECT 
	t1.table_name,
	t2.*
  FROM iff_tables t1
  JOIN iff_table_columns t2
  ON t1.table_id = t2.table_id
) t
SET
t.referenced_table='IFF_MENU_ITEMS',
t.referenced_key_column='ITEM_ID',
t.referenced_value_column='ITEM_NAME'
where t.table_name='IFF_ROLE_MENU_ITEMS' and t.column_name='ITEM_ID';

exec iff_sp_delete_table_column('IFF_MENU_ITEMS','IFF_MENU_ITEMS_TMP_COL');

-- IFF_ROLE_TABLES

UPDATE
  (SELECT 
	t1.table_name,
	t2.*
  FROM iff_tables t1
  JOIN iff_table_columns t2
  ON t1.table_id = t2.table_id
) t
SET
t.is_filter=1 where t.table_name='IFF_ROLE_TABLES' and t.column_name='ROLE_ID';

exec iff_sp_delete_table('IFF_INSTALL_LOG_SCRIPT');
exec iff_sp_delete_table('IFF_ROLE_USER_TABLE_COLUMNS');
exec iff_sp_delete_table('IFF_ROLE_USER_TABLES');

UPDATE
  (SELECT 
	t1.table_name,
	t2.*
  FROM iff_tables t1
  JOIN iff_table_columns t2
  ON t1.table_id = t2.table_id
) t
SET
t.is_filter=1 where t.table_name='IFF_APP_AUDIT' and t.column_name='ACTION_TYPE';

--IFF_ROLE_TABLE_OPTIONS

UPDATE
  (SELECT 
	t1.table_name,
	t2.*
  FROM iff_tables t1
  JOIN iff_table_columns t2
  ON t1.table_id = t2.table_id
) t
SET
t.is_filter=1,
t.referenced_table='IFF_ROLES',
t.referenced_key_column='ROLE_ID',
t.referenced_value_column='ROLE_NAME'
where t.table_name='IFF_ROLE_TABLE_OPTIONS' and t.column_name='ROLE_ID'
and t.referenced_table is null;

exec iff_sp_delete_table_column('IFF_USERS','PASSWORD_HISTORY');

UPDATE
  (SELECT 
	t1.table_name,
	t2.*
  FROM iff_tables t1
  JOIN iff_table_columns t2
  ON t1.table_id = t2.table_id
) t
SET
t.is_filter=1
where t.table_name='IFF_TABLES' and t.column_name='TABLE_NAME' and t.is_filter!=1;

UPDATE
  (SELECT 
	t1.table_name,
	t2.*
  FROM iff_tables t1
  JOIN iff_table_columns t2
  ON t1.table_id = t2.table_id
) t
SET
t.referenced_table='IFF_MENU_ITEM_GROUP',
t.referenced_key_column='GROUP_ID',
t.referenced_value_column='GROUP_NAME'
where t.table_name='IFF_MENU_ITEMS' and t.column_name='GROUP_ID' 
and (t.referenced_table is null
or t.referenced_key_column is null
or t.referenced_value_column is null);

UPDATE
  (SELECT 
	t1.table_name,
	t2.*
  FROM iff_tables t1
  JOIN iff_table_columns t2
  ON t1.table_id = t2.table_id
) t
SET
t.enabled=0
where t.table_name='IFF_TABLE_COLUMNS' and t.column_name='IS_PRIMARY_KEY' 
and t.enabled=1;

declare
    err exception;
    pragma exception_init (err,-00001);
begin
    insert into iff_lang(LANG_ID,LANG_DESCRIPTION) values('es','Spanish');
    exception when err then 
    update iff_lang set lang_description='Spanish' where lang_id='es' and lang_description is null;
end;
/

declare
    err exception;
    pragma exception_init (err,-00001);
begin
    insert into iff_lang(LANG_ID,LANG_DESCRIPTION) values('en','English');
    exception when err then 
    update iff_lang set lang_description='English' where lang_id='en' and lang_description is null;
end;
/
exec iff_sp_delete_table('IFF_ROLE_TABLE_COLUMNS');
/*
exec iff_sp_delete_table('IFF_VERSION');
exec iff_sp_delete_table('IFF_VERSION_CHANGES');
exec iff_sp_delete_table('IFF_VERSION_CHANGE_TYPES');
exec iff_sp_delete_table('IFF_SESSION');
exec iff_sp_delete_table('IFF_SESSION_ACTIVITY');
exec iff_sp_delete_table('IFF_FUNCTIONS');
exec iff_sp_delete_table('IFF_TABLE_OPTIONS');
exec iff_sp_delete_table('IFF_LANG');
exec iff_sp_delete_table('IFF_TABLE_COLUMN_DATASET');
exec iff_sp_delete_table('IFF_TABLE_COLUMN_DATASET_LIST');
exec iff_sp_delete_table('IFF_MENU_ITEM_TYPES');
exec iff_sp_delete_table('IFF_ROLE_MENU_ITEMS');
exec iff_sp_delete_table('IFF_ROLE_TABLES');
exec iff_sp_delete_table('IFF_ROLE_TABLE_OPTIONS');
exec iff_sp_delete_table('IFF_MENU_ITEMS');
exec iff_sp_delete_table('IFF_MENU_ITEM_GROUP');
*/

UPDATE
  (SELECT 
	t1.table_name,
	t2.*
  FROM iff_tables t1
  JOIN iff_table_columns t2
  ON t1.table_id = t2.table_id
) t
SET
t.referenced_table='IFF_LANG',
t.referenced_key_column='LANG_ID',
t.referenced_value_column='LANG_DESCRIPTION'
where t.table_name='IFF_USERS' and t.column_name='LANG_ID' 
and t.enabled=1;

UPDATE iff_table_columns set static_options='yes-no-combobox' where static_options='{"0":"No","1":"Yes"}';
update iff_table_columns set static_options='link-type' where column_name='LINK_TYPE' and static_options!='link-type';

UPDATE
  (SELECT 
	t1.table_name,
	t2.*
  FROM iff_tables t1
  JOIN iff_table_columns t2
  ON t1.table_id = t2.table_id
) t
SET
t.auto_insertable=1
where t.table_name='IFF_MENU_ITEMS' and t.column_name='PARAMETERS' 
and t.auto_insertable=0;

--Delete audit context menu

delete from iff_role_table_options where table_id in(select table_id from iff_tables where table_name='IFF_APP_AUDIT');

--Remove audit detail context menu

begin
for x in(select * from iff_table_options where table_option_id in(select table_option_id from iff_table_options where option_name='Audit detail')) loop
delete from iff_role_table_options where table_option_id=x.table_option_id;
delete from iff_table_options where table_option_id=x.table_option_id;
end loop;
end;
/
