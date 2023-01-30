
-- Test de la méthode statique findById de la classe category
DECLARE
l_category category;
BEGIN
l_category := category.findById(1);
-- Vérifiez si l_category est égal à la catégorie attendue avec l'identifiant 1
END;

-- Test de la méthode statique persist de la classe category
DECLARE
l_category category;
BEGIN
l_category := new category(1, 'Catégorie 1', null);
l_category := category.persist(l_category);
-- Vérifiez si l_category est égal à la catégorie persistée en base de données avec l'identifiant 1
END;

-- Test de la méthode statique change de la classe category
DECLARE
l_category category;
BEGIN
l_category := category.change(1, new category(1, 'Nouvelle catégorie', null));
-- Vérifiez si l_category est égal à la catégorie modifiée en base de données avec l'identifiant 1
END;

-- Test de la méthode statique remove de la classe category
DECLARE
l_result boolean;
BEGIN
l_result := category.remove(1);
-- Vérifiez si l_result est égal à true (catégorie supprimée avec succès) ou false (échec de suppression)
END;