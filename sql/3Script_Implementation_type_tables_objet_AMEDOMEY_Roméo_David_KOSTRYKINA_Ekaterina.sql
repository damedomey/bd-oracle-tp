/*
    AMEDOMEY Roméo David : Création des types et tables objets
    KOSTRYKINA Ekaterina : Écriture des scripts de test des methodes et de création d'un ensemble de donnée
*/
-----------------------------------------------------------------------------
-- Script de création des types, des tables et des contraintes d'intégrité --
-----------------------------------------------------------------------------

-- Suppression des types et tables
drop table categories cascade constraints;
drop table boats cascade constraints;
drop table pilots cascade constraints;
drop table customers cascade constraints;
drop table reservations cascade constraints;
drop type category force;
drop type listRefBoats force;
drop type boat force;
drop type listRefReservations force;
drop type reservation force;
drop type tabPrenoms force;
drop type person force;
drop type listRefCustomers force;
drop type customer force;
drop type listRefPilots force;
drop type pilot force;
/

-- Création des types
create or replace type boat
/
create or replace type listRefBoats as table of REF boat
/

create or replace type category;
/

create or replace type category as object (
      id              number(8),
      name            varchar2(20),
      cListRefBoats   listRefBoats,
      static function findById(identifiant Number) return category,
      static function persist(c category) return ref category,
      static function change(identifiant Number, newValue category) return boolean,
      static function remove(identifiant Number) return boolean,
      member procedure addBoat(b REF boat),
      member function getBoats return listRefBoats,
      member procedure removeBoat(b REF boat),
      map member function compare return varchar2
    );
/

create or replace type reservation;
/
create or replace type listRefReservations as table of REF reservation;
/
create or replace type boat as object (
  id              number(8),
  name            varchar2(20),
  surface         float,
  city            varchar2(30),
  number_of_cabins int,
  floors          int,
  max_seats       int,
  price           float,
  refCategory     REF category,
  bListRefReservations listRefReservations,
  static function findById(identifiant Number) return boat,
  static function persist(b boat) return ref boat,
  static function change(identifiant Number, newValue boat) return boolean,
  static function remove(identifiant Number) return boolean,
  member function getReservations return listRefReservations,
  member procedure addLinkReservation(refReservation REF reservation),
  member procedure deleteLinkReservation(refReservation REF reservation),
  map member function compare return varchar2
);
/
create or replace type tabPrenoms as varray(4) of varchar2(10);
/
create or replace type person as object(
   id              number(8),
   name            varchar2(20),
   surname         tabPrenoms,
   telephone       int(15),
   email           varchar2(150),
   map member function compare return varchar2
) not instantiable not final;
/
create or replace type customer under person(
    cListRefReservations listRefReservations,
    static function findById(identifiant Number) return customer,
    static function persist(c customer) return ref customer,
    static function change(identifiant Number, newValue customer) return boolean,
    static function remove(identifiant Number) return boolean,
    member function getReservations return listRefReservations,
    member procedure addLinkReservation(refReservation REF reservation),
    member procedure deleteLinkReservation(refReservation REF reservation),
    member function getUsedBoat return listRefBoats
);
/
create or replace type pilot under person(
     licence         blob,
     pListRefReservations listRefReservations,
     static function findById(identifiant Number) return pilot,
     static function persist(p pilot) return ref pilot,
     static function change(identifiant Number, newValue pilot) return boolean,
     static function remove(identifiant Number) return boolean,
     member function getReservations return listRefReservations,
     member procedure addLinkReservation(refReservation REF reservation),
     member procedure deleteLinkReservation(refReservation REF reservation),
     member function getPilotedBoats return listRefBoats
 );
