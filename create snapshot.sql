DECLARE @dest_path VARCHAR(1000) = 'c:\sql\';
DECLARE @src_db VARCHAR(1000) = 'my_database';
DECLARE @dest_db VARCHAR(1000) = @src_db + '_snapshot';

DECLARE @tab TABLE(id INT IDENTITY(1, 1), txt varchar(2000));

INSERT INTO @tab (txt) VALUES ('use [master];');
INSERT INTO @tab (txt) VALUES ('create database [' + @dest_db + '] on ');

INSERT INTO @tab (txt)
    SELECT 
        '(''name''=''' + mf.name + ''', filename=''' + @dest_path + RIGHT(mf.physical_name, CHARINDEX('\', REVERSE(mf.physical_name)) -1) + '.ss'')'
    FROM sys.master_files mf
    WHERE 
        mf.database_id = DB_ID(@src_db) 
        AND type_desc = 'ROWS';

INSERT INTO @tab (txt) VALUES (' as snapshot of [' + @src_db + '];');

INSERT INTO @tab (txt) VALUES ('use [master];');
INSERT INTO @tab (txt) VALUES ('go');
INSERT INTO @tab (txt) VALUES ('--RESTORE DATABASE [' + @src_db + '] FROM DATABASE_SNAPSHOT = ''' + @dest_db + '''' );
INSERT INTO @tab (txt) VALUES ('--DROP DATABASE [' + @dest_db + '];');

SELECT 
    txt 
FROM @tab
ORDER BY 
    id;
