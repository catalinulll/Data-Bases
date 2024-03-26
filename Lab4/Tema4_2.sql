CREATE OR ALTER VIEW vw_BestellteProdukteDetails
AS
SELECT
    bp.Bestellung_ID,
    bp.Produkt_ID,
	p.Preis AS ProduktPreis,
    bp.Menge
FROM
    Bestellte_Produkte bp
JOIN
    Produkte p ON bp.Produkt_ID = p.Produkt_ID;


CREATE OR ALTER FUNCTION fn_GetOrderDetails
(
    @KundeName VARCHAR(100),
    @Bestellung_ID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        bp.Bestellung_ID,
        p.Name AS ProduktName,
        k.Name AS KundeName
    FROM
        Bestellte_Produkte bp
    JOIN
        Produkte p ON bp.Produkt_ID = p.Produkt_ID
    JOIN
        Bestellungen b ON bp.Bestellung_ID = b.Bestellung_ID
    JOIN
        Kunden k ON b.Kunde_ID = k.Kunde_ID
    WHERE
        k.Name = @KundeName AND bp.Bestellung_ID = @Bestellung_ID
);



DECLARE @KundeName VARCHAR(100) = 'Dorel Marcel';
DECLARE @Bestellung_ID INT = 1;

SELECT
    v.Bestellung_ID AS Bestellung_ID,
    v.Produkt_ID AS Produkt_ID,
    v.Menge AS Menge,
    f.ProduktName AS ProduktName,
    v.ProduktPreis AS ProduktPreis,
    f.KundeName AS KundeName
FROM
    vw_BestellteProdukteDetails v
JOIN
    fn_GetOrderDetails(@KundeName, @Bestellung_ID) f ON v.Bestellung_ID = f.Bestellung_ID;

