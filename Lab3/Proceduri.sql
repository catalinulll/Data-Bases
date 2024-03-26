--teil 1
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE CreateTable
    @table_name VARCHAR(50), @column_name VARCHAR(50)
AS
BEGIN
    DECLARE @SQL VARCHAR(MAX)
    SET @SQL = 'CREATE TABLE ' + @table_name + ' (' + @column_name + ')'
    EXEC (@SQL)
END
GO

EXEC CreateTable 'Exemplu1', 'ID INT PRIMARY KEY, Name VARCHAR(50), Age INT';
EXEC CreateTable 'Exemplu2', 'ID INT PRIMARY KEY, Type VARCHAR(50), Price DECIMAL(10, 2)';

DROP PROCEDURE IF EXISTS RollbackCreateTable;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE RollbackCreateTable
    @table_name VARCHAR(50)
AS
BEGIN
    DECLARE @SQL VARCHAR(MAX);
    SET @SQL = 'DROP TABLE ' + @table_name;
    EXEC(@SQL);
END;


EXEC RollbackCreateTable 'Exemplu1';
EXEC RollbackCreateTable 'Exemplu2';

DROP PROCEDURE IF EXISTS RollbackCreateTable;
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE AddForeignKeyConstraint
    @table_name VARCHAR(50),
    @column_name VARCHAR(50),
    @referenced_table VARCHAR(50),
    @referenced_column VARCHAR(50)
AS
BEGIN
    DECLARE @SQL VARCHAR(MAX);
    SET @SQL = 'ALTER TABLE ' + @table_name + ' ADD CONSTRAINT FK_' + @table_name + '_' + @column_name +
               ' FOREIGN KEY (' + @column_name + ') REFERENCES ' + @referenced_table + '(' + @referenced_column + ')';
    EXEC(@SQL);
END;

EXEC CreateTable 'Auto', 'AutoID INT PRIMARY KEY, AutoName VARCHAR(50)';
EXEC CreateTable 'Geschaft', 'GeschaftID INT PRIMARY KEY, AGE INT, AutoID INT';
EXEC AddForeignKeyConstraint 'Geschaft', 'AutoID', 'Auto', 'AutoID';

DROP PROCEDURE IF EXISTS AddForeignKeyConstraint;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE RollbackAddForeignKeyConstraint
    @table_name VARCHAR(50),
    @column_name VARCHAR(50)

AS
BEGIN
    DECLARE @sql VARCHAR(MAX);
    SET @sql = 'ALTER TABLE ' + @table_name + ' DROP CONSTRAINT FK_' + @table_name + '_' + @column_name;
    EXEC (@sql);
END

EXEC RollbackAddForeignKeyConstraint 'Geschaft', 'AutoID';
EXEC RollbackCreateTable 'Auto';
EXEC RollbackCreateTable 'Geschaft';

DROP PROCEDURE IF EXISTS RollbackAddForeignKeyConstraint;
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE AddColumnToTable
    @table_name VARCHAR(50),
    @column_name VARCHAR(50),
    @column_type VARCHAR(50)
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX);
    SET @SQL = 'ALTER TABLE ' + @table_name + ' ADD ' + @column_name + ' ' + @column_type;
    EXEC(@SQL);
END;

EXEC CreateTable 'Auto', 'AutoID INT PRIMARY KEY, Typ VARCHAR(50)';
EXEC AddColumnToTable 'Auto', 'Kilometeranzahl', 'INT';

DROP PROCEDURE IF EXISTS AddColumnToTable;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE RollbackAddColumnToTable
    @table_name VARCHAR(50), @column_name VARCHAR(50)
AS
BEGIN
    DECLARE @SQL VARCHAR(MAX)
    SET @SQL = 'ALTER TABLE ' + @table_name + ' DROP COLUMN ' + @column_name
    EXEC (@SQL)
END

EXEC RollbackAddColumnToTable 'Auto', 'Kilometeranzahl';
EXEC RollbackCreateTable 'Auto';

DROP PROCEDURE IF EXISTS RollbackAddColumnToTable;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE AddDefaultConstraint
    @table_name VARCHAR(50),
    @column_name VARCHAR(50),
    @default_value VARCHAR(50)
AS
BEGIN
    DECLARE @SQL VARCHAR(MAX);
    SET @SQL = 'ALTER TABLE ' + @table_name + ' ADD CONSTRAINT DF_' + @table_name + '_' + @column_name + ' DEFAULT ' + @default_value + ' FOR ' + @column_name;
    EXEC(@SQL);
END;

EXEC CreateTable 'Autoo', 'AutoID INT PRIMARY KEY, Typ VARCHAR(50)';
EXEC AddColumnToTable 'Autoo', 'Kilometeranzahl', 'INT';
EXEC AddDefaultConstraint 'Autoo', 'Kilometeranzahl', '100000';
EXEC AddDefaultConstraint 'Autoo', 'Typ', '''Subaru''';
INSERT INTO Autoo (AutoID) VALUES (1);

DROP PROCEDURE IF EXISTS AddDefaultConstraint;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE RollbackAddDefaultConstraint
    @table_name VARCHAR(50), @column_name VARCHAR(50)
AS
BEGIN
    DECLARE @SQL VARCHAR(MAX);
    SET @SQL = 'ALTER TABLE ' + @table_name + ' DROP CONSTRAINT DF_' + @table_name + '_' + @column_name;
    EXEC(@SQL);
END;

EXEC RollbackAddDefaultConstraint 'Autoo', 'Kilometeranzahl';
EXEC RollbackAddDefaultConstraint 'Autoo', 'Typ';
EXEC RollbackAddColumnToTable 'Autoo', 'Kilometeranzahl';
EXEC RollbackCreateTable 'Autoo';

DROP PROCEDURE IF EXISTS RollbackAddDefaultConstraint;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE ModifyColumnType
    @table_name VARCHAR(50),
    @column_name VARCHAR(50),
    @new_data_type VARCHAR(50)
AS
BEGIN
    DECLARE @SQL VARCHAR(MAX);
    SET @SQL = 'ALTER TABLE ' + @table_name + ' ALTER COLUMN ' + @column_name + ' ' + @new_data_type;
    EXEC(@SQL);
END;

EXEC CreateTable 'Auto', 'AutoID INT PRIMARY KEY, Typ VARCHAR(50)';
EXEC AddColumnToTable 'Auto', 'Kilometeranzahl', 'INT';
EXEC ModifyColumnType 'Auto', 'Kilometeranzahl', 'VARCHAR(50)';

DROP PROCEDURE IF EXISTS ModifyColumnType;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------

















