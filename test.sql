-- TESTS UNITAIRES
set serveroutput on
-- test du crud de catégorie
declare
    c CATEGORY := null;
    c2 CATEGORY := null;
    r boolean := null;
begin
    delete from categories;
    c:=Category(1, 'Navire', listRefBoats());
    c2:=Category(2, 'Cat 2', listRefBoats());
    -- insertion des deux objets
    r:=CATEGORY.persist(c);
    r:=CATEGORY.persist(c2);

    c2:=CATEGORY.findById(1);
    c2.ID:=2;
    c2.NAME:='update name';
    r:=CATEGORY.change(c2.id, c2);--remplacement du nom de la deuxième catégorie
    r:=Category.remove(c.id);--suppression du premier objet
    -- dbms_output.put_line('dname'||c.NAME);
end;
/
select * from categories;

-- INSERTION DE 20 OBJETS DE CHAQUE TYPE
-- insertion de