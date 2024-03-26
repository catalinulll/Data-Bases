--teil 2
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE CreateTableVersioned
 @table_name VARCHAR(50), @column_name VARCHAR(50)

AS 
BEGIN
DECLARE @version AS INT
SET @version= (SELECT current_version FROM Version)+1
INSERT INTO Versionen(VersionNummer ,Prozedur, Parameter1,Parameter2) 
VALUES (@version, 'CreateTableVersioned',  @table_name, @column_name)


UPDATE Version
SET current_version=current_version+1
print('CREATE TABLE ' + @table_name + ' (' + @column_name + ')')
DECLARE @query AS VARCHAR(MAX) ='CREATE TABLE ' + @table_name + ' (' + @column_name + ')'
EXEC(@query)
END
GO
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE AddForeignKeyConstraintVersioned
    @table_name VARCHAR(50), @column_name VARCHAR(50), @referenced_table VARCHAR(50), @referenced_column VARCHAR(50)
AS
BEGIN
DECLARE @version AS INT
SET @version= (SELECT current_version FROM Version)+1
INSERT INTO Versionen(VersionNummer, Prozedur, Parameter1, Parameter2, Parameter3, Parameter4) VALUES (@version, 'AddForeignKeyConstraintVersioned', @table_name , @column_name , @referenced_table , @referenced_column )

UPDATE Version
SET current_version=current_version+1
DECLARE @query AS VARCHAR(MAX) = 'ALTER TABLE ' + @table_name + ' ADD CONSTRAINT FK_' + @table_name + '_' + @column_name +
               ' FOREIGN KEY (' + @column_name + ') REFERENCES ' + @referenced_table + '(' + @referenced_column + ')';

PRINT(@query)
EXEC(@query)
END
GO
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE AddColumnToTableVersioned
	@table_name VARCHAR(50), @column_name VARCHAR(50), @column_type VARCHAR(50)
AS
BEGIN
DECLARE @version AS INT
SET @version= (SELECT current_version FROM Version)+1
INSERT INTO Versionen(VersionNummer, Prozedur, Parameter1, Parameter2, Parameter3) VALUES (@version, 'AddColumnToTableVersioned', @table_name, @column_name, @column_type)

UPDATE Version
SET current_version=current_version+1
DECLARE @query AS VARCHAR(MAX) = 'ALTER TABLE ' + @table_name + ' ADD ' + @column_name + ' ' + @column_type;
EXEC(@query)
END
GO
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE AddDefaultConstraintVersioned
	@table_name VARCHAR(50), @column_name VARCHAR(50), @default_value VARCHAR(50)
AS
BEGIN
DECLARE @version AS INT
SET @version= (SELECT current_version FROM Version)+1
INSERT INTO Versionen(VersionNummer, Prozedur, Parameter1, Parameter2, Parameter3) VALUES (@version, 'AddDefaultConstraintVersioned', @table_name, @column_name, @default_value)

UPDATE Version
SET current_version=current_version+1
DECLARE @checkedDefaultValue varchar(100)
IF ISNUMERIC(@default_value) = 1
SET @checkedDefaultValue = @default_value
ELSE
SET @checkedDefaultValue = '''' + @default_value + ''''
DECLARE @query AS VARCHAR(MAX) =  'ALTER TABLE ' + @table_name + ' ADD CONSTRAINT DF_' + @table_name + '_' + @column_name + ' DEFAULT ' + @default_value + ' FOR ' + @column_name;
EXEC(@query)
END
GO
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE ModifyColumnTypeVersioned
    @table_name VARCHAR(50),
    @column_name VARCHAR(50),
    @new_data_type VARCHAR(50)AS
BEGIN
DECLARE @version AS int
SET @version= (SELECT current_version FROM Version)+1

DECLARE @size AS int
SET @size = (SELECT CHARACTER_MAXIMUM_LENGTH FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME=@table_name AND COLUMN_NAME=@column_name)
DECLARE @initialType AS VARCHAR(MAX)
SET @initialType= (SELECT DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME=@table_name AND COLUMN_NAME=@column_name)

if @size is not null
begin
SET @initialType= @initialType + '(' + cast(@size as varchar(max)) + ')' 
end
INSERT INTO Versionen(VersionNummer, Prozedur, Parameter1, Parameter2, Parameter3, Parameter4) VALUES (@version, 'modifyColumnType', @table_name, @column_name, @new_data_type, @initialType)

UPDATE Version
SET current_version=current_version+1
DECLARE @query AS VARCHAR(MAX) = 'alter table ' + @table_name + ' ' + 'alter column ' + @column_name + ' ' + @new_data_type
EXEC(@query)
END
GO
--------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR ALTER PROCEDURE RollbackModifyColumnType
    @table_name  VARCHAR(50),
    @column_name VARCHAR(50),
    @old_data_type VARCHAR(50)
AS
BEGIN
    DECLARE @query AS VARCHAR(MAX) = 'ALTER TABLE ' + @table_name  + ' ' + 'ALTER COLUMN ' + @column_name + ' ' + @old_data_type
    EXEC(@query)
END;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Version (
    current_version INT
);


INSERT INTO Version (current_version) VALUES (1);



CREATE TABLE Versionen (
    VersionNummer INT,
    Prozedur NVARCHAR(MAX),
    Parameter1 VARCHAR(MAX),
    Parameter2 VARCHAR(MAX),
    Parameter3 VARCHAR(MAX),
    Parameter4 VARCHAR(MAX)  
);