/
create or replace type listRefPilots as table of REF pilot;
/
create or replace type listRefCustomers as table of REF customer;
/
create or replace type reservation as object (
     id                  number(8),
     request_datetime    date,
     start_date          date,
     end_date            date,
     group_size          int,
     state_of_reservation varchar2(10),
     rListRefBoats       listRefBoats,
     rListRefPilots       listRefPilots,
     rListRefCustomers   listRefCustomers,
     static function findById(identifiant Number) return reservation,
     static function persist(r reservation) return ref reservation,
     static function change(identifiant Number, newValue reservation) return boolean,
     static function remove(identifiant Number) return boolean,
     member procedure addLinkBoat(refboat REF boat),
     member procedure deleteLinkBoat(refBoat REF boat),
     member procedure addLinkCustomer(refCustomer REF customer),
     member procedure deleteLinkCustomer(refCustomer REF customer),
     member procedure addLinkPilot(refPilot REF pilot),
     member procedure deleteLinkPilot(refPilot REF pilot),
     map member function compare return varchar2
 );
/

-- Création des tables
create table categories of category(
    constraint pk_categories_id primary key (id),
    name constraint nnl_categories_name not null
)
    nested table cListRefBoats store as table_listRefBoats;
/

create table boats of boat(
    constraint pk_boats_id primary key (id),
    name constraint nnl_boats_name not null,
    surface constraint nnl_boats_size not null,
    city constraint nnl_boats_city not null,
    number_of_cabins constraint nnl_boats_number_of_cabins not null,
    floors constraint nnl_boats_floors not null,
    max_seats constraint nnl_boats_max_seatsnot not null,
    price constraint nnl_boats_price not null,
    refCategory constraint nnl_boats_category not null,
    constraint chk_boats_number_of_cabins check(number_of_cabins > 0),
    constraint chk_boats_floors check(floors >= 0),
    constraint chk_boats_max_seats check(max_seats > 0),
    constraint chk_boats_price check(price > 0)
) nested table bListRefReservations store as table_listRefReservations;
/

create table customers of customer (
    constraint pk_customers_id primary key (id),
    name constraint nnl_customers_name not null,
    surname constraint nnl_customers_surname not null,
    telephone constraint nnl_customers_telephone not null,
    email constraint nnl_customers_email not null,
    constraint chk_cusomers_email check(REGEXP_LIKE(email, '^\w+(\.\w+)*+@\w+(\.\w+)+$'))
) nested table cListRefReservations store as table_cListRefReservations;
/

create table pilots of pilot (
    constraint pk_pilots_id primary key (id),
    name constraint nnl_pilots_name not null,
    surname constraint nnl_pilots_surname not null,
    telephone constraint nnl_pilots_telephone not null,
    email constraint nnl_pilots_email not null,
    constraint chk_pilots_email check(REGEXP_LIKE(email, '^\w+(\.\w+)*+@\w+(\.\w+)+$'))
) nested table pListRefReservations store as table_pListRefReservations,
    LOB (licence) store as storeLicence (PCTVERSION 30);
/

create table reservations of reservation (
    constraint pk_reservations_id primary key (id),
    request_datetime constraint nnl_reservations_request_datetime not null,
    start_date constraint nnl_reservations_start_date not null,
    end_date constraint nnl_reservations_end_date not null,
    group_size constraint nnl_reservations_group_size not null,
    state_of_reservation constraint nnl_reservations_state_of_reservation not null,
    constraint chk_reservations_group_size check (group_size > 0),
    constraint chk_reservations_state_of_reservations check (state_of_reservation in ('Paid', 'Not paid'))
) nested table rListRefBoats store as table_rListRefBoats,
    nested table rListRefPilots store as table_rListRefPilots,
    nested table rListRefCustomers store as table_rListRefCustomers;
