/*
    AMEDOMEY Roméo David :			, Activités paricipant1
    KOSTRYKINA Ekaterina :			, Activités paricipant2
*/
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
    member procedure deleteLinkReservation(refReservation REF reservation)
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
    member procedure deleteLinkReservation(refReservation REF reservation)
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

-- Implémentation des méthodes de chaque type
-- todo: suppression des clé étranger is danglin lors de la suppression d'un objet
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


-- Tests --
