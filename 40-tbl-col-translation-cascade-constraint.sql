SET SERVEROUTPUT ON;
begin
declare is_cascade_constraint number:=0;
  begin
    select count(*) into  is_cascade_constraint from user_constraints where delete_rule='CASCADE' and constraint_name='IFF_TBL_COL_TRANSLATION_FK1';
    if(is_cascade_constraint=0) then
      Dbms_Output.Put_Line('going to drop table'); 
      declare
      err exception;
      pragma exception_init (err,-00942);
      begin
          execute immediate 'drop table IFF_TBL_COL_TRANSLATION';
          exception when err then null;
      end;
      declare
      err exception;
      pragma exception_init (err,-00955);
      begin
          execute immediate 'CREATE TABLE IFF_TBL_COL_TRANSLATION(TABLE_ID NUMBER,COLUMN_ID NUMBER,LANG_ID VARCHAR2(10 BYTE) NOT NULL,VALUE VARCHAR2(40 BYTE))';
          exception when err then null;
      end;
      execute immediate 'ALTER TABLE IFF_TBL_COL_TRANSLATION ADD CONSTRAINT IFF_TBL_COL_TRANSLATION_PK PRIMARY KEY(TABLE_ID,COLUMN_ID,LANG_ID)'; 
      execute immediate 'ALTER TABLE IFF_TBL_COL_TRANSLATION ADD CONSTRAINT IFF_TBL_COL_TRANSLATION_FK2 FOREIGN KEY(LANG_ID) REFERENCES IFF_LANG(LANG)';
      execute immediate 'alter table IFF_TBL_COL_TRANSLATION add constraint IFF_TBL_COL_TRANSLATION_FK1 foreign key(table_id,column_id) references iff_table_columns(table_id,column_id) on delete cascade';
    end if;
  end;
end;
/