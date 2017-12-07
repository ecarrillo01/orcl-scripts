begin
DELETE FROM
   iff_version_changes A
WHERE
  a.rowid >
   ANY (
     SELECT
        B.rowid
     FROM
        iff_version_changes B
     WHERE
        A.version_id = B.version_id
     AND
        A.change_type_id = B.change_type_id
        AND A.change_description=B.change_description
); 
declare
    err exception;
    pragma exception_init (err,-02261);
begin
    execute immediate 'alter table iff_version_changes add constraint iff_v_changes_v_ctype_cdesc_uk unique(version_id,change_type_id,change_description)';
    exception when err then null;
end;
end;
/
