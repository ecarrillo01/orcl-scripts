-- Table columns

DECLARE
  col_already_exist exception;
  pragma EXCEPTION_INIT (col_already_exist, -01430);
  BEGIN
	execute immediate('ALTER TABLE IFF_TABLE_COLUMNS add TABLE_ID_TMP VARCHAR(30)');
  EXCEPTION when col_already_exist then null;
end;
/

begin
declare col_is_varchar number:=0;
nullable_err exception;
non_existence_constraint exception;
pragma EXCEPTION_INIT (nullable_err,-01451);
pragma EXCEPTION_INIT (non_existence_constraint,-02443);
begin
select count(*) into col_is_varchar from user_tab_cols where table_name='IFF_TABLE_COLUMNS' and column_name='TABLE_ID' and data_type='VARCHAR2';
 if(col_is_varchar=0) then
     iff_sp_drop_foreign_key('IFF_TBL_COL_TRANSLATION','TABLE_ID');
     iff_sp_drop_foreign_key('IFF_ROLE_TABLE_COLUMNS','TABLE_ID');
     iff_sp_drop_primary_key('IFF_TABLE_COLUMNS');  
    --- execute immediate 'drop index IFF_TABLE_COLUMNS_UK1';
     begin
       execute immediate 'alter table iff_table_columns modify table_id null';
       execute immediate 'alter table iff_table_columns drop constraint IFF_TABLE_COLUMNS_UK1';
       exception when nullable_err then null;
       when non_existence_constraint then null;
     end;
      for x in (select table_id,table_id_tmp from iff_tables) LOOP
        declare
        begin
          update iff_table_columns set table_id_tmp=x.table_id where table_id=x.table_id_tmp;
          update iff_table_columns set table_id=null where table_id=x.table_id_tmp;
        end;
      END LOOP;
      execute immediate 'alter table iff_table_columns modify table_id varchar(35)';
      update (select * from iff_table_columns) t set table_id=table_id_tmp;
      execute immediate('alter table iff_table_columns modify table_id not null');
      execute immediate 'alter table iff_table_columns add constraint iff_table_columns_pk primary key(table_id,column_id)';
      execute immediate 'alter table iff_table_columns drop column table_id_tmp';
    end if;
end;
end;
/
