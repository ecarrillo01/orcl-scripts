SET SERVEROUTPUT ON;
DECLARE
  col_already_exist exception;
  pragma EXCEPTION_INIT (col_already_exist, -01430);
  BEGIN
 execute immediate('ALTER TABLE IFF_TABLE_OPTIONS ADD FUNCTION_ID_TMP_COL VARCHAR(35)');
  EXCEPTION when col_already_exist then null;
end;
/

begin
declare 
is_varchar2 number:=0;
cols_data_dif number:=0;
function_id_idx varchar(30):=null;
begin
SELECT count(*) into is_varchar2 FROM user_tab_cols where table_name='IFF_TABLE_OPTIONS' and column_name='FUNCTION_ID' and data_type='VARCHAR2';
if(is_varchar2=0) then
 begin
    iff_sp_drop_foreign_key('IFF_TABLE_OPTIONS','FUNCTION_ID');
    for x in (select FUNCTION_ID,TABLE_OPTION_ID from IFF_TABLE_OPTIONS) LOOP
     update IFF_TABLE_OPTIONS set FUNCTION_ID_TMP_COL=x.FUNCTION_ID where TABLE_OPTION_ID=x.TABLE_OPTION_ID;
     END LOOP;
      DECLARE
      is_null exception;
      pragma EXCEPTION_INIT (is_null,-01451);
      BEGIN
      execute immediate 'alter table IFF_TABLE_OPTIONS modify(FUNCTION_ID null)';
      EXCEPTION when is_null then null;
      end;
      update IFF_TABLE_OPTIONS set FUNCTION_ID=null;
      execute immediate 'alter table IFF_TABLE_OPTIONS modify FUNCTION_ID varchar(35)';
    FOR x in (select * from IFF_TABLE_OPTIONS) LOOP
      update IFF_TABLE_OPTIONS set FUNCTION_ID=x.FUNCTION_ID_tmp_col where TABLE_OPTION_ID=x.TABLE_OPTION_ID;
       END LOOP;
      execute immediate 'alter table IFF_TABLE_OPTIONS modify(FUNCTION_ID not null)';
      select count(*) into cols_data_dif from IFF_TABLE_OPTIONS where FUNCTION_ID!=FUNCTION_ID_tmp_col;
      if(cols_data_dif=0) then
      execute immediate('alter table IFF_TABLE_OPTIONS drop column FUNCTION_ID_tmp_col');
      end if;
    end;
else
 execute immediate('alter table IFF_TABLE_OPTIONS drop column FUNCTION_ID_tmp_col');
end if;  
end;
end;
/

