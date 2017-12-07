create table iff_session(
session_id number,
username varchar(50),
iff_version varchar(35),
source_ip varchar(40),
session_started_at timestamp,
session_ended_at timestamp
);

alter table iff_session add constraint iff_session_pk primary key(session_id);
alter table iff_session add constraint iff_session_username_fk foreign key(username) references iff_users(username);
alter table iff_session add constraint iff_session_iff_version_fk foreign key(iff_version) references iff_version(version_id);
alter table iff_session modify(session_started_at default current_timestamp);

create table iff_session_activity(
session_id number,
activity_timestamp timestamp,
activity_url varchar(80)
);

alter table iff_session_activity add constraint iff_s_actvy_pk primary key(session_id,activity_timestamp,activity_url);
alter table iff_session_activity add constraint iff_s_activity_sid_fk foreign key(session_id) references iff_session(session_id);

declare
    err exception;
    pragma exception_init (err,-00955);
begin
    execute immediate 'CREATE SEQUENCE "IFF_SESSION_SEQ" START WITH 1 INCREMENT BY 1 NOMAXVALUE';
    exception when err then null;
end;
/


create or replace TRIGGER IFF_TGR_SESSION_BI
before insert on IFF_SESSION
for each row
begin
    select IFF_SESSION_SEQ.nextval into :new.session_id from dual;
    select param_value into :new.session_max_minutes from iff_params where param_key='session-max-minutes'; 
    exception when NO_DATA_FOUND then
    select 5 into :new.session_max_minutes from dual;
end;
/

declare
    err exception;
    pragma exception_init (err,-01430);
begin
    execute immediate 'alter table iff_session add(session_max_minutes number)';
    exception when err then null;
end;
/

declare
    err exception;
    pragma exception_init (err,-02264);
begin
    execute immediate 'alter table iff_session add constraint iff_session_ck1 check (session_ended_at > session_started_at)';
    exception when err then null;
end;
/
