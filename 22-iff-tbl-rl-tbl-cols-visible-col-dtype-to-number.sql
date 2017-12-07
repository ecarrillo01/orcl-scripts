begin
DECLARE
  col_already_exist exception;
  pragma EXCEPTION_INIT (col_already_exist, -01430);
  BEGIN
	execute immediate('ALTER TABLE IFF_ROLE_TABLE_COLUMNS ADD IFF_RLTBL_COLS_TMP1 NUMBER DEFAULT 0 NOT NULL');
  EXCEPTION when col_already_exist then null;
end;
end;
/

begin
declare col_is_number number:=0;
begin
select count(*) into col_is_number from user_tab_cols where table_name='IFF_ROLE_TABLE_COLUMNS' and column_name='VISIBLE' and data_type='NUMBER';
 if(col_is_number=0) then
    update iff_ROLE_TABLE_COLUMNS set VISIBLE='0' where VISIBLE is null;
      for x in (select role_id,table_id,column_id,VISIBLE from iff_ROLE_TABLE_COLUMNS) LOOP
        declare
        is_nan exception;
        pragma exception_init (is_nan,-01722);
        begin
          update iff_ROLE_TABLE_COLUMNS set IFF_RLTBL_COLS_TMP1=to_number(x.VISIBLE) where table_id=x.table_id and column_id=x.column_id and role_id=x.role_id;
        exception when is_nan then null;
        end;
      END LOOP;
      update iff_ROLE_TABLE_COLUMNS set VISIBLE=null;
      execute immediate('alter table iff_ROLE_TABLE_COLUMNS modify VISIBLE number');
      for x in (select role_id,table_id,column_id,IFF_RLTBL_COLS_TMP1 from IFF_ROLE_TABLE_COLUMNS) LOOP
        update iff_ROLE_TABLE_COLUMNS set VISIBLE=x.IFF_RLTBL_COLS_TMP1 where table_id=x.table_id and column_id=x.column_id and role_id=x.role_id;
      END LOOP;
      execute immediate('alter table iff_ROLE_TABLE_COLUMNS modify VISIBLE default 1 not null');
    end if;
end;
end;
/

alter table iff_ROLE_TABLE_COLUMNS drop column IFF_RLTBL_COLS_TMP1;
