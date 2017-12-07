SET SERVEROUTPUT ON;
DECLARE
  col_already_exist exception;
  pragma EXCEPTION_INIT (col_already_exist, -01430);
  BEGIN
 execute immediate('ALTER TABLE IFF_FUNCTIONS ADD FUNCTION_ID_TMP_COL VARCHAR(35)');
  EXCEPTION when col_already_exist then null;
end;
/

begin
declare 
is_varchar2 number:=0;
cols_data_dif number:=0;
function_id_idx varchar(30):=null;
begin
SELECT count(*) into is_varchar2 FROM user_tab_cols where table_name='IFF_FUNCTIONS' and column_name='FUNCTION_ID' and data_type='VARCHAR2';
if(is_varchar2=0) then
 begin
    IFF_SP_DROP_PRIMARY_KEY('IFF_FUNCTIONS');
    for x in (select * from IFF_FUNCTIONS) LOOP
     update IFF_FUNCTIONS set FUNCTION_ID_TMP_COL=x.FUNCTION_ID where FUNCTION_ID=x.FUNCTION_ID;
     END LOOP;
      DECLARE
      is_null exception;
      pragma EXCEPTION_INIT (is_null,-01451);
      BEGIN
      execute immediate 'alter table IFF_FUNCTIONS modify(FUNCTION_ID null)';
      EXCEPTION when is_null then null;
      end;
      update IFF_FUNCTIONS set FUNCTION_ID=null;
      execute immediate 'alter table IFF_FUNCTIONS modify FUNCTION_ID varchar(35)';
      FOR x in (select * from IFF_FUNCTIONS) LOOP
       update IFF_FUNCTIONS set FUNCTION_ID=x.FUNCTION_ID_tmp_col where FUNCTION_ID_tmp_col=x.FUNCTION_ID_tmp_col;
      END LOOP;
      execute immediate 'alter table IFF_FUNCTIONS modify(FUNCTION_ID not null)';
      select count(*) into cols_data_dif from IFF_FUNCTIONS where FUNCTION_ID!=FUNCTION_ID_tmp_col;
      if(cols_data_dif=0) then
      execute immediate('alter table IFF_FUNCTIONS drop column FUNCTION_ID_tmp_col');
      end if;
    end;
else
 execute immediate('alter table IFF_FUNCTIONS drop column FUNCTION_ID_tmp_col');
end if;  
end;
end;
/

