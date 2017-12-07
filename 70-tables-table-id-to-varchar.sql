DECLARE
  col_already_exist exception;
  pragma EXCEPTION_INIT (col_already_exist, -01430);
  BEGIN
	execute immediate('ALTER TABLE IFF_TABLES add TABLE_ID_TMP VARCHAR(30)');
  EXCEPTION when col_already_exist then null;
end;
/

begin
declare col_is_varchar number:=0;
begin
select count(*) into col_is_varchar from user_tab_cols where table_name='IFF_TABLES' and column_name='TABLE_ID' and data_type='VARCHAR2';
 if(col_is_varchar=0) then
     iff_sp_drop_foreign_key('IFF_TABLE_COLUMNS','TABLE_ID');
     iff_sp_drop_foreign_key('IFF_ROLE_TABLES','TABLE_ID');
     iff_sp_drop_primary_key('IFF_TABLES');
     execute immediate 'alter table iff_tables modify table_id null';
      for x in (select table_id from iff_tables) LOOP
        declare
        begin
          update iff_tables set table_id_tmp=x.table_id where table_id=x.table_id;
          update iff_tables set table_id=null where table_id=x.table_id;
        end;
      END LOOP;
      execute immediate('alter table iff_tables modify table_id varchar(35)');
      for x in (select table_name from iff_tables) LOOP
        update iff_tables set table_id=x.table_name where table_name=x.table_name;
      END LOOP;
      execute immediate('alter table iff_tables modify table_id not null');
      execute immediate 'alter table iff_tables add constraint iff_tables_pk primary key(table_id)';
    end if;
end;
end;
/