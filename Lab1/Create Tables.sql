CREATE TABLE Etage(
	Etagenummer INT PRIMARY KEY,
	Anzahl_der_Geschäfte INT
);

CREATE TABLE Geschäfte(
	Geschäft_ID INT PRIMARY KEY,
	Name_des_Besitzers VARCHAR(50),
	Etagenummer INT
	FOREIGN KEY (Etagenummer) REFERENCES Etage(Etagenummer)
);

CREATE TABLE Mitarbeiter (
    Mitarbeiter_ID INT PRIMARY KEY,
    Name VARCHAR(50),
    Adresse VARCHAR(50),
    Rolle VARCHAR(50),
    Datum_Der_Einstellung DATE,
    Telefonnummer VARCHAR(50),
	Geschäft_ID INT,
	FOREIGN KEY (Geschäft_ID) REFERENCES Geschäfte(Geschäft_ID)
);

CREATE TABLE Kunden (
    Kunde_ID INT PRIMARY KEY,
    Name VARCHAR(50),
    Telefonnummer VARCHAR(50)
);

CREATE TABLE Produkte(
	Produkt_ID INT PRIMARY KEY,
	Name VARCHAR(50),
	Preis FLOAT
);

CREATE TABLE Kurierfirmen(
	Kurierfirma_ID INT PRIMARY KEY,
	Name_der_Firma VARCHAR(50)
);

CREATE TABLE Bestellungen (
    Bestellung_ID INT PRIMARY KEY,
    Adresse VARCHAR(50),
    Typ VARCHAR(50),
    Kurier VARCHAR(50),
    Mitarbeiter_ID INT,
    Kunde_ID INT,
    Produkt_ID INT,
	Kurierfirma_ID INT
    FOREIGN KEY (Mitarbeiter_ID) REFERENCES Mitarbeiter(Mitarbeiter_ID),
    FOREIGN KEY (Kunde_ID) REFERENCES Kunden(Kunde_ID),
	FOREIGN KEY (Produkt_ID) REFERENCES Produkte(Produkt_ID),
	FOREIGN KEY (Kurierfirma_ID) REFERENCES Kurierfirmen(Kurierfirma_ID)
);

CREATE TABLE Bestellte_Produkte(
	Bestellung_ID INT,
	Produkt_ID INT,
	Menge INT,
	PRIMARY KEY(Bestellung_ID, Produkt_ID),
	FOREIGN KEY (Bestellung_ID) REFERENCES Bestellungen(Bestellung_ID),
	FOREIGN KEY (Produkt_ID) REFERENCES Produkte(Produkt_ID)
);

CREATE TABLE Statistiken(
	Statistik_ID INT PRIMARY KEY,
	Bestellung_ID INT,
	FOREIGN KEY (Bestellung_ID) REFERENCES Bestellungen(Bestellung_ID)
);

CREATE TABLE Werbungen(
	Werbung_ID INT PRIMARY KEY,
	Typ VARCHAR(50),
	Anfangsdatum DATE,
	Enddatum DATE,
	Produkt_ID INT,
	FOREIGN KEY (Produkt_ID) REFERENCES Produkte(Produkt_ID)
);




