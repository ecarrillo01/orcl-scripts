alter table iff_lang rename column lang to lang_id;
alter table iff_lang add(lang_description varchar(35));
update iff_table_columns set referenced_key_column='LANG_ID',referenced_value_column='LANG_DESCRIPTION' where referenced_table='IFF_LANG';
exec iff_sp_delete_table_column('IFF_LANG','LANG');