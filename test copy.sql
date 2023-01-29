-- TESTS UNITAIRES
-- Précondition : Les tests ci-dessous sont des tests unitaires mais se basent sur les élements
--              des tests précédents (insertion). Donc il faut les exécuter dans l'ordre.

-- test du crud et methodes de catégorie
set serveroutput on
declare
    c CATEGORY := null;
    c2 CATEGORY := null;
    refCategory ref CATEGORY := null;
    r boolean := null;
    b BOAT := null;
    refBoat ref BOAT := null;
    boatsList listRefBoats;
begin
    delete from categories;
    c:=Category(1, 'Navire', listRefBoats());
    c2:=Category(2, 'Cat 2', listRefBoats());

    -- addBoat
    b := BOAT(1, 'Serendipity', 30.5, 'Nice', 3, 1, 5, 3000, refCategory, listRefReservations()));
    refBoat := BOAT.persist(b);
    c.addBoat(refBoat);
    -- getBoats
    boatsList := c.getBoats();

    -- insertion des deux objets
    refCategory:=CATEGORY.persist(c);
    refCategory:=CATEGORY.persist(c2);

    c2:=CATEGORY.findById(1);
    c2.ID:=2;
    c2.NAME:='update name';
    r:=CATEGORY.change(c2.id, c2);--remplacement du nom de la deuxième catégorie

    -- removeBoat
    c2.removeBoat(refBoat);
    -- getBoats
    boatsList := c2.getBoats();

    r:=Category.remove(c.id);--suppression du premier objet
    -- dbms_output.put_line('dname'||c.NAME);
end;
/
select * from categories;

-- test du crud et methodes de bateau
set serveroutput on
declare
    b boat :=null;
    b2 boat :=null;
    refBoat ref boat := null;
    c category := null;
    refCategory ref CATEGORY := null;
    r boolean := null;
begin
    delete from boats;
    SELECT ref(ca) into refCategory FROM categories ca; -- selection d'une catégorie au hasard
    b:=boat(1, 'Serendipity', 30.5, 'Nice', 3, 1, 5, 3000, refCategory, listRefReservations());
    b2:=boat(2, 'Imagination', 60, 'Nice', 4, 2, 8, 4200, refCategory, listRefReservations());

    refBoat:=boat.persist(b);
    refBoat:=BOAT.persist(b2);

    UTL_REF.SELECT_OBJECT(refCategory, c);
    c.ADDBOAT(refBoat); -- ajouter le bateau dans la catégorie
    b.id := 2;
    b.name := 'hello 2';
    refBoat := boat.persist(b); -- création d'un doublons avec un id différent
    b.name := 'update name';
    r := boat.change(b.id, b); -- mise à jour du doublons
    r := boat.remove(b.id); -- suppression du premier élément
    --r := boat.remove(1); -- suppression du premier élément

    -- addLinkReservation et deleteLinkReservation
    b2.addLinkReservation(refReservation);
    refReservations:=b2.getReservations;
    b2.deleteLinkReservation(refReservation);
    refReservations:=b2.getReservations;

    -- getReservations
    refReservations:=b2.getReservations;
    dbms_output.put_line('Number of reservations: ' || refReservations.count);
end;
/
select * from boats;

-- test du crud et methodes des pilotes et clients
set serveroutput on
declare
    p pilot := null;
    refPilot ref pilot;
    c customer := null;
    refCustomer ref customer := null; 
    t boolean;
    lr LISTREFBOATS:=null;
    r RESERVATION := null;
    r2 RESERVATION := null;
    refReservation ref RESERVATION := null;
    reservationsListRef listRefReservations;
