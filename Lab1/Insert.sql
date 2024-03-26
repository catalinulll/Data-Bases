INSERT INTO Etage(Etagenummer, Anzahl_der_Geschäfte)
VALUES (0, 23),
	   (1, 45),
	   (2, 13),
	   (3, 10);

INSERT INTO Geschäfte(Geschäft_ID, Name_des_Besitzers, Etagenummer)
VALUES (1, 'Andrei Cutarescu', 2),
	   (2, 'Carmen Mister', 0),
	   (3, 'Billy Ionescu', 1),
	   (4, 'Marian Dragulescur', 0),
	   (5, 'George Georgescu', 3);


INSERT INTO Mitarbeiter(Mitarbeiter_ID, Name, Adresse, Rolle, Datum_der_Einstellung, Telefonnummer, Geschäft_ID)
VALUES (1, 'Elena Ursu', 'Strada Gentilor', 'Casier', '2019-09-24', '0760760760', 2),
	   (2, 'Traian Baros', 'Strada Mare', 'Om de serviciu', '2020-03-11', '0765948302', 1),
	   (3, 'Cristi Pop', 'Strada Mica', 'Instalator', '2010-08-28', '0745628732', 4),
	   (4, 'Marcica Vasilica', 'Aleea Sperantei', 'Electrician', '2023-10-19', '0739283018', 5),
	   (5, 'Valerica Seba', 'Strada Cicoare', 'Paznic', '2018-07-01', '0767092625',3);
	  
INSERT INTO Kunden(Kunde_ID, Name, Telefonnummer)
VALUES (1, 'Mircea Marinescu', '0749573243'),
	   (2, 'Dorian Popa', '0734092812'),
	   (3, 'Maria Paparude', '0230303030'),
	   (4, 'Dorel Marcel', '0798564827'),
	   (5, 'Alex Popescu', '0766306121');

INSERT INTO Produkte(Produkt_ID, Name, Preis)
VALUES (1, 'Cafea Jacobs', 20.5),
	   (2, 'Paine Mopan', 4.5),
	   (3, 'Billy Ionescu', 8),
	   (4, 'Telefon de jucarie', 50),
	   (5, 'Calculator', 2389),
	   (6, 'Telefon de jucarie', 50),
	   (7, 'Inghetata', 10.5),
	   (8, 'Ruj', 150),
	   (9, 'Bluza', 59.9);

INSERT INTO Kurierfirmen(Kurierfirma_ID, Name_der_Firma)
VALUES (1, 'NOVAMAX'),
	   (2, 'Fan Curier'),
	   (3, 'Fastx'),
	   (4, 'Cargus'),
	   (5, 'GicaSRL');

INSERT INTO Bestellungen(Bestellung_ID, Adresse, Typ, Kurier, Mitarbeiter_ID, Kunde_ID, Produkt_ID, Kurierfirma_ID)
VALUES (1, 'Strada Plaiului', 'Fizic', 'Marcel Mirel', 1, 1, 1, 1),
	   (2, 'Strada Missi', 'Online', 'Cecilia Liliana', 2, 2, 2, 2),
	   (3, 'Allea Sperantei', 'Online', 'Gica Hagi', 3, 3, 3, 3),
	   (4, 'Strada Pissi', 'Fizic', 'Carmen Gere', 4, 4, 4, 4),
	   (5, 'Strada Supei', 'Online', 'Cornel Passat', 5, 5, 5, 5);

INSERT INTO Bestellte_Produkte(Bestellung_ID, Produkt_ID, Menge)
VALUES (3, 9, 5),
       (4, 7, 10),
	   (2, 3, 15),
	   (5, 2, 2),
	   (4, 5, 23);

INSERT INTO Statistiken(Statistik_ID, Bestellung_ID)
VALUES (1, 3),
       (2, 5),
	   (3, 2);

INSERT INTO Werbungen(Werbung_ID, Typ, Anfangsdatum, Enddatum, Produkt_ID)
VALUES (1, '2+1', '2020-02-18', '2020-02-28', 1),
	   (2, '-30%', '2021-01-01', '2021-01-06', 2),
	   (3, '-10%', '2021-02-24', '2021-02-28', 5),
	   (4, '-20%', '2021-03-10', '2021-03-16', 7),
	   (5, '1+1', '2022-11-01', '2022-11-29', 9);
	  

INSERT INTO Bestellungen(Bestellung_ID, Adresse, Typ, Kurier, Mitarbeiter_ID, Kunde_ID, Produkt_ID, Kurierfirma_ID)
VALUES (80, 'Strada Lalelelor', 'Fizic', 'Marcel Ionescu', 49, 1, 1, 0);


