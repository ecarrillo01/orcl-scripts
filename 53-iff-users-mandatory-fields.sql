                       -- IFF_USERS mandatory fields ---

--PASSWORD

declare
    err exception;
    pragma exception_init (err,-01442);
begin
    execute immediate 'ALTER TABLE IFF_USERS MODIFY(PASSWORD NOT NULL)';
    exception when err then null;
end;
/

--NAME

declare
    err exception;
    pragma exception_init (err,-01442);
begin
    execute immediate 'ALTER TABLE IFF_USERS MODIFY(NAME NOT NULL)';
    exception when err then null;
end;
/

--PASSWORD_ALGORITHM_VERSION

declare
    err exception;
    pragma exception_init (err,-01442);
begin
    execute immediate 'ALTER TABLE IFF_USERS MODIFY(PASSWORD_ALGORITHM_VERSION default ''v2'')';
    execute immediate 'ALTER TABLE IFF_USERS MODIFY(PASSWORD_ALGORITHM_VERSION NOT NULL)';
    exception when err then null;
end;
/

-- ACCOUNT_STATUS

declare
    err exception;
    pragma exception_init (err,-01442);
begin
    execute immediate 'ALTER TABLE IFF_USERS MODIFY(ACCOUNT_STATUS NOT NULL)';
    exception when err then null;
end;
/


