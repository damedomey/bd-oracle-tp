/*
    AMEDOMEY Roméo David :			, Activités paricipant1
    KOSTRYKINA Ekaterina :			, Activités paricipant2
*/
-- Suppression des types et tables
drop table categories cascade constraints;
drop table boats cascade constraints;
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

create or replace type category as object (
    id              number(8),
    name            varchar2(20),
    cListRefBoats   listRefBoats
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
    bListRefReservations listRefReservations
);
/
create or replace type tabPrenoms as varray(4) of varchar2(10);
/
create or replace type person as object(
    id              number(8),
    name            varchar2(20),
    surname         tabPrenoms,
    telephone       int(15),
    email           varchar2(150)
) not instantiable not final;
/
create or replace type customer under person(
    cListRefReservation listRefReservations
);
/
create or replace type pilot under person(
    licence         blob,
    pListRefReservation listRefReservations
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
    rListRefCustomers   listRefCustomers
);
/

-- Création des tables

create table categories of category (
    constraint pk_categories_id primary key(id),
    name constraint nnl_categories_name not null,
);
/
create table boats of boat(
    constraint pk_boats_id primary key(id)
);

-- Création des index
create unique index idx_categories_name on categories(name);

-- Création des scope pour chaque clé étranger
alter table categories add (scope for (cListRefBoats) is boats)

-- Contraintes supplémentaires

-- Implémentation des méthodes de chaque type
create or replace type body category as 
    member function save is return boolean
        begin
            null;
        end
end;
/



/* scope for

2.	Implémentation des types et tables objets
Le résultat de cette phase doit être mis dans un fichier appelé 
3Script_Implementation_type_tables_objet_NomProjet_Nom1_Nom2_Nom3_Nom4.sql
2.1	Création des types à partir du schéma de types
Proposer la création des types (partie spécification) avec l’ensembles des champs et des méthodes y compris les champs pour gérer les liens d’association.
2.2	Création des tables objets et des indexes à partir des types créés auparavant
Définir le schéma physique consiste à produire les ordres SQL de création des tables objets, indexes etc.. 
Si vous avez une base de données Oracle locale, il faut créer un utilisateur Oracle si ce n’est déjà fait ou utilser le compte Oracle qui vous a été fourni sur une base distante. Cet utilisateur sera le propriétaire de tous les objets de votre application (types, des tables objets, indexes, ...).

Vous devez aussi poser les indexes sur vos colonnes REF y compris dans les listes.
2.3	Insertion des lignes dans vos tables objets
Il s’agit d’effectuer manuellement des insertions de lignes dans chacunes de vos tables. Insérer 10 à 20 lignes par tables. Bien gérer les contraintes d’intégrités (primary key, check, non nul).
2.4	Mise à jour et consultation des données dans vos tables objets
Les requêtes de mise à jour (modification, suppression) et de consulatation à écrire sont celles définies dans le chapitre 1.
2.5	Implémentation des méthodes de vos types en PLSQL 
Il s’agit définir les types Body et d’implémenter le code des méthodes des types définis dans la spécification des types. 

Vous devez aussi proposer le code de test de chacune des méthodes.

2.6	Travail à rendre (04/01/2022)
Le travail à rendre doit être dans le fichier :
Script_Implementation_type_tables_objet_NomProjet_Nom1_Nom2_Nom3_Nom4.sql
Vous devez y mettre :
•	Création des types à partir du schéma de types
•	Création des tables objets et des indexes à partir des types créés auparavant
•	Insertion des lignes dans vos tables objets
•	Mise à jour et consultation des données dans vos tables objets
•	Implémentation des méthodes de vos types en PLSQL


*/