DECLARE
  v_doesnt_exists exception;
  pragma EXCEPTION_INIT (v_doesnt_exists,-00942);
  BEGIN
	execute immediate('drop view IFF_V_APP_TABLE_SEARCH_FORM');
  EXCEPTION when v_doesnt_exists then null;
end;
/