/*
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



/*
    2+ tables
*/

-- 