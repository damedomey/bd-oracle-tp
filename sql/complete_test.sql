-----------------------------------------------------------------------
-- Script de création d'un ensemble de données plus ou moins complet --
-----------------------------------------------------------------------

set serveroutput on
declare
    type listRefCategory is varray(14) of ref category;
    refCategories listRefCategory := listRefCategory();
    c category := null;

    b boat := null;
    refBoats listRefBoats := listRefBoats();
    refBoat ref boat;

    p pilot := null;
    refPilots listRefPilots := listRefPilots();
    refPilot ref pilot;

    cus customer := null;
    refCustomers listRefCustomers := listRefCustomers();
    refCustomer ref customer;

    r reservation := null;
    refReservations listRefReservations := listRefReservations();

    random Number := 0;
    random2 Number := 0;
begin
    -- Suppression de toutes les données des tables
    delete from categories;
    delete from boats;
    delete from pilots;
    delete from customers;
    delete from reservations;

    -- création des catégories
    refCategories.extend(14); -- allocation du tableau
    refCategories(1):=CATEGORY.persist(Category(1, 'Barge', listRefBoats()));
    refCategories(2):=CATEGORY.persist(Category(2, 'Battleship', listRefBoats()));
    refCategories(3):=CATEGORY.persist(Category(3, 'Boat', listRefBoats()));
    refCategories(4):=CATEGORY.persist(Category(4, 'Canoe', listRefBoats()));
    refCategories(5):=CATEGORY.persist(Category(5, 'Catamaran', listRefBoats()));
    refCategories(6):=CATEGORY.persist(Category(6, 'Destroyer', listRefBoats()));
    refCategories(7):=CATEGORY.persist(Category(7, 'Ferry', listRefBoats()));
    refCategories(8):=CATEGORY.persist(Category(8, 'Gondola', listRefBoats()));
    refCategories(9):=CATEGORY.persist(Category(9, 'Hovercraft', listRefBoats()));
    refCategories(10):=CATEGORY.persist(Category(10, 'Sailboat', listRefBoats()));
    refCategories(11):=CATEGORY.persist(Category(11, 'Schooner', listRefBoats()));
    refCategories(12):=CATEGORY.persist(Category(12, 'Ship', listRefBoats()));
    refCategories(13):=CATEGORY.persist(Category(13, 'Trawler', listRefBoats()));
    refCategories(14):=CATEGORY.persist(Category(14, 'Yacht', listRefBoats()));

    -- Création des bateaux
    refBoats.extend(20);
    refBoats(1):=boat.persist(boat(1, 'Serendipity', 30.5, 'Nice', 3, 1, 5, 3000, refCategories(1), listRefReservations()));
    refBoats(2):=boat.persist(boat(2, 'Imagination', 60, 'Nice', 4, 2, 8, 4200, refCategories(4), listRefReservations()));
    refBoats(3):=boat.persist(boat(3, 'Liberty', 10, 'Nice', 1, 1, 2, 1200, refCategories(9), listRefReservations()));
    refBoats(4):=boat.persist(boat(4, 'Wanderlust', 20, 'Cannes', 2, 1, 3, 2400, refCategories(7), listRefReservations()));
    refBoats(5):=boat.persist(boat(5, 'Gale', 25, 'Nice', 2, 1, 4, 2310, refCategories(1), listRefReservations()));
    refBoats(6):=boat.persist(boat(6, 'Zephyr', 29, 'Cannes', 2, 1, 4, 3500, refCategories(8), listRefReservations()));
    refBoats(7):=boat.persist(boat(7, 'Sapphire', 40, 'Antibes', 3, 2, 8, 3600, refCategories(1), listRefReservations()));
    refBoats(8):=boat.persist(boat(8, 'Amazonite', 9, 'Nice', 1, 1, 2, 200, refCategories(14), listRefReservations()));
    refBoats(9):=boat.persist(boat(9, 'Atlantis', 4, 'Antibes', 1, 1, 1, 150, refCategories(1), listRefReservations()));
    refBoats(10):=boat.persist(boat(10, 'Leviathan', 24, 'Cannes', 2, 1, 4, 3100, refCategories(14), listRefReservations()));
    refBoats(11):=boat.persist(boat(11, 'Noah', 22, 'Antibes', 2, 1, 4, 2500, refCategories(11), listRefReservations()));
    refBoats(12):=boat.persist(boat(12, 'Neptune', 58, 'Nice', 3, 2, 12, 4000, refCategories(11), listRefReservations()));
    refBoats(13):=boat.persist(boat(13, 'Wayfarer', 114, 'Nice', 5, 2, 24, 5500, refCategories(9), listRefReservations()));
    refBoats(14):=boat.persist(boat(14, 'Beauty', 120, 'Cannes', 5, 3, 30, 8500, refCategories(5), listRefReservations()));
    refBoats(15):=boat.persist(boat(15, 'Marquise', 14, 'Cannes', 1, 1, 4, 1000, refCategories(5), listRefReservations()));
    refBoats(16):=boat.persist(boat(16, 'Siren', 31, 'Antibes', 2, 1, 8, 3500, refCategories(9), listRefReservations()));
    refBoats(17):=boat.persist(boat(17, 'Leagues', 45, 'Nice', 3, 1, 8, 5500, refCategories(3), listRefReservations()));
    refBoats(18):=boat.persist(boat(18, 'Amethyst', 56, 'Nice',  3, 2, 12, 5800, refCategories(6), listRefReservations()));
    refBoats(19):=boat.persist(boat(19, 'Cleopatra', 2, 'Nice', 1, 1, 1, 130, refCategories(12), listRefReservations()));
    refBoats(20):=boat.persist(boat(20, 'Titan', 10, 'Antibes', 1, 1, 2, 180, refCategories(1), listRefReservations()));

    -- mise à jour des lien d'appartenance dans les catégories
    for i in refBoats.first..refBoats.last
    loop
        UTL_REF.SELECT_OBJECT(refBoats(i), b); -- récupération l'instance de chaque bateau
        UTL_REF.SELECT_OBJECT(b.refCategory, c); -- récupération de l'instance de la catégorie enregistrée dans le bateau
        c.ADDBOAT(refBoats(i)); -- ajouter le bateau dans la catégorie (lien inverse)
    end loop;

    -- création des pilotes
    refPilots.extend(20);
    refPilots(1):=pilot.persist(pilot(1, 'AMEDOMEY', tabPrenoms('Roméo', 'David'), 649953399, 'dav@gmail.com', null, listRefReservations()));
    refPilots(2):=pilot.persist(pilot(2, 'DOUMEGNON', tabPrenoms('Emilie', 'Sophie'), 644353399, 'emilie@gmail.com', null, listRefReservations()));
    refPilots(3):=pilot.persist(pilot(3, 'AKAKPO', tabPrenoms('Lucas', ' Antoine'), 649653399, 'lucas@gmail.com', null, listRefReservations()));
    refPilots(4):=pilot.persist(pilot(4, 'TEKOU', tabPrenoms('Julie', ' Marie'), 649553399, 'julie@gmail.com', null, listRefReservations()));
    refPilots(5):=pilot.persist(pilot(5, 'SOUMAH', tabPrenoms('Thomas', ' Alexandre'), 649653399, 'thomas@gmail.com', null, listRefReservations()));
    refPilots(6):=pilot.persist(pilot(6, 'KOUADIO', tabPrenoms('Léa', ' Caroline'), 649453399, 'lea@gmail.com', null, listRefReservations()));
    refPilots(7):=pilot.persist(pilot(7, 'ASSOUMAN', tabPrenoms('Axel', ' Paul'), 649353399, 'axel@gmail.com', null, listRefReservations()));
    refPilots(8):=pilot.persist(pilot(8, 'DAGNAN', tabPrenoms('Olivia', ' Anne'), 649253399, 'olivia@gmail.com', null, listRefReservations()));
    refPilots(9):=pilot.persist(pilot(9, 'KONE', tabPrenoms('Maxime', ' Guillaume'), 649153399, 'maxime@gmail.com', null, listRefReservations()));
    refPilots(10):=pilot.persist(pilot(10, 'TRAORE', tabPrenoms('Chloe', ' Nathalie'), 649053399, 'chloe@gmail.com', null, listRefReservations()));
    refPilots(11):=pilot.persist(pilot(11, 'KOUAME', tabPrenoms('Victor', ' Eric'), 648953399, 'victor@gmail.com', null, listRefReservations()));
    refPilots(12):=pilot.persist(pilot(12, 'KOFFI', tabPrenoms('Ines', ' Caroline'), 648853399, 'ines@gmail.com', null, listRefReservations()));
    refPilots(13):=pilot.persist(pilot(13, 'TANOH', tabPrenoms('Timothée', ' Thomas'), 648753399, 'timothee@gmail.com', null, listRefReservations()));
    refPilots(14):=pilot.persist(pilot(14, 'AKA', tabPrenoms('Camille', ' Sophie'), 648653399, 'camille@gmail.com', null, listRefReservations()));
    refPilots(15):=pilot.persist(pilot(15, 'KONAN', tabPrenoms('Julien', ' Alexandre'), 648553399, 'julien@gmail.com', null, listRefReservations()));
    refPilots(16):=pilot.persist(pilot(16, 'SOW', tabPrenoms('Axel', ' Étienne'), 683462699, 'axe@gmail.com', null, listRefReservations()));
    refPilots(17):=pilot.persist(pilot(17, 'CAMARA', tabPrenoms('Mila', ' Rose'), 734826199, 'mil@gmail.com', null, listRefReservations()));
    refPilots(18):=pilot.persist(pilot(18, 'DIALLO', tabPrenoms('Ethan', ' Nicolas'), 620910299, 'eth@gmail.com', null, listRefReservations()));
    refPilots(19):=pilot.persist(pilot(19, 'DIALLO', tabPrenoms('Maxime', ' Antoine'), 825643399, 'max@gmail.com', null, listRefReservations()));
    refPilots(20):=pilot.persist(pilot(20, 'BA', tabPrenoms('Emma', ' Louise'), 687997799, 'emm@gmail.com', null, listRefReservations()));

    -- création des clients
    refCustomers.extend(27);
    refCustomers(1):=customer.persist(customer(1, 'AMEDOMEY', tabPrenoms('Roméo', 'David'), 649953399, 'dav@gmail.com', listRefReservations()));
    refCustomers(2):=customer.persist(customer(2, 'JULDUP', tabPrenoms('Julie', 'Dupont'), 645335599, 'julie.dupont@gmail.com', listRefReservations()));
    refCustomers(3):=customer.persist(customer(3, 'JEANDUP', tabPrenoms('Jean', 'Dupont'), 647773399, 'jean.dupont@gmail.com', listRefReservations()));
    refCustomers(4):=customer.persist(customer(4, 'EMILMAR', tabPrenoms('Emilie', 'Martin'), 649223399, 'emilie.martin@gmail.com', listRefReservations()));
    refCustomers(5):=customer.persist(customer(5, 'THOMLER', tabPrenoms('Thomas', 'Leroy'), 649113399, 'thomas.leroy@gmail.com', listRefReservations()));
    refCustomers(6):=customer.persist(customer(6, 'LUCIBER', tabPrenoms('Lucie', 'Bernard'), 649553399, 'lucie.bernard@gmail.com', listRefReservations()));
    refCustomers(7):=customer.persist(customer(7, 'PAULDUR', tabPrenoms('Paul', 'Durand'), 649443399, 'paul.durand@gmail.com', listRefReservations()));
    refCustomers(8):=customer.persist(customer(8, 'SOPHMORE', tabPrenoms('Sophie', 'Moreau'), 649773399, 'sophie.moreau@gmail.com', listRefReservations()));
    refCustomers(9):=customer.persist(customer(9, 'VERDUP', tabPrenoms('Véronique', 'Dupond'), 649883399, 'veronique.dupond@gmail.com', listRefReservations()));
    refCustomers(10):=customer.persist(customer(10, 'CHLOLEC', tabPrenoms('Chloe', 'Leclerc'), 649993399, 'chloe.leclerc@gmail.com', listRefReservations()));
    refCustomers(11):=customer.persist(customer(11, 'BENJLEC', tabPrenoms('Benjamin', 'Leclerc'), 649943399, 'benjamin.leclerc@gmail.com', listRefReservations()));
    refCustomers(12):=customer.persist(customer(12, 'JULLEC', tabPrenoms('Julie', 'Leclerc'), 649893399, 'julie.leclerc@gmail.com', listRefReservations()));
    refCustomers(13):=customer.persist(customer(13, 'JSMITH', tabPrenoms('John', 'Smith'), 699953399, 'john@gmail.com', listRefReservations()));
    refCustomers(14):=customer.persist(customer(14, 'JDOE', tabPrenoms('Jane', 'Doe'), 649953388, 'jane@gmail.com', listRefReservations()));
    refCustomers(15):=customer.persist(customer(15, 'MJOHNSON', tabPrenoms('Michael', 'Johnson'), 649953377, 'michael@gmail.com', listRefReservations()));
    refCustomers(16):=customer.persist(customer(16, 'JWILLIAMS', tabPrenoms('Jessica', 'Williams'), 649953366, 'jessica@gmail.com', listRefReservations()));
    refCustomers(17):=customer.persist(customer(17, 'JBROWN', tabPrenoms('James', 'Brown'), 649953355, 'james@gmail.com', listRefReservations()));
    refCustomers(18):=customer.persist(customer(18, 'EDAVIS', tabPrenoms('Emily', 'Davis'), 649953344, 'emily@gmail.com', listRefReservations()));
    refCustomers(19):=customer.persist(customer(19, 'JMILLER', tabPrenoms('Joshua', 'Miller'), 649953333, 'joshua@gmail.com', listRefReservations()));
    refCustomers(20):=customer.persist(customer(20, 'AGARCIA', tabPrenoms('Ashley', 'Garcia'), 649953322, 'ashley@gmail.com', listRefReservations()));
    refCustomers(21):=customer.persist(customer(21, 'MRODRIGUEZ', tabPrenoms('Matthew', 'Rodriguez'), 649953311, 'matthew@gmail.com', listRefReservations()));
    refCustomers(22):=customer.persist(customer(22, 'OWILSON', tabPrenoms('Olivia', 'Wilson'), 649953300, 'olivia@gmail.com', listRefReservations()));
    refCustomers(23):=customer.persist(customer(23, 'DMARTINEZ', tabPrenoms('Daniel', 'Martinez'), 649953399, 'daniel@gmail.com', listRefReservations()));
    refCustomers(24):=customer.persist(customer(24, 'JANDERSON', tabPrenoms('Jacob', 'Anderson'), 649953388, 'jacob@gmail.com', listRefReservations()));
    refCustomers(25):=customer.persist(customer(25, 'ITHOMAS', tabPrenoms('Isabella', 'Thomas'), 649953377, 'isabella@gmail.com', listRefReservations()));
    refCustomers(26):=customer.persist(customer(26, 'EMOORE', tabPrenoms('Ethan', 'Moore'), 649953366, 'ethan@gmail.com', listRefReservations()));
    refCustomers(27):=customer.persist(customer(27, 'SJACKSON', tabPrenoms('Sophia', 'Jackson'), 649953355, 'sophia@gmail.com', listRefReservations()));

    -- création des reservations
    refReservations.extend(12);
    refReservations(1):=reservation.persist(reservation(1, to_date(to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'), 'DD-MM-YYYY HH24:MI:SS'), to_date('12-11-2022', 'DD-MM-YYYY'), to_date('12-11-2023', 'DD-MM-YYYY'), 3, 'Paid', listRefBoats(), listRefPilots(), listRefCustomers()));
    refReservations(2):=reservation.persist(reservation(2, to_date(to_char(current_timestamp+1, 'DD-MM-YYYY HH24:MI:SS'), 'DD-MM-YYYY HH24:MI:SS'), to_date('13-11-2022', 'DD-MM-YYYY'), to_date('13-11-2023', 'DD-MM-YYYY'), 4, 'Paid', listRefBoats(), listRefPilots(), listRefCustomers()));
    refReservations(3):=reservation.persist(reservation(3, to_date(to_char(current_timestamp+2, 'DD-MM-YYYY HH24:MI:SS'), 'DD-MM-YYYY HH24:MI:SS'), to_date('14-11-2022', 'DD-MM-YYYY'), to_date('14-11-2023', 'DD-MM-YYYY'), 5, 'Not paid', listRefBoats(), listRefPilots(), listRefCustomers()));
    refReservations(4):=reservation.persist(reservation(4, to_date(to_char(current_timestamp+3, 'DD-MM-YYYY HH24:MI:SS'), 'DD-MM-YYYY HH24:MI:SS'), to_date('15-11-2022', 'DD-MM-YYYY'), to_date('15-11-2023', 'DD-MM-YYYY'), 6, 'Paid', listRefBoats(), listRefPilots(), listRefCustomers()));
    refReservations(5):=reservation.persist(reservation(5, to_date(to_char(current_timestamp+4, 'DD-MM-YYYY HH24:MI:SS'), 'DD-MM-YYYY HH24:MI:SS'), to_date('16-11-2022', 'DD-MM-YYYY'), to_date('16-11-2023', 'DD-MM-YYYY'), 7, 'Not paid', listRefBoats(), listRefPilots(), listRefCustomers()));
    refReservations(6):=reservation.persist(reservation(6, to_date(to_char(current_timestamp+5, 'DD-MM-YYYY HH24:MI:SS'), 'DD-MM-YYYY HH24:MI:SS'), to_date('17-11-2022', 'DD-MM-YYYY'), to_date('17-11-2023', 'DD-MM-YYYY'), 8, 'Paid', listRefBoats(), listRefPilots(), listRefCustomers()));
    refReservations(7):=reservation.persist(reservation(7, to_date(to_char(current_timestamp+6, 'DD-MM-YYYY HH24:MI:SS'), 'DD-MM-YYYY HH24:MI:SS'), to_date('18-11-2022', 'DD-MM-YYYY'), to_date('18-11-2023', 'DD-MM-YYYY'), 9, 'Not paid', listRefBoats(), listRefPilots(), listRefCustomers()));
    refReservations(8):=reservation.persist(reservation(8, to_date(to_char(current_timestamp+7, 'DD-MM-YYYY HH24:MI:SS'), 'DD-MM-YYYY HH24:MI:SS'), to_date('12-11-2022', 'DD-MM-YYYY'), to_date('12-11-2023', 'DD-MM-YYYY'), 3, 'Paid', listRefBoats(), listRefPilots(), listRefCustomers()));
    refReservations(9):=reservation.persist(reservation(9, to_date(to_char(current_timestamp+8, 'DD-MM-YYYY HH24:MI:SS'), 'DD-MM-YYYY HH24:MI:SS'), to_date('12-11-2022', 'DD-MM-YYYY'), to_date('12-11-2023', 'DD-MM-YYYY'), 3, 'Paid', listRefBoats(), listRefPilots(), listRefCustomers()));
    refReservations(10):=reservation.persist(reservation(10, to_date(to_char(current_timestamp+9, 'DD-MM-YYYY HH24:MI:SS'), 'DD-MM-YYYY HH24:MI:SS'), to_date('12-11-2022', 'DD-MM-YYYY'), to_date('12-11-2023', 'DD-MM-YYYY'), 3, 'Not paid', listRefBoats(), listRefPilots(), listRefCustomers()));
    refReservations(11):=reservation.persist(reservation(11, to_date(to_char(current_timestamp+10, 'DD-MM-YYYY HH24:MI:SS'), 'DD-MM-YYYY HH24:MI:SS'), to_date('12-11-2022', 'DD-MM-YYYY'), to_date('12-11-2023', 'DD-MM-YYYY'), 3, 'Paid', listRefBoats(), listRefPilots(), listRefCustomers()));
    refReservations(12):=reservation.persist(reservation(12, to_date(to_char(current_timestamp+11, 'DD-MM-YYYY HH24:MI:SS'), 'DD-MM-YYYY HH24:MI:SS'), to_date('12-11-2022', 'DD-MM-YYYY'), to_date('12-11-2023', 'DD-MM-YYYY'), 3, 'Paid', listRefBoats(), listRefPilots(), listRefCustomers()));

    -- gestion des liens
    for i in refReservations.first..refReservations.last -- pour chaque reservation, on fait des liaisons aléatoire avec client, bateau et pilot
    loop
        UTL_REF.SELECT_OBJECT(refReservations(i), r); -- récupération de l'instance de la reservation

        random := DBMS_RANDOM.VALUE(2,10); -- choix du nombre de clients a ajouter à cette reservation
        for j in 1..random
        loop
            -- Ajout du client j à la reservation
            begin -- Les blocs begin..end sont juste pour éviter de paralyser le script si le choix aléatoire d'une instance tombre sur un élément déjà pris en raison des contraintes d'intégrités sur les nested tables
                refCustomer := refCustomers(DBMS_RANDOM.VALUE(1,27)); -- choix d'un client (aléatoire)
                UTL_REF.SELECT_OBJECT(refCustomer, cus);
                r.addLinkCustomer(refCustomer);
                cus.addLinkReservation(refReservations(i));
                exception
            when others then null;
            end;
        end loop;

        random2 := DBMS_RANDOM.VALUE(2,random); -- choix du nombre de pilotes et de bateaux à ajouter
        for j in 1..random
        loop
            -- Ajout des pilots
            begin
                refPilot := refPilots(DBMS_RANDOM.VALUE(1,20)); -- choix d'un pilot
                UTL_REF.SELECT_OBJECT(refPilot, p);
                r.addLinkPilot(refPilot);
                p.addLinkReservation(refReservations(i));
            exception
                when others then null;
            end;

            -- Ajout des bateaux
            begin
                refBoat := refBoats(DBMS_RANDOM.VALUE(1,20)); -- choix d'un bateau
                UTL_REF.SELECT_OBJECT(refBoat, b);
                r.addLinkBoat(refBoat);
                b.addLinkReservation(refReservations(i));
                exception
                    when others then null;
            end;
        end loop;
    end loop;
end;
/
select * from categories;
select * from boats;
select * from customers;
select * from pilots;
select * from reservations;