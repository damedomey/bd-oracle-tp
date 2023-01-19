-- TESTS UNITAIRES
-- Précondition : Les tests ci-dessous sont des tests unitaires mais se basent sur les élements
--              des tests précédents (insertion). Donc il faut les exécuter dans l'ordre.

-- test du crud de catégorie
set serveroutput on
declare
    c CATEGORY := null;
    c2 CATEGORY := null;
    refCategory ref CATEGORY := null;
    r boolean := null;
begin
    delete from categories;
    c:=Category(1, 'Navire', listRefBoats());
    c2:=Category(2, 'Cat 2', listRefBoats());
    -- insertion des deux objets
    refCategory:=CATEGORY.persist(c);
    refCategory:=CATEGORY.persist(c2);

    c2:=CATEGORY.findById(1);
    c2.ID:=2;
    c2.NAME:='update name';
    r:=CATEGORY.change(c2.id, c2);--remplacement du nom de la deuxième catégorie
    r:=Category.remove(c.id);--suppression du premier objet
    -- dbms_output.put_line('dname'||c.NAME);
end;
/
select * from categories;

-- test du crud de bateau
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
    b:=boat(1, 'hello', 2, 2, 2, 2, 2, 2, refCategory, listRefReservations());
    refBoat:=boat.persist(b);
    UTL_REF.SELECT_OBJECT(refCategory, c);
    c.ADDBOAT(refBoat); -- ajouter le bateau dans la catégorie
    -- todo: fix null value of boat in category
    b.id := 2;
    b.name := 'hello 2';
    refBoat := boat.persist(b); -- création d'un doublons avec un id différent
    b.name := 'update name';
    r := boat.change(b.id, b); -- mise à jour du doublons
    r := boat.remove(1); -- suppression du premier élément
end;
/
select * from boats;

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