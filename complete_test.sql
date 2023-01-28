
-- insertion categories
set serveroutput on
declare
    refCategory ref CATEGORY := null;
begin
    -- insertion des objets
    delete from categories;
    refCategory:=CATEGORY.persist(Category(1, 'Barge', listRefBoats()));
    refCategory:=CATEGORY.persist(Category(2, 'Battleship', listRefBoats()));
    refCategory:=CATEGORY.persist(Category(3, 'Boat', listRefBoats()));
    refCategory:=CATEGORY.persist(Category(4, 'Canoe', listRefBoats()));
    refCategory:=CATEGORY.persist(Category(5, 'Catamaran', listRefBoats()));
    refCategory:=CATEGORY.persist(Category(6, 'Destroyer', listRefBoats()));
    refCategory:=CATEGORY.persist(Category(7, 'Ferry', listRefBoats()));
    refCategory:=CATEGORY.persist(Category(8, 'Gondola', listRefBoats()));
    refCategory:=CATEGORY.persist(Category(9, 'Hovercraft', listRefBoats()));
    refCategory:=CATEGORY.persist(Category(10, 'Sailboat', listRefBoats()));
    refCategory:=CATEGORY.persist(Category(11, 'Schooner', listRefBoats()));
    refCategory:=CATEGORY.persist(Category(12, 'Ship', listRefBoats()));
    refCategory:=CATEGORY.persist(Category(13, 'Trawler', listRefBoats()));
    refCategory:=CATEGORY.persist(Category(14, 'Yacht', listRefBoats()));

end;
/
select * from categories;


-- tinsertion boats
set serveroutput on
declare
    b boat :=null;
    refBoat ref boat := null;
    c category := null;
    refCategory ref CATEGORY := null;
begin
    delete from boats;
    SELECT ref(ca) into refCategory FROM categories ca; -- selection d'une catégorie au hasard

    refBoat:=boat.persist(boat(1, 'Serendipity', 30.5, 'Nice', 3, 1, 5, 3000, refCategory, listRefReservations()));
    UTL_REF.SELECT_OBJECT(refCategory, c);
    c.ADDBOAT(refBoat); -- ajouter le bateau dans la catégorie
    
    refBoat:=boat.persist(boat(2, 'Imagination', 60, 'Nice', 4, 2, 8, 4200, refCategory, listRefReservations()));
    UTL_REF.SELECT_OBJECT(refCategory, c);
    c.ADDBOAT(refBoat);

    refBoat:=boat.persist(boat(3, 'Liberty', 10, 'Nice', 1, 1, 2, 1200, refCategory, listRefReservations()));
    UTL_REF.SELECT_OBJECT(refCategory, c);
    c.ADDBOAT(refBoat);

    refBoat:=boat.persist(boat(4, 'Wanderlust', 20, 'Cannes', 2, 1, 3, 2400, refCategory, listRefReservations()));
    UTL_REF.SELECT_OBJECT(refCategory, c);
    c.ADDBOAT(refBoat);

    refBoat:=boat.persist(boat(5, 'Gale', 25, 'Nice', 2, 1, 4, 2310, refCategory, listRefReservations()));
    UTL_REF.SELECT_OBJECT(refCategory, c);
    c.ADDBOAT(refBoat);

    refBoat:=boat.persist(boat(6, 'Zephyr', 29, 'Cannes', 2, 1, 4, 3500, refCategory, listRefReservations()));
    UTL_REF.SELECT_OBJECT(refCategory, c);
    c.ADDBOAT(refBoat);

    refBoat:=boat.persist(boat(7, 'Sapphire', 40, 'Antibes', 3, 2, 8, 3600, refCategory, listRefReservations()));
    UTL_REF.SELECT_OBJECT(refCategory, c);
    c.ADDBOAT(refBoat);

    refBoat:=boat.persist(boat(8, 'Amazonite', 9, 'Nice', 1, 1, 2, 200, refCategory, listRefReservations()));
    UTL_REF.SELECT_OBJECT(refCategory, c);
    c.ADDBOAT(refBoat);

    refBoat:=boat.persist(boat(9, 'Atlantis', 4, 'Antibes', 1, 1, 1, 150, refCategory, listRefReservations()));
    UTL_REF.SELECT_OBJECT(refCategory, c);
    c.ADDBOAT(refBoat);

    refBoat:=boat.persist(boat(10, 'Leviathan', 24, 'Cannes', 2, 1, 4, 3100, refCategory, listRefReservations()));
    UTL_REF.SELECT_OBJECT(refCategory, c);
    c.ADDBOAT(refBoat);

    refBoat:=boat.persist(boat(11, 'Noah', 22, 'Antibes', 2, 1, 4, 2500, refCategory, listRefReservations()));
    UTL_REF.SELECT_OBJECT(refCategory, c);
    c.ADDBOAT(refBoat);

    refBoat:=boat.persist(boat(12, 'Neptune', 58, 'Nice', 3, 2, 12, 4000, refCategory, listRefReservations()));
    UTL_REF.SELECT_OBJECT(refCategory, c);
    c.ADDBOAT(refBoat);

    refBoat:=boat.persist(boat(13, 'Wayfarer', 114, 'Nice', 5, 2, 24, 5500, refCategory, listRefReservations()));
    UTL_REF.SELECT_OBJECT(refCategory, c);
    c.ADDBOAT(refBoat);

    refBoat:=boat.persist(boat(14, 'Beauty', 120, 'Cannes', 5, 3, 30, 8500, refCategory, listRefReservations()));
    UTL_REF.SELECT_OBJECT(refCategory, c);
    c.ADDBOAT(refBoat);

    refBoat:=boat.persist(boat(15, 'Marquise', 14, 'Cannes', 1, 1, 4, 1000, refCategory, listRefReservations()));
    UTL_REF.SELECT_OBJECT(refCategory, c);
    c.ADDBOAT(refBoat);

    refBoat:=boat.persist(boat(16, 'Siren', 31, 'Antibes', 2, 1, 8, 3500, refCategory, listRefReservations()));
    UTL_REF.SELECT_OBJECT(refCategory, c);
    c.ADDBOAT(refBoat);

    refBoat:=boat.persist(boat(17, 'Leagues', 45, 'Nice', 3, 1, 8, 5500, refCategory, listRefReservations()));
    UTL_REF.SELECT_OBJECT(refCategory, c);
    c.ADDBOAT(refBoat);

    refBoat:=boat.persist(boat(18, 'Amethyst', 56, 'Nice',  3, 2, 12, 5800, refCategory, listRefReservations()));
    UTL_REF.SELECT_OBJECT(refCategory, c);
    c.ADDBOAT(refBoat);

    refBoat:=boat.persist(boat(19, 'Cleopatra', 2, 'Nice', 1, 1, 1, 130, refCategory, listRefReservations()));
    UTL_REF.SELECT_OBJECT(refCategory, c);
    c.ADDBOAT(refBoat);

    refBoat:=boat.persist(boat(20, 'Titan', 10, 'Antibes', 1, 1, 2, 180, refCategory, listRefReservations()));
    UTL_REF.SELECT_OBJECT(refCategory, c);
    c.ADDBOAT(refBoat);

end;
/
select * from boats;