/
-- Création des index
create unique index idx_categories_name on categories(name);
/
create unique index idx_boats_name on boats(name);
/
create unique index idx_reservations_request_datetime on reservations(request_datetime);
/
-- Création des scope pour chaque clé étranger
alter table table_listRefBoats add (scope for (COLUMN_VALUE) is boats);
alter table table_listRefReservations add (scope for (COLUMN_VALUE) is reservations);
alter table table_cListRefReservations add (scope for (COLUMN_VALUE) is reservations);
alter table table_pListRefReservations add (scope for (COLUMN_VALUE) is reservations);
alter table table_rListRefBoats add (scope for (COLUMN_VALUE) is boats);
alter table table_rListRefPilots add (scope for (COLUMN_VALUE) is pilots);
alter table table_rListRefCustomers add (scope for (COLUMN_VALUE) is customers);

-- Contraintes supplémentaires
-- todo: contraintes sur les column_values (unique) et index
-- Implémentation des méthodes de chaque type

create or replace type body category as
    static function findById(identifiant Number) return category is
        c category := null;
    begin
        SELECT value(ca) INTO c FROM categories ca WHERE ca.id = identifiant;
        return c;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            raise;
        WHEN OTHERS THEN
            raise;
    end;
    static function persist(c category) return ref category is
        refCategory ref category := null;
    begin
        insert into categories ca values c returning ref(ca) into refCategory;
        return refCategory;
    EXCEPTION
        WHEN OTHERS THEN
            raise;
    end;
    static function change(identifiant Number, newValue category) return boolean is
    begin
        UPDATE categories set name = newValue.name, CLISTREFBOATS = newValue.CLISTREFBOATS where id = identifiant;
        return true;
    EXCEPTION
        WHEN OTHERS THEN
            raise;
    end;
    static function remove(identifiant Number) return boolean is
    begin
        DELETE FROM categories ca where ca.id = identifiant;
        return true;
    EXCEPTION
        WHEN OTHERS THEN
            raise;
    end;
    member procedure addBoat(b REF boat) is
    begin
        insert into table ( select cListRefBoats from categories ca where ca.id = self.id )
        values (b);
    EXCEPTION
        WHEN OTHERS THEN
            raise;
    end;
    member function getBoats return listRefBoats is
        refBoats listRefBoats := null;
    begin
        select ca.CLISTREFBOATS into refBoats from categories ca where ca.id = self.id;
        return refBoats;
    EXCEPTION
        WHEN OTHERS THEN
            raise;
    end;
    member procedure removeBoat(b REF boat) is
    begin
        delete from table ( select ca.cListRefBoats from categories ca where ca.id = self.id ) lbo
        where lbo.COLUMN_VALUE = b;
    end;
    map member function compare return varchar2 is
    begin
        return self.NAME || self.ID;
    end;
end;
/

create or replace type body boat as
    static function findById(identifiant Number) return boat is
        b boat := null;
    begin
        SELECT value(bo) INTO b FROM boats bo WHERE bo.id = identifiant;
        return b;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            raise;
        WHEN OTHERS THEN
            raise;
    end;
    static function persist(b boat) return ref boat is
        refBoat ref boat;
    begin
        insert into boats bo values (b) returning ref(bo) into refBoat;
        return refBoat;
    EXCEPTION
        WHEN OTHERS THEN
            raise;
    end;
    static function change(identifiant Number, newValue boat) return boolean is
    begin
        UPDATE boats bo
        set bo.name = newValue.name,
            bo.surface = newValue.surface,
            bo.city = newValue.city,
            bo.number_of_cabins = newValue.number_of_cabins,
            bo.floors = newValue.floors,
            bo.max_seats = newValue.max_seats,
            bo.price = newValue.price,
            bo.refCategory = newValue.refCategory,
            bo.bListRefReservations = newValue.bListRefReservations
        where bo.id = identifiant;
        return true;
    EXCEPTION
        WHEN OTHERS THEN
            raise;
    end;
    static function remove(identifiant Number) return boolean is
    begin
        DELETE FROM boats bo where bo.id = identifiant;
        -- todo : Suppression des objets avec une référence vers cet objet supprimer
        return true;
    EXCEPTION
        WHEN OTHERS THEN
            raise;
    end;
    member function getReservations return listRefReservations is
        refReservations listRefReservations := null;
    begin
        select bListRefReservations into refReservations from boats bo where bo.id = self.id;
        return refReservations;
    EXCEPTION
        WHEN OTHERS THEN
            raise;
    end;
    member procedure addLinkReservation(refReservation REF reservation) is
    begin
        insert into table ( select bListRefReservations from boats bo where bo.id = self.id )
        values (refReservation);
    EXCEPTION
        WHEN OTHERS THEN
            raise;
    end;
    member procedure deleteLinkReservation(refReservation REF reservation) is
    begin
        delete from table ( select bListRefReservations from boats bo where bo.id = self.id ) lbo
        where lbo.COLUMN_VALUE = refReservation;
    EXCEPTION
        WHEN OTHERS THEN
            raise;
    end;
    map member function compare return varchar2 is
    begin
        return self.NAME || self.ID;
    end;
