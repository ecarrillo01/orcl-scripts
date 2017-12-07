update iff_table_columns set display_value=column_name where display_value is null;
DECLARE
  is_already_not_null exception;
  pragma EXCEPTION_INIT (is_already_not_null,-01442);
  BEGIN
	execute immediate('alter table iff_table_columns modify display_value not null');
  EXCEPTION when is_already_not_null then null;
end;
/