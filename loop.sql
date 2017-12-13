
declare
    err exception;
    pragma exception_init (err,-00001);
     admin_role_id number:=0;
begin
    select role_id into admin_role_id from roles where ROLE_NAME='ADMIN';
    for x in(select t1.table_id,t1.table_name,t2.role_id from tables t1 
    left join(
    select t2.* from roles t1 join role_tables t2 on t1.role_id=t2.role_id and t1.role_name='ADMIN'
    ) t2 on t1.table_id=t2.table_id
    where t2.table_id is null) loop
      insert into role_tables(role_id,table_id) values(admin_role_id,x.table_id);
    end loop;
    exception when err then null;
end;
/
