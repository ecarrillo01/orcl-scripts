UPDATE
  (SELECT 
t1.table_name,
t2.*
  FROM tables t1
  JOIN table_columns t2
  ON t1.table_id = t2.table_id
) t
SET
 t.is_filter = 1,
 referenced_table='ROLES',
 referenced_key_column='ROLE_ID',
 referenced_value_column='ROLE_NAME'
where t.table_name='ROLE_TABLE_COLUMNS' and t.column_name='ROLE_ID';
