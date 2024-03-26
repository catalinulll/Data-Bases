DROP TABLE Ta;
DROP TABLE Tb;
DROP TABLE Tc;


CREATE TABLE Ta (
    idA INT PRIMARY KEY,
    a2 INT UNIQUE,
	a3 INT
);

CREATE TABLE Tb (
    idB INT PRIMARY KEY,
    b2 INT,
    b3 INT
);

CREATE TABLE Tc (
    idC INT PRIMARY KEY,
    idA INT FOREIGN KEY REFERENCES Ta(idA),
    idB INT FOREIGN KEY REFERENCES Tb(idB)
);


CREATE OR ALTER PROCEDURE InsertData
AS
BEGIN
    DECLARE @i INT = 1;

    WHILE @i <= 10000
    BEGIN
        INSERT INTO Ta (idA, a2, a3)
        VALUES (@i, @i * 2, @i * 5);

        SET @i = @i + 1;
    END

    SET @i = 1;

    WHILE @i <= 3000
    BEGIN
        INSERT INTO Tb (idB, b2, b3)
        VALUES (@i, @i * 3, @i * 4);

        SET @i = @i + 1;
    END

    SET @i = 1;

    WHILE @i <= 30000
    BEGIN
        DECLARE @idA INT, @idB INT;

        SELECT TOP 1 @idA = idA FROM Ta ORDER BY NEWID();
        SELECT TOP 1 @idB = idB FROM Tb ORDER BY NEWID();

        INSERT INTO Tc (idC, idA, idB)
        VALUES (@i, @idA, @idB);

        SET @i = @i + 1;
    END
END;

EXEC InsertData;

SELECT *
FROM Ta
WHERE idA > 0;

SELECT COUNT(*)
FROM Tc

SELECT *
FROM Tb
WHERE idB > 0;

SELECT *
FROM Tc
WHERE idC > 0;

SELECT * FROM Tc WHERE idA = idB;


-- Teil 2

-- a)

EXEC sp_helpindex 'Ta';

SELECT * FROM Ta WHERE idA BETWEEN 1 AND 100; 

SELECT * FROM Ta ORDER BY idA; 

SELECT * FROM Ta WHERE a2 BETWEEN 1 AND 30; 

SELECT a2 FROM Ta 
WHERE a2 LIKE '1%'; 

-- b)

SELECT * FROM Ta WHERE idA > 10;

-- c)

SELECT * FROM Tb WHERE b2 = 1122;

DROP INDEX IX_Tb_b2 ON Tb;

CREATE NONCLUSTERED INDEX IX_Tb_b2 ON Tb (b2);

SELECT * FROM Tb WHERE b2 = 1122;

-- d)

SELECT * FROM Tc
INNER JOIN Ta ON Tc.idA = Ta.idA
WHERE Ta.a2 = 272;

SELECT * FROM Tc
INNER JOIN Ta ON Tc.idA = Ta.idA
WHERE Ta.idA = 272;

SELECT * FROM Tc
INNER JOIN Tb ON Tc.idB = Tb.idB
WHERE Tb.b2 = 1122;

CREATE NONCLUSTERED INDEX IX_Tc_idA ON Tc (idA);
CREATE NONCLUSTERED INDEX IX_Tc_idB ON Tc (idB);

DROP INDEX IX_Tc_idA ON Tc;
DROP INDEX IX_Tc_idB ON Tc;

SELECT * FROM Tc
JOIN Ta ON Tc.idA = Ta.idA
WHERE Ta.a2 = 272;


SELECT * FROM Tc
JOIN Tb ON Tc.idB = Tb.idB
WHERE Tb.b2 = 1122;



