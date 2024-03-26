--OR
UPDATE Bestellungen
SET Kunde_ID = NULL
WHERE Kunde_ID = 1 OR Kunde_ID = 2;

DELETE FROM Kunden
WHERE Kunde_ID = 1 OR Kunde_ID = 2;

--IN
UPDATE Mitarbeiter
SET Rolle = 'Primar'
WHERE Mitarbeiter_ID IN (1, 2, 3);

UPDATE Statistiken
SET Bestellung_ID = NULL
WHERE Bestellung_ID IN (1, 3, 5);
DELETE FROM Bestellungen
WHERE Mitarbeiter_ID IN (1, 3, 5);

--BETWEEN
UPDATE Bestellungen
SET Typ = 'Ceva'
WHERE Bestellung_ID BETWEEN 1 AND 3;

DELETE FROM Mitarbeiter
WHERE Datum_Der_Einstellung BETWEEN '2022-01-01' AND '2022-12-31';

--LIKE
UPDATE Bestellungen
SET Adresse = 'Scoala Nr.1'
WHERE Adresse LIKE '%Strada%';

DELETE FROM Kurierfirmen
WHERE Name_der_Firma LIKE '%Cargus%'

-- IS NOT NULL
UPDATE Geschäfte
SET Etagenummer = NULL
WHERE Etagenummer IS NOT NULL;
DELETE FROM Etage
WHERE Etagenummer IS NOT NULL;

UPDATE Mitarbeiter
SET Adresse = 'NoodlePack'
WHERE Mitarbeiter_ID = 1 AND Adresse IS NOT NULL;





