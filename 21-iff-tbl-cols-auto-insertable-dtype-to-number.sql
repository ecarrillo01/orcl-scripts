begin
DECLARE
  col_already_exist exception;
  pragma EXCEPTION_INIT (col_already_exist, -01430);
  BEGIN
	execute immediate('ALTER TABLE IFF_TABLE_COLUMNS ADD IFF_TBL_COLS_AUTO_INSTBL_TMP NUMBER DEFAULT 0 NOT NULL');
  EXCEPTION when col_already_exist then null;
end;
end;
/

begin
declare col_is_number number:=0;
begin
select count(*) into col_is_number from user_tab_cols where table_name='IFF_TABLE_COLUMNS' and column_name='AUTO_INSERTABLE' and data_type='NUMBER';
 if(col_is_number=0) then
    update iff_table_columns set auto_insertable='0' where auto_insertable is null;
      for x in (select table_id,column_id,auto_insertable from iff_table_columns) LOOP
        declare
        is_nan exception;
        pragma exception_init (is_nan,-01722);
        begin
          update iff_table_columns set IFF_TBL_COLS_AUTO_INSTBL_TMP=to_number(x.auto_insertable) where table_id=x.table_id and column_id=x.column_id;
        exception when is_nan then null;
        end;
      END LOOP;
      update iff_table_columns set auto_insertable=null;
      execute immediate('alter table iff_table_columns modify auto_insertable number');
      for x in (select table_id,column_id,IFF_TBL_COLS_AUTO_INSTBL_TMP from iff_table_columns) LOOP
        update iff_table_columns set auto_insertable=x.IFF_TBL_COLS_AUTO_INSTBL_TMP where table_id=x.table_id and column_id=x.column_id;
      END LOOP;
      execute immediate('alter table iff_table_columns modify auto_insertable not null');
    end if;
end;
end;
/

alter table iff_table_columns drop column IFF_TBL_COLS_AUTO_INSTBL_TMP;
