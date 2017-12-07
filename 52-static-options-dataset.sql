declare
    err exception;
    pragma exception_init (err,-00955);
begin
    execute immediate 'create table iff_table_column_dataset(
    dataset_id varchar(35) primary key
    )';
    exception when err then null;
end;
/

declare
    err exception;
    pragma exception_init (err,-00955);
begin
    execute immediate 'create table iff_table_column_dataset_list(
    dataset_id varchar(35) not null,
    option_key varchar(35),
    option_value varchar(50)
    )';
    exception when err then null;
end;
/

declare
    err exception;
    pragma exception_init (err,-02260);
begin
    execute immediate 'alter table iff_table_column_dataset_list add constraint iff_tbl_col_ds_list_pk primary key(dataset_id,option_key)';
    exception when err then null;
end;
/

declare
    err exception;
    pragma exception_init (err,-02275);
begin
    execute immediate 'alter table iff_table_column_dataset_list add constraint iff_tbl_col_ds_list_ds_id_fk foreign key(dataset_id) references iff_table_column_dataset(dataset_id)';
    exception when err then null;
end;
/