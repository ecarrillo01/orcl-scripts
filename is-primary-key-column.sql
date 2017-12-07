-- Procedure that checks if column is primary key

CREATE OR REPLACE PROCEDURE "SP_IS_PRIMARY_KEY_COLUMN" (table_name_in in varchar2,column_name_in in varchar2,is_primary_key out number)
AS
BEGIN
  select count(*) into is_primary_key from(
  SELECT
  cols.table_name,
  cols.column_name
  FROM all_constraints cons
  join all_cons_columns cols on cons.constraint_name = cols.constraint_name AND cons.owner = cols.owner and cons.constraint_type = 'P'
  join user_tables on user_tables.table_name=cols.table_name
  where cols.column_name=column_name_in and cols.table_name=table_name_in
  and cons.owner=(select user from dual)
  GROUP BY cols.table_name,cols.column_name);
END;
/