end;
/

create or replace type body person as
    map member function compare return varchar2 is
    begin
        return self.NAME || self.ID;
    end;
end;
/

create or replace type body customer as
    static function findById(identifiant Number) return customer is
        c customer := null;
    begin
        SELECT value(cu) INTO c FROM customers cu WHERE cu.id = identifiant;
        return c;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            raise;
        WHEN OTHERS THEN
            raise;
    end;
    static function persist(c customer) return ref customer is
        refCustomer ref customer := null;
    begin
        insert into customers cu values c returning ref(cu) into refCustomer;
        return refCustomer;
    EXCEPTION
        WHEN OTHERS THEN
            raise;
    end;
    static function change(identifiant Number, newValue customer) return boolean is
    begin
        UPDATE customers cu
        set cu.name = newValue.name,
            cu.surname = newValue.surname,
            cu.telephone = newValue.telephone,
            cu.email = newValue.email,
            cu.cListRefReservations = newValue.cListRefReservations
        where cu.id = identifiant;
        return true;
    EXCEPTION
        WHEN OTHERS THEN
            raise;
    end;
    static function remove(identifiant Number) return boolean is
    begin
        DELETE FROM customers cu where cu.id = identifiant;
        -- todo : Suppression des objets avec une référence vers cet objet supprimer
        return true;
    EXCEPTION
        WHEN OTHERS THEN
            raise;
    end;
    member function getReservations return listRefReservations is
        refReservations listRefReservations := null;
    begin
        select cListRefReservations into refReservations from customers cu where cu.id = self.id;
        return refReservations;
    EXCEPTION
        WHEN OTHERS THEN
            raise;
    end;
    member procedure addLinkReservation(refReservation REF reservation) is
    begin
        insert into table ( select cListRefReservations from customers cu where cu.id = self.id )
        values (refReservation);
    EXCEPTION
        WHEN OTHERS THEN
            raise;
    end;
    member procedure deleteLinkReservation(refReservation REF reservation) is
    begin
        delete from table ( select cListRefReservations from customers cu where cu.id = self.id ) lbo
        where lbo.COLUMN_VALUE = refReservation;
    EXCEPTION
        WHEN OTHERS THEN
            raise;
    end;
    member function getUsedBoat return listRefBoats is
        refBoats listRefBoats := listRefBoats();
        lrf listRefBoats;
        refReservations listRefReservations;
        indice number(8) := 0;
    begin
        select cu.cListRefReservations into refReservations from customers cu where cu.id = self.id;
        if refReservations.count > 0 then
            for i in refReservations.first..refReservations.last
                loop
                    select rListRefBoats into lrf from reservations re where ref(re) = refReservations(i);
                    if lrf.count > 0 then
                        for j in lrf.first..lrf.last
                            loop
                                refBoats.extend(1);
                                indice := indice + 1;
                                refBoats(indice) := lrf(j);
                            end loop;
                    end if;

                end loop;
        end if;
        return refBoats;  -- todo: get distinct
    end;
