CREATE TABLE LogTable (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    ExecutionDateTime DATETIME,
    StatementType CHAR(1), -- 'I' pentru INSERT, 'U' pentru UPDATE, 'D' pentru DELETE
    TableName NVARCHAR(255),
    AffectedRows INT
);

+

CREATE OR ALTER TRIGGER tr_LogChanges
ON Mitarbeiter 
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @StatementType CHAR(1);
    DECLARE @AffectedRows INT;

    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        IF EXISTS (SELECT * FROM deleted)
        BEGIN
            SET @StatementType = 'U';
        END
        ELSE
        BEGIN
            SET @StatementType = 'I';
        END

        SET @AffectedRows = (SELECT COUNT(*) FROM inserted);
    END
    ELSE IF EXISTS (SELECT * FROM deleted)
    BEGIN
        SET @StatementType = 'D';
        SET @AffectedRows = (SELECT COUNT(*) FROM deleted);
    END

    INSERT INTO LogTable (ExecutionDateTime, StatementType, TableName, AffectedRows)
	VALUES (GETDATE(), @StatementType, 'Mitarbeiter', @AffectedRows);
END;






SELECT * FROM LogTable;
SELECT  * FROM Mitarbeiter;


INSERT INTO Mitarbeiter (Mitarbeiter_ID, Name,  Adresse, Rolle, Datum_der_Einstellung, Telefonnummer, Geschäft_ID)
VALUES (24, 'Costica', 'Strada Tare', 'Curier', GETDATE(), '0742167181', 1);

INSERT INTO Mitarbeiter (Mitarbeiter_ID, Name,  Adresse, Rolle, Datum_der_Einstellung, Telefonnummer, Geschäft_ID)
VALUES (25, 'Gica', 'Strada Slaba', 'Senator', GETDATE(), '0742167183', 3),
		(26, 'Mitica', 'Strada Tareeee', 'Profesor', GETDATE(), '0742167182', 2);




UPDATE Mitarbeiter
SET Name = 'Costica-Updated'
WHERE Mitarbeiter_ID = 25 OR Mitarbeiter_ID = 29;



DELETE FROM Mitarbeiter
WHERE Mitarbeiter_ID = 25;