begin
    delete from customers;
    delete from pilots;
    -- création d'un objet de chaque type
    p := pilot(1, 'David pilot', tabPrenoms('AMEDOMEY'), 33649955555, 'email@email.com', null, null);
    c := customer(1, 'David client', tabPrenoms('AMEDOMEY'), 33649955555, 'email@email.com', null);
    r := Reservation(1, '2022-01-01', '2022-01-05', refBoat, refCustomer);
    r2:=Reservation(1, '2022-01-02', '2022-01-07', refBoat, refCustomer);

    -- insertion dans la base de données
    refPilot:=pilot.persist(p);
    refCustomer:=customer.persist(c);
    refReservation := Reservation.persist(r);
    refReservation := Reservation.persist(r2);

    -- addLinkReservation customer
    refCustomer.addLinkReservation(refReservation);
    reservationsListRef := refCustomer.getReservations();
    dbms_output.put_line('Number of reservations: ' || reservationsListRef.count);
    
    -- deleteLinkReservation customer
    refCustomer.deleteLinkReservation(refReservation);
    reservationsListRef := refCustomer.getReservations();
    dbms_output.put_line('Number of reservations: ' || reservationsListRef.count);

    -- getUsedBoat
    lr:=customer.findById(2).getUsedBoat();
    dbms_output.put_line('Number of used boats: '||lr.COUNT);


    -- addLinkReservation et deleteLinkReservation pilot
    p2:=PILOT.findById(1);
    p2.addLinkReservation(r1);
    p2.addLinkReservation(r2);
    p2.deleteLinkReservation(r1);
    p2.getReservations();

    -- insertion d'un doublons
    p := pilot(2, 'David pilot 2', tabPrenoms('AMEDOMEY'), 336499555255, 'ema2il@email.com', null, null);
    c := customer(2, 'David client2', tabPrenoms('A2MEDOMEY'), 336499555552, 'email@email.com', null);
    refPilot:=pilot.persist(p);
    refCustomer:=customer.persist(c);
    -- mise à jour de la valeur de la dernière insertion
    p.name := 'David pilot update';
    c.name := 'David pilot update';
    t:=pilot.change(p.id, p);
    t:=customer.change(c.id, c);
    -- suppression du premier element avec l'id 1
    t:=pilot.remove(1);
    t:=customer.remove(1);


end;
/
select * from pilots;
select * from customers;

-- test getPilotedBoats pilots
set serveroutput on
declare
    p PILOT := null;
    res REF RESERVATION := null;
    boat1 REF BOAT := null;
    boat2 REF BOAT := null;
    pilotedBoatsList listRefBoats := null;
begin
    p := pilot(1, 'David pilot', tabPrenoms('AMEDOMEY'), 33649955555, 'email@email.com', null, null);

    boat1 := boat(1, 'Serendipity', 30.5, 'Nice', 3, 1, 5, 3000, refCategory, listRefReservations());
    boat2 := boat(2, 'Imagination', 60, 'Nice', 4, 2, 8, 4200, refCategory, listRefReservations());

    res := reservation(1, to_date(to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'), 'DD-MM-YYYY HH24:MI:SS'), to_date('12-11-2022', 'DD-MM-YYYY'), to_date('12-11-2023', 'DD-MM-YYYY'), 3, 'Paid', null, null, null);
    res := reservation(2, to_date(to_char(current_timestamp+2, 'DD-MM-YYYY HH24:MI:SS'), 'DD-MM-YYYY HH24:MI:SS'), to_date('12-11-2022', 'DD-MM-YYYY'), to_date('12-11-2023', 'DD-MM-YYYY'), 3, 'Paid', null, null, null);
    
    p.addLinkReservation(res);
    pilotedBoatsList := p.getPilotedBoats();
    
    for i in pilotedBoatsList.first..pilotedBoatsList.last loop
        dbms_output.put_line(pilotedBoatsList(i).name);
    end loop;
    
    dbms_output.put_line('Number of piloted boats: '||pilotedBoatsList.count);
end;
/


-- test crud reservation
set serveroutput on
declare
    re reservation:=null;
    refReservation ref reservation;
    r boolean:=null;
begin
    delete from reservations;
    -- création de deux reservation
    re:=reservation(1, to_date(to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'), 'DD-MM-YYYY HH24:MI:SS'), to_date('12-11-2022', 'DD-MM-YYYY'), to_date('12-11-2023', 'DD-MM-YYYY'), 3, 'Paid', null, null, null);
    refReservation := reservation.persist(re);
    re:=reservation(2, to_date(to_char(current_timestamp+2, 'DD-MM-YYYY HH24:MI:SS'), 'DD-MM-YYYY HH24:MI:SS'), to_date('12-11-2022', 'DD-MM-YYYY'), to_date('12-11-2023', 'DD-MM-YYYY'), 3, 'Paid', null, null, null);
    refReservation := reservation.persist(re);
    -- suppression de la première reservation
    r:=reservation.remove(1);
end;
select * from reservations;

--
set serveroutput on
declare
    listBo LISTREFBOATS;
    b boat;
begin
    SELECT ca.CLISTREFBOATS into listBo FROM CATEGORIES ca;
    for i in listBo.first .. listBo.last
        loop
            UTL_REF.SELECT_OBJECT(listBo(i), b);
            dbms_output.put_line('name '||b.name);
        end loop;
end;
/


-- INSERTION DE 20 OBJETS DE CHAQUE TYPE
-- insertion de