end;
/

create or replace type body pilot as
    static function findById(identifiant Number) return pilot is
        p pilot := null;
    begin
        SELECT value(pi) INTO p FROM pilots pi WHERE pi.id = identifiant;
        return p;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            raise;
        WHEN OTHERS THEN
            raise;
    end;
    static function persist(p pilot) return ref pilot is
        refPilot ref pilot := null;
    begin
        insert into pilots pi values p returning ref(pi) into refPilot;
        return refPilot;
    EXCEPTION
        WHEN OTHERS THEN
            raise;
    end;
    static function change(identifiant Number, newValue pilot) return boolean is
    begin
        UPDATE pilots pi
        set pi.name = newValue.name,
            pi.surname = newValue.surname,
            pi.telephone = newValue.telephone,
            pi.email = newValue.email,
            pi.licence = newValue.licence,
            pi.pListRefReservations = newValue.pListRefReservations
        where pi.id = identifiant;
        return true;
    EXCEPTION
        WHEN OTHERS THEN
            raise;
    end;
    static function remove(identifiant Number) return boolean is
    begin
        DELETE FROM pilots pi where pi.id = identifiant;
        -- todo : Suppression des objets avec une référence vers cet objet supprimer
        return true;
    EXCEPTION
        WHEN OTHERS THEN
            raise;
    end;
    member function getReservations return listRefReservations is
        refReservations listRefReservations := null;
    begin
        select pListRefReservations into refReservations from pilots po where po.id = self.id;
        return refReservations;
    EXCEPTION
        WHEN OTHERS THEN
            raise;
    end;
    member procedure addLinkReservation(refReservation REF reservation) is
    begin
        insert into table ( select pListRefReservations from pilots po where po.id = self.id )
        values (refReservation);
    EXCEPTION
        WHEN OTHERS THEN
            raise;
    end;
    member procedure deleteLinkReservation(refReservation REF reservation) is
    begin
        delete from table ( select pListRefReservations from pilots po where po.id = self.id ) lbo
        where lbo.COLUMN_VALUE = refReservation;
    EXCEPTION
        WHEN OTHERS THEN
            raise;
    end;
    member function getPilotedBoats return listRefBoats is
        refBoats listRefBoats := listRefBoats();
        lrf listRefBoats;
        refReservations listRefReservations;
        indice number(8) := 0;
    begin
        select po.pListRefReservations into refReservations from pilots po where po.id = self.id;
        if refReservations.count > 0 then
            for i in refReservations.first..refReservations.last
                loop
                    select rListRefBoats into lrf from reservations re where ref(re) = refReservations(i);
                    if lrf.count > 0 then
                        for j in lrf.first..lrf.last
                            loop
                                refBoats.extend(1);
                                indice := indice + 1;
                                refBoats(indice) := lrf(j);
                            end loop;
                    end if;

                end loop;
        end if;
        return refBoats;  -- todo: get distinct
    end;
end;
/

