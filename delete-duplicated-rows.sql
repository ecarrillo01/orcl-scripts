--------------------------------------------------------
--  Delete duplicated rows from specific table
--------------------------------------------------------
delete   FROM
   MY_TABLE t1
WHERE
t1.rowid >
ANY (
 SELECT
    t2.rowid
 FROM
      MY_TABLE t2
 WHERE
    t1.MY_COLUMN = t2.MY_COLUMN
); 