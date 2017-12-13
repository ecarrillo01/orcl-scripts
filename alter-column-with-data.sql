DECLARE
  col_already_exist exception;
  pragma EXCEPTION_INIT (col_already_exist, -01430);
  BEGIN
	execute immediate('ALTER TABLE menu_item_group add position_tmp_col number default 0');
  EXCEPTION when col_already_exist then null;
end;
/
begin
declare position_is_number char(1):=0;
FUNCTION is_number (p_string IN VARCHAR2)
   RETURN INT
IS
   v_new_num NUMBER;
BEGIN
   v_new_num := TO_NUMBER(p_string);
   RETURN 1;
EXCEPTION
WHEN VALUE_ERROR THEN
   RETURN 0;
END is_number;
begin
select count(*) into position_is_number from user_tab_cols where table_name='MENU_ITEM_GROUP' AND COLUMN_NAME='POSITION' AND DATA_TYPE!='NUMBER';
if(position_is_number>0) then
	begin
		for x in (select GROUP_ID,POSITION from MENU_ITEM_GROUP where POSITION IS NOT NULL) LOOP
		if(is_number(x.POSITION)>0) then
			update menu_item_group set position_tmp_col=x.POSITION where group_id=x.group_id;
		end if;
	  END LOOP;
	  update menu_item_group set position=null;
	  execute immediate('alter table menu_item_group modify position number default 0');
		for x in (select group_id,position_tmp_col from menu_item_group where position_tmp_col IS NOT NULL) LOOP
				update menu_item_group set position=x.position_tmp_col where group_id=x.group_id;
	  END LOOP;
	  end;
end if;
end;
end;
/

alter table menu_item_group drop column position_tmp_col;