create or replace type body reservation as
    static function findById(identifiant Number) return reservation is
        r reservation := null;
    begin
        SELECT value(re) INTO r FROM reservations re WHERE re.id = identifiant;
        return r;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            raise;
        WHEN OTHERS THEN
            raise;
    end;
    static function persist(r reservation) return ref reservation is
        refReservaton ref reservation := null;
    begin
        insert into reservations re values r returning ref(re) into refReservaton;
        return refReservaton;
    EXCEPTION
        WHEN OTHERS THEN
            raise;
    end;
    static function change(identifiant Number, newValue reservation) return boolean is
    begin
        null;
    end;
    static function remove(identifiant Number) return boolean is
    begin
        DELETE FROM reservations re where re.id = identifiant;
        -- todo : Suppression des objets avec une référence vers cet objet supprimer
        return true;
    EXCEPTION
        WHEN OTHERS THEN
            raise;
    end;
    member procedure addLinkBoat(refboat REF boat) is
    begin
        insert into table ( select rListRefBoats from reservations re where re.id = self.id )
        values (refboat);
    EXCEPTION
        WHEN OTHERS THEN
            raise;
    end;
    member procedure deleteLinkBoat(refBoat REF boat) is
    begin
        delete from table ( select rListRefBoats from reservations re where re.id = self.id ) lbo
        where lbo.COLUMN_VALUE = refboat;
    EXCEPTION
        WHEN OTHERS THEN
            raise;
    end;
    member procedure addLinkCustomer(refCustomer REF customer) is
    begin
        insert into table ( select rListRefCustomers from reservations re where re.id = self.id )
        values (refCustomer);
    EXCEPTION
        WHEN OTHERS THEN
            raise;
    end;
    member procedure deleteLinkCustomer(refCustomer REF customer) is
    begin
        delete from table ( select rListRefCustomers from reservations re where re.id = self.id ) lbo
        where lbo.COLUMN_VALUE = refCustomer;
    EXCEPTION
        WHEN OTHERS THEN
            raise;
    end;
    member procedure addLinkPilot(refPilot REF pilot) is
    begin
        insert into table ( select rListRefPilots from reservations re where re.id = self.id )
        values (refPilot);
    EXCEPTION
        WHEN OTHERS THEN
            raise;
    end;
    member procedure deleteLinkPilot(refPilot REF pilot) is
    begin
        delete from table ( select rListRefPilots from reservations re where re.id = self.id ) lbo
        where lbo.COLUMN_VALUE = refPilot;
    EXCEPTION
        WHEN OTHERS THEN
            raise;
    end;
    map member function compare return varchar2 is
    begin
        return self.id; -- todo: change this
    end;
end;
/

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
commit;

---------------------------------
-- Script de test des méthodes --
---------------------------------

-- Test de la méthode pour récupérer tous les bateaux utilisés par un client
-- Précondition : exécuter le script de création de l'ensemble de données
set serverout on;
declare
    c customer:=null;
    refCustomer ref customer;
    refBoats listRefBoats;
    b boat;
begin
    c := customer.findById(1);
    refBoats := c.getUsedBoat();
    dbms_output.put_line('Liste des bateaux utlisé par le client 1');
    if refBoats.count > 0 then
        for i in refBoats.first..refBoats.last
            loop
                UTL_REF.SELECT_OBJECT(refBoats(i), b);
                dbms_output.put_line('name '||b.name);
            end loop;
    end if;
end;
/

-- Test de la méthode pour récupérer tous les bateaux conduit par un pilote
-- Précondition : exécuter le script de création de l'ensemble de données
set serverout on;
declare
    p pilot:=null;
    refPilot ref pilot;
    refBoats listRefBoats;
    b boat;
begin
    p := pilot.findById(1);
    refBoats := p.getPilotedBoats();
    dbms_output.put_line('Liste des bateaux conduit par le pilote 1');
    if refBoats.count > 0 then
        for i in refBoats.first..refBoats.last
            loop
                UTL_REF.SELECT_OBJECT(refBoats(i), b);
                dbms_output.put_line('name '||b.name);
            end loop;
    end if;
end;
/
---------------------------------------------------------------------------------------------
-- Script de consultation, mise à jour et suppression impliquants 1, 2 ou plusieurs tables --
---------------------------------------------------------------------------------------------
/*
    Update

    1 table
*/
-- cette requête remplace le nom de la ville du bateau par id=3
UPDATE boats
SET city = 'Cagnes-sur-mer'
WHERE id=3

-- cette requête remplace le statut de réservation par id=7
UPDATE reservations
SET state_of_reservation='Paid'
WHERE id=7


/*
    2 tables
*/

