CREATE OR ALTER PROCEDURE UpdateMitarbeiter
AS
BEGIN
    DECLARE @Mitarbeiter_ID INT;
    DECLARE @Name NVARCHAR(100);
    DECLARE @Telefonnummer NVARCHAR(20);
    DECLARE @Geschäft_ID INT;

    DECLARE mitarbeiter_cursor CURSOR FOR
    SELECT Mitarbeiter_ID, Name, Telefonnummer, Geschäft_ID
    FROM Mitarbeiter;

    OPEN mitarbeiter_cursor;
    FETCH NEXT FROM mitarbeiter_cursor INTO @Mitarbeiter_ID, @Name, @Telefonnummer, @Geschäft_ID;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF LEN(@Telefonnummer) = 9 AND @Telefonnummer NOT LIKE '0%'
        BEGIN
            UPDATE Mitarbeiter
            SET Telefonnummer = '0' + @Telefonnummer 
            WHERE Mitarbeiter_ID = @Mitarbeiter_ID;
        END

        FETCH NEXT FROM mitarbeiter_cursor INTO @Mitarbeiter_ID, @Name, @Telefonnummer, @Geschäft_ID;
    END

    CLOSE mitarbeiter_cursor;
    DEALLOCATE mitarbeiter_cursor;
END;


INSERT INTO Mitarbeiter (Mitarbeiter_ID, Name,  Adresse, Rolle, Datum_der_Einstellung, Telefonnummer, Geschäft_ID)
VALUES (32, 'Costic', 'Strada Ta', 'Chef', GETDATE(), '742167181', 3);



EXEC UpdateMitarbeiter;


SELECT * FROM Mitarbeiter;
