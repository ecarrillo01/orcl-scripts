declare
    err exception;
    pragma exception_init (err,-00904);
begin
    execute immediate 'alter table iff_users drop column lang';
    exception when err then null;
end;
/
exec iff_sp_delete_table_column('IFF_USERS','LANG');

declare
    err1 exception;
    pragma exception_init (err1,-01430);
begin
    execute immediate('alter table iff_users add(lang_id varchar(10) default ''es'' not null)');
    exception when err1 then null;
end;
/
declare
    err2 exception;
    pragma exception_init (err2,-00001);
begin
    insert into iff_lang(lang_id) values('es');
    exception when err2 then null;
end;
/
declare
    err3 exception;
    pragma exception_init (err3,-02275);
begin
    execute immediate('alter table iff_users add constraint iff_users_lang_fk foreign key(lang_id) references iff_lang(lang_id)');
    exception when err3 then null;
end;
/