-- cette requête remplace la ville pour les bateaux de la catégorie ‘Yacht’
UPDATE boats b
SET b.city='Monaco'
WHERE EXISTS (
              SELECT 1
              FROM categories c
              WHERE b.refCategory.name = c.name AND c.name='Yacht'
          );

-- cette requête remplace le coût par 10000 pour les bateaux de la catégorie Barge dont le coût est inférieur à 8000
UPDATE boats b
SET b.price=10000
WHERE EXISTS (
              SELECT 1
              FROM categories c
              WHERE b.refCategory.name = c.name AND c.name='Barge' AND b.price<8000
          );

/*
Suppression

    1 table
*/
-- cette requête supprime la ligne où id=1
DELETE
FROM boats
WHERE id=1

-- cette requête supprime la ligne où la personne a un nom=THOMLER
DELETE
FROM customers
WHERE name='THOMLER'


/*
    2 tables
*/
-- cette requête supprime les lignes avec les bateaux de la catégorie Yacht
DELETE
FROM boats b
WHERE EXISTS (
              SELECT 1
              FROM categories c
              WHERE b.refCategory.name = c.name AND c.name='Yacht'
          );

-- cette requête supprime les lignes avec les bateaux de la catégorie Canoe dont le prix est supérieur à 100
DELETE
FROM boats b
WHERE EXISTS (
              SELECT 1
              FROM categories c
              WHERE b.refCategory.name = c.name AND c.name='Canoe' AND b.price>100
          );

/*

Consultation

    1 table
*/
-- cette requête affiche tous les noms de catégories
select name from categories;

-- cette requête affiche le nombre de bateaux dans chaque ville
select city, count(*) from boats group by city;

-- cette requête affiche id, le nom du bateau et son prix par ordre croissant de prix
select id, name, price from boats order by price;

-- cette requête affiche id, date de début et de fin de réservation pour les réservations payantes
select id, start_date, end_date from reservations where state_of_reservation='Paid';

-- cette requête affiche id et les noms des bateaux adaptés aux groupes de 4 personnes
select id, name from boats where max_seats>=4;

/*
    2 tables
*/
-- cette requête affiche du nom de la catégorie du bateau 1
select bo.refCategory.name from boats bo where bo.id=1;

-- cette requête affiche les noms des bateaux et les noms de leurs catégories respectives
SELECT b.name, c.name as category_name
FROM boats b
         LEFT OUTER JOIN categories c
                         ON b.refCategory.name = c.name;

-- cette requête affiche les noms des bateaux de la catégorie Yacht
SELECT b.name
FROM boats b
         INNER JOIN categories c ON b.refCategory.name = c.name
WHERE c.name='Yacht';

-- cette requête affiche les noms des catégories de bateaux et leur nombre total par catégorie
SELECT c.name as category_name, COUNT(b.id) as count_boats
FROM boats b
         INNER JOIN categories c
                    ON b.refCategory.name = c.name
GROUP BY c.name;

-- cette requête affiche les noms des bateaux, leur catégorie type et prix par ordre de prix décroissant
SELECT b.name, c.name as category_name, b.price
FROM boats b
         INNER JOIN categories c
                    ON b.refCategory.name = c.name
ORDER BY b.price DESC;

---------------------------------
-- Script de test des méthodes --
---------------------------------
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
    b := BOAT(1, 'Serendipity', 30.5, 'Nice', 3, 1, 5, 3000, refCategory, listRefReservations());
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
    b boat := null;
    b2 boat := null;
    refBoat ref boat := null;
    c category := null;
    refCategory ref category := null;
    r boolean := null;
    refReservation ref reservation := null;
    refReservations listRefReservations := listRefReservations();
begin
    delete from boats;
    SELECT ref(ca) into refCategory FROM categories ca; -- selection d'une catégorie au hasard
    b:=boat(1, '1Serendipity', 30.5, 'Nice', 3, 1, 5, 3000, refCategory, listRefReservations());
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
