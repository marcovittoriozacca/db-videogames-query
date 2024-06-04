------------- SELECT -------------

-- 1- Selezionare tutte le software house americane (3)
SELECT * 
FROM software_houses
WHERE `country` = 'United States'


-- 2- Selezionare tutti i giocatori della città di 'Rogahnland' (2)
SELECT *
FROM players
WHERE `city` = 'Rogahnland'


-- 3- Selezionare tutti i giocatori il cui nome finisce per "a" (220)
SELECT * 
FROM players
WHERE `name` LIKE '%a'


-- 4- Selezionare tutte le recensioni scritte dal giocatore con ID = 800 (11)
SELECT * 
FROM reviews
WHERE `player_id` = 800


-- 5- Contare quanti tornei ci sono stati nell'anno 2015 (9)
SELECT `year`, COUNT(id)
FROM `tournaments`
WHERE `year` = 2015


-- 6- Selezionare tutti i premi che contengono nella descrizione la parola 'facere' (2)
SELECT * 
FROM `awards`
WHERE `description` LIKE '%facere%'


-- 7- Selezionare tutti i videogame che hanno la categoria 2 (FPS) o 6 (RPG), mostrandoli una sola volta (del videogioco vogliamo solo l'ID) (287)
SELECT DISTINCT `videogame_id`
FROM category_videogame
WHERE `category_id` = 2
OR `category_id` = 6


-- 8- Selezionare tutte le recensioni con voto compreso tra 2 e 4 (2947)
SELECT *
FROM reviews
WHERE `rating` >= 2
AND `rating` <= 4


-- 9- Selezionare tutti i dati dei videogiochi rilasciati nell'anno 2020 (46)
SELECT *
FROM videogames
WHERE YEAR(`release_date`) = 2020


-- 10- Selezionare gli id dei videogame che hanno ricevuto almeno una recensione da 5 stelle, mostrandoli una sola volta (443)
SELECT DISTINCT videogame_id
FROM reviews
WHERE `rating` = 5


------------- GROUP BY -------------

-- 1- Contare quante software house ci sono per ogni paese (3)
SELECT `country`, COUNT(id)
FROM software_houses
GROUP BY `country`


-- 2- Contare quante recensioni ha ricevuto ogni videogioco (del videogioco vogliamo solo l'ID) (500)
SELECT `videogame_id`, COUNT(id)
FROM reviews
GROUP BY `videogame_id`


-- 3- Contare quanti videogiochi hanno ciascuna classificazione PEGI (della classificazione PEGI vogliamo solo l'ID) (13)

SELECT pegi_label_id, COUNT(videogame_id) videogames_with_that_label
FROM pegi_label_videogame
GROUP BY pegi_label_id


-- 4- Mostrare il numero di videogiochi rilasciati ogni anno (11)
SELECT YEAR(`release_date`) AS year, COUNT(id) total_games_released
FROM videogames
GROUP BY year


-- 5- Contare quanti videogiochi sono disponbiili per ciascun device (del device vogliamo solo l'ID) (7)
SELECT `device_id` AS device, COUNT(videogame_id) AS total_videogames
FROM device_videogame
GROUP BY device


-- 6- Ordinare i videogame in base alla media delle recensioni (del videogioco vogliamo solo l'ID) (500)
SELECT `videogame_id`, ROUND(AVG(`rating`)) AS avg_rating
FROM reviews
GROUP BY `videogame_id`


------------- JOIN -------------

-- 1- Selezionare i dati di tutti giocatori che hanno scritto almeno una recensione, mostrandoli una sola volta (996)
SELECT DISTINCT players.*
FROM players
INNER JOIN reviews
ON players.id = reviews.player_id;


-- 2- Sezionare tutti i videogame dei tornei tenuti nel 2016, mostrandoli una sola volta (226)
SELECT DISTINCT videogames.*
FROM videogames
INNER JOIN tournament_videogame
ON `videogames`.id = `tournament_videogame`.videogame_id
INNER JOIN tournaments
ON `tournaments`.id = `tournament_videogame`.tournament_id
WHERE `year` = 2016


-- 3- Mostrare le categorie di ogni videogioco (1718)
SELECT categories.*
FROM videogames
INNER JOIN category_videogame
ON videogames.id = category_videogame.videogame_id
INNER JOIN categories
ON categories.id = category_videogame.category_id


-- 4- Selezionare i dati di tutte le software house che hanno rilasciato almeno un gioco dopo il 2020, mostrandoli una sola volta (6)
SELECT DISTINCT software_houses.*
FROM software_houses
INNER JOIN videogames
ON software_houses.id = videogames.software_house_id
WHERE YEAR(release_date) = 2020

