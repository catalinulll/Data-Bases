-- 1)
SELECT P.Name AS Produse_Comune
FROM Produkte P
INNER JOIN Bestellte_Produkte BP ON P.Produkt_ID = BP.Produkt_ID

UNION

SELECT P.Name
FROM Produkte P
INNER JOIN Werbungen W ON P.Produkt_ID = W.Produkt_ID


SELECT P.Name
FROM Produkte P
LEFT JOIN Bestellte_Produkte BP ON P.Produkt_ID = BP.Produkt_ID
LEFT JOIN Werbungen W ON P.Produkt_ID = W.Produkt_ID
WHERE BP.Produkt_ID IS NULL AND W.Produkt_ID IS NULL;


-- 2) -- OR
SELECT DISTINCT P.Name AS Produse_Comune
FROM Produkte P
JOIN Bestellte_Produkte BP ON P.Produkt_ID = BP.Produkt_ID
WHERE (P.Produkt_ID IN (SELECT Produkt_ID FROM Bestellte_Produkte))
   OR (P.Produkt_ID IN (SELECT Produkt_ID FROM Werbungen));


-- 3) -- EXCEPT
SELECT KundeName
FROM (
    SELECT K.Name AS KundeName
    FROM Kunden K
    EXCEPT
    SELECT M.Name AS MitarbeiterName
    FROM Mitarbeiter M
) AS Clienti_Care_Nu_Sunt_Angajati
WHERE KundeName IS NOT NULL 
GROUP BY KundeName
ORDER BY KundeName ASC;



-- 4) -- NOT IN
SELECT M.Name AS Angajati_Care_Nu_Sunt_Clienti
FROM Mitarbeiter M
WHERE M.Name NOT IN (SELECT K.Name FROM Kunden K)
GROUP BY M.Name
HAVING COUNT(*) < 2;  


-- 5) -- ALL
SELECT P.Produkt_ID, P.Name, P.Preis, BP.Menge
FROM Produkte P
JOIN Bestellte_Produkte BP ON P.Produkt_ID = BP.Produkt_ID
WHERE P.Preis > ALL (
    SELECT AVG(P2.Preis)
    FROM Produkte P2
)



-- 6) -- ANY
SELECT TOP 2 P.Produkt_ID, P.Name, P.Preis, BP.Bestellung_ID
FROM Produkte P
JOIN Bestellte_Produkte BP ON P.Produkt_ID = BP.Produkt_ID
WHERE P.Produkt_ID = ANY (
    SELECT Produkt_ID
    FROM Bestellte_Produkte
    WHERE Menge > 2
)
ORDER BY P.Preis DESC;


-- 7) -- 
SELECT Mitarbeiter.Rolle, 
       MAX(CASE WHEN Datum_der_Einstellung = MaxDatum THEN Mitarbeiter.Name END) AS Cel_Mai_Nou_Angajat,
       MIN(CASE WHEN Datum_der_Einstellung = MinDatum THEN Mitarbeiter.Name END) AS Cel_Mai_Vechi_Angajat
FROM Mitarbeiter
JOIN (
    SELECT Rolle, MAX(Datum_der_Einstellung) AS MaxDatum, MIN(Datum_der_Einstellung) AS MinDatum
    FROM Mitarbeiter
    GROUP BY Rolle
) AS MaxMinDatum ON Mitarbeiter.Rolle = MaxMinDatum.Rolle
GROUP BY Mitarbeiter.Rolle;


-- 8
SELECT Kunden.Name, MAX(Bestellwert) AS Valoarea_Max_A_Comenzilor_Cu_Nr_Mai_Mare_Decat_5
FROM Kunden
JOIN Bestellungen ON Kunden.Kunde_ID = Bestellungen.Kunde_ID
JOIN (
    SELECT Bestellung_ID, SUM(Preis * Menge) AS Bestellwert
    FROM Bestellte_Produkte
    JOIN Produkte ON Bestellte_Produkte.Produkt_ID = Produkte.Produkt_ID
    GROUP BY Bestellung_ID
) AS Comenzi ON Bestellungen.Bestellung_ID = Comenzi.Bestellung_ID
GROUP BY Kunden.Name
HAVING MAX(Bestellwert) > 5;


























-- group by x2, having 2x, any, all, reuniune x2, intersectie x2

SELECT M.Name, COUNT(B.Bestellung_ID) AS Anzahl_der_Bestellungen
FROM Mitarbeiter M
JOIN Bestellungen B ON M.Mitarbeiter_ID = B.Mitarbeiter_ID
GROUP BY M.Mitarbeiter_ID,m.Name
HAVING COUNT(B.Bestellung_ID) >= (
    SELECT AVG(Bestellungsanzahl) FROM (
        SELECT M.Mitarbeiter_ID, COUNT(B.Bestellung_ID) AS Bestellungsanzahl
        FROM Mitarbeiter M
        JOIN Bestellungen B ON m.Mitarbeiter_ID = B.Mitarbeiter_ID
        GROUP BY M.Mitarbeiter_ID
    ) AS Subquery
);





SELECT M.Rolle, M.Name, COUNT(B.Bestellung_ID) AS Anzahl_der_Bestellungen
FROM Mitarbeiter M
JOIN Bestellungen B ON M.Mitarbeiter_ID = B.Mitarbeiter_ID
GROUP BY M.Mitarbeiter_ID, M.Rolle, M.Name
HAVING COUNT(B.Bestellung_ID) = (
    SELECT MAX(Anzahl_der_Bestellungen)
    FROM (
        SELECT COUNT(Bestellung_ID) AS Anzahl_der_Bestellungen
        FROM Bestellungen
        GROUP BY Mitarbeiter_ID
    ) AS Subquery
);






SELECT K.Name, B.Adresse, B.Preis
FROM Bestellungen B
JOIN Kunden K ON K.Kunde_ID = B.Kunde_ID
WHERE B.Preis >= ALL (SELECT Preis FROM Produkte)
   AND B.Adresse = ANY (SELECT Adresse FROM Mitarbeiter)
ORDER BY B.Preis;





SELECT TOP 3 Mitarbeiter.Name, Mitarbeiter.Adresse
FROM Mitarbeiter
WHERE Mitarbeiter.Rolle = 'Vanzator'
   OR Mitarbeiter.Mitarbeiter_ID IN (SELECT Bestellungen.Mitarbeiter_ID FROM Bestellungen WHERE Typ = 'Fizic')
ORDER BY Mitarbeiter.Adresse;





 (SELECT P.Name
 FROM Produkte P
 JOIN Bestellte_Produkte BP ON P.Produkt_ID = BP.Produkt_ID)
INTERSECT
(SELECT P.Name
 FROM Produkte P
 JOIN Werbungen W ON P.Produkt_ID = W.Produkt_ID);





(SELECT P.Name
 FROM Produkte P
 JOIN Bestellte_Produkte B ON P.Produkt_ID = B.Produkt_ID)
UNION
(SELECT P.Name
 FROM Produkte P
 JOIN Werbungen O ON P.Produkt_ID = O.Produkt_ID);








