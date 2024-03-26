CREATE OR ALTER FUNCTION dbo.ValidateMitarbeiterID
(
    @Mitarbeiter_ID INT
)
RETURNS BIT
AS
BEGIN
    DECLARE @isValid BIT = 0
    
    IF @Mitarbeiter_ID > 0
        SET @isValid = 1

    RETURN @isValid
END
GO

CREATE OR ALTER FUNCTION dbo.ValidateName
(
    @Name VARCHAR(100)
)
RETURNS BIT
AS
BEGIN
    DECLARE @isValid BIT = 0
    
    IF LEN(@Name) > 0
        SET @isValid = 1

    RETURN @isValid
END
GO

CREATE OR ALTER PROCEDURE InsertIntoMitarbeiter
    @Mitarbeiter_ID INT,
    @Name VARCHAR(100),
    @Adresse VARCHAR(200),
    @Rolle VARCHAR(50),
    @Datum_Der_Einstellung DATE,
    @Telefonnummer VARCHAR(20),
    @Geschaft_ID INT
AS
BEGIN
    IF dbo.ValidateMitarbeiterID(@Mitarbeiter_ID) = 0
    BEGIN
        PRINT 'Mitarbeiter_ID nu este valid!'
        RETURN
    END

    IF dbo.ValidateName(@Name) = 0
    BEGIN
        PRINT 'Numele nu este valid!'
        RETURN
    END

    INSERT INTO Mitarbeiter (Mitarbeiter_ID, Name, Adresse, Rolle, Datum_Der_Einstellung, Telefonnummer, Geschäft_ID)
    VALUES (@Mitarbeiter_ID, @Name, @Adresse, @Rolle, @Datum_Der_Einstellung, @Telefonnummer, @Geschaft_ID)

    PRINT 'Datele au fost inserate cu succes in tabelul Mitarbeiter!'
END
GO


SELECT 
*
FROM Mitarbeiter m

EXEC InsertIntoMitarbeiter @Mitarbeiter_ID = 18, @Name = 'Alex Ionut', @Adresse = 'Strada Mihaita', @Rolle = 'Inginer', @Datum_Der_Einstellung = '2023-11-01', @Telefonnummer = '0766306121', @Geschaft_ID = 1;
