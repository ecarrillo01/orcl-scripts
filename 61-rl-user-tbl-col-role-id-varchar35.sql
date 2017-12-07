-- Role users table columns role id varchar(35)
SET SERVEROUTPUT ON;
DECLARE
  col_already_exist exception;
  pragma EXCEPTION_INIT (col_already_exist, -01430);
  BEGIN
 execute immediate('ALTER TABLE IFF_ROLE_USER_TABLE_COLUMNS ADD ROLE_ID_TMP_COL VARCHAR(35)');
  EXCEPTION when col_already_exist then null;
end;
/

begin
declare 
is_varchar2 number:=0;
cols_data_dif number:=0;
role_id_idx varchar(30):=null;
begin
SELECT count(*) into is_varchar2 FROM user_tab_cols where table_name='IFF_ROLE_USER_TABLE_COLUMNS' and column_name='ROLE_ID' and data_type='VARCHAR2';
if(is_varchar2=0) then
 begin
    iff_sp_drop_foreign_key('IFF_ROLE_USER_TABLE_COLUMNS','USERNAME');
    iff_sp_drop_primary_key('IFF_ROLE_USER_TABLE_COLUMNS'); 
    for x in (select * from IFF_ROLE_USER_TABLE_COLUMNS) LOOP
     update IFF_ROLE_USER_TABLE_COLUMNS set ROLE_ID_TMP_COL=x.ROLE_ID where ROLE_ID=x.ROLE_ID AND username =x.username and table_id=x.table_id and column_id=x.column_id;
     END LOOP;
      DECLARE
      is_null exception;
      pragma EXCEPTION_INIT (is_null,-01451);
      BEGIN
      execute immediate 'alter table IFF_ROLE_USER_TABLE_COLUMNS modify(ROLE_ID null)';
      EXCEPTION when is_null then null;
      end;
        begin
          select index_name  into role_id_idx from USER_IND_COLUMNS where table_name='IFF_ROLE_USER_TABLE_COLUMNS' and column_name='ROLE_ID';
          exception when NO_DATA_FOUND then null;
        end;
        if(role_id_idx is not null) then
         execute immediate('drop index '|| role_id_idx);
        end if;
      update IFF_ROLE_USER_TABLE_COLUMNS set ROLE_ID=null;
      execute immediate 'alter table IFF_ROLE_USER_TABLE_COLUMNS modify ROLE_ID varchar(35)';
    FOR x in (select * from IFF_ROLE_USER_TABLE_COLUMNS) LOOP
      update IFF_ROLE_USER_TABLE_COLUMNS set role_id=x.role_id_tmp_col where role_id_tmp_col=x.role_id_tmp_col and username=x.username and table_id=x.table_id and column_id=x.column_id;
       END LOOP;
      execute immediate 'alter table IFF_ROLE_USER_TABLE_COLUMNS modify(role_id not null)';
      execute immediate 'alter table IFF_ROLE_USER_TABLE_COLUMNS add constraint IFF_ROLE_USER_TABLE_COLUMNS_PK primary key(USERNAME,TABLE_ID,COLUMN_ID)';
      select count(*) into cols_data_dif from IFF_ROLE_USER_TABLE_COLUMNS where role_id!=role_id_tmp_col;
      if(cols_data_dif=0) then
      execute immediate('alter table IFF_ROLE_USER_TABLE_COLUMNS drop column role_id_tmp_col');
      end if;
    end;
    else
    execute immediate('alter table IFF_ROLE_USER_TABLE_COLUMNS drop column role_id_tmp_col');
end if;  
end;
end;
/

