-- Allow only 0 an 1 into a column
declare
    err exception;
    pragma exception_init (err,-02264);
begin
    execute immediate 'ALTER TABLE MY_TABLE ADD CONSTRAINT "MY_TABLE_CK1" CHECK (MY_COLUMN in(0,1))';
    exception when err then null;
end;
/ 