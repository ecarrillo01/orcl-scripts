SELECT
a.table_name src_table,
a.column_name src_column, 
c_pk.table_name dest_table
,c_pk.column_name dest_column
  FROM all_cons_columns a
  JOIN all_constraints c ON a.owner = c.owner
                        AND a.constraint_name = c.constraint_name
  JOIN all_cons_columns c_pk ON c.r_owner = c_pk.owner
                           AND c.r_constraint_name = c_pk.constraint_name
 WHERE c.constraint_type = 'R'
 and c.r_owner=(select user from dual)
 GROUP BY
a.table_name,
a.column_name, 
c_pk.table_name
,c_pk.column_name;