CREATE OR ALTER PROCEDURE GoToVersion(@changed_version int)
AS
BEGIN
DECLARE @current_version AS INT

	DECLARE @procedureName AS VARCHAR(MAX),
			@table_name AS VARCHAR(MAX),
			@column_name AS VARCHAR(MAX),
			@Parameter1 AS VARCHAR(MAX),
			@Parameter2 AS VARCHAR(MAX),
			@Parameter3 AS VARCHAR(MAX),
			@Parameter4 AS VARCHAR(MAX),
			@new_data_type AS VARCHAR(MAX)
			

SET @current_version = (SELECT current_version FROM Version)
IF (@current_version>@changed_version)
	BEGIN
		WHILE @current_version != @changed_version
			BEGIN
				SELECT @procedureName = v.Prozedur, @table_name = v.Parameter1, @column_name = v.Parameter2,@Parameter3 = v.Parameter3, @Parameter4=v.Parameter4
 FROM Versionen v 
 WHERE VersionNummer = @current_version 
				PRINT(@procedureName)
 				DECLARE @constraint AS VARCHAR(MAX)

				IF (@procedureName='CreateTableVersioned')
					EXEC RollbackCreateTable @table_name
				IF (@procedureName = 'ModifyColumnTypeVersioned')
					EXEC ModifyColumnType @table_name, @column_name, @new_data_type

				IF (@procedureName = 'AddForeignKeyConstraintVersioned')
					BEGIN
					SET @constraint = 'fk_' + @table_name + '_' + @column_name
					EXEC RollbackAddForeignKeyConstraint @table_name, @column_name
					END

				IF (@procedureName='AddColumnToTableVersioned')
					EXEC RollbackAddColumnToTable @table_name, @column_name
				IF (@procedureName='AddDefaultConstraintVersioned')
					BEGIN
					SET @constraint = 'df_'+ @column_name
					EXEC RollbackAddDefaultConstraint @table_name, @column_name
					END
				IF (@procedureName = 'ModifyColumnTypeVersioned')
                SELECT @Parameter4 = v.Parameter4
                FROM Versionen v
                WHERE VersionNummer = @current_version;

                EXEC RollbackModifyColumnType @table_name, @column_name, @Parameter4;
				SET @current_version=@current_version-1
				UPDATE Version SET current_version= @current_version
			END
			UPDATE Version SET current_version= @changed_version
		END
ELSE
        BEGIN
		SET @current_version = @current_version + 1
		while(@current_version < @changed_version + 1)
            BEGIN
                SELECT @procedureName = v.Prozedur, @table_name = v.Parameter1, @column_name = v.Parameter2,@Parameter3 = v.Parameter3, @Parameter4=v.Parameter4
				FROM Versionen v 
			    WHERE v.VersionNummer = @current_version 

				IF (@procedureName='CreateTableVersioned')
					EXEC CreateTable @table_name, @column_name
				IF (@procedureName='AddForeignKeyConstraintVersioned')
					EXEC AddForeignKeyConstraint @table_name, @column_name, @Parameter3, @Parameter4 
				IF (@procedureName='AddColumnToTableVersioned')
					EXEC AddColumnToTable @table_name, @column_name, @Parameter3
				IF (@procedureName='AddDefaultConstraintVersioned')
					EXEC AddDefaultConstraint @table_name, @column_name, @Parameter3
				IF (@procedureName='ModifyColumnTypeVersioned')
					EXEC ModifyColumnType @table_name, @column_name , @Parameter3
				SET @current_version = @current_version + 1;
				UPDATE Version SET current_version= @current_version
            END
			UPDATE Version SET current_version= @changed_version
        END
		
END
GO



DELETE FROM Versionen
GO

SELECT * FROM Versionen
SELECT * FROM VERSION

EXEC CreateTableVersioned @table_name = 'T1' , @column_name = 'column1 INT PRIMARY KEY'
GO

SELECT * FROM Versionen
SELECT * FROM VERSION

EXEC AddColumnToTableVersioned @table_name='T1' , @column_name='column2', @column_type='VARCHAR(50)'
GO

SELECT * FROM Versionen
SELECT * FROM VERSION

EXEC AddColumnToTableVersioned @table_name='T1' , @column_name='column3', @column_type='INT'
GO

SELECT * FROM Versionen
SELECT * FROM VERSION

EXEC ModifyColumnTypeVersioned @table_name='T1', @column_name='column2', @new_data_type='CHAR(20)'
GO

SELECT * FROM Versionen
SELECT * FROM VERSION

EXEC AddDefaultConstraintVersioned @table_name='T1', @column_name='column2', @default_value='''c'''
GO

SELECT * FROM Versionen
SELECT * FROM VERSION

EXEC AddDefaultConstraintVersioned @table_name='T1', @column_name='column3', @default_value='0'
GO

SELECT * FROM Versionen
SELECT * FROM VERSION

EXEC CreateTableVersioned @table_name = 'T2' , @column_name = 'column4 INT PRIMARY KEY'
GO

SELECT * FROM Versionen
SELECT * FROM VERSION

EXEC AddColumnToTableVersioned @table_name='T2' , @column_name='column1', @column_type='INT'
GO

SELECT * FROM Versionen
SELECT * FROM VERSION


EXEC AddForeignKeyConstraintVersioned @table_name= 'T2', @column_name= 'column1', @referenced_table= 'T1', @referenced_column= 'column1'
GO

SELECT * FROM Versionen
SELECT * FROM VERSION


EXEC GoToVersion @changed_version=2
GO

SELECT * FROM VERSION

EXEC GoToVersion @changed_version=9
GO

SELECT * FROM VERSION

EXEC GoToVersion @changed_version=8
GO

SELECT * FROM VERSION


ALTER TABLE T2
DROP CONSTRAINT FK_T2_column1;

DROP TABLE T1
GO

DROP TABLE T2
GO

DELETE FROM Versionen
GO

SELECT * FROM Versionen
SELECT * FROM VERSION

UPDATE Version
SET current_version=0;