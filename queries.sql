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


-- 5- Selezionare i premi ricevuti da ogni software house per i videogiochi che ha prodotto (55)
SELECT awards.*, videogames.name AS videogame_name, software_houses.name AS software_house_name
FROM awards
INNER JOIN award_videogame
ON awards.id = award_videogame.award_id
INNER JOIN videogames
ON videogames.id = award_videogame.videogame_id
INNER JOIN software_houses
ON software_houses.id = videogames.software_house_id;


-- 6- Selezionare categorie e classificazioni PEGI dei videogiochi che hanno ricevuto recensioni da 4 e 5 stelle, mostrandole una sola volta (3363)

SELECT DISTINCT categories.id AS category, pegi_labels.id as PEGI, videogames.name AS videogame_name

FROM categories

INNER JOIN category_videogame
ON categories.id = category_videogame.category_id

INNER JOIN videogames
ON videogames.id = category_videogame.videogame_id

INNER JOIN pegi_label_videogame
ON videogames.id = pegi_label_videogame.videogame_id

INNER JOIN pegi_labels
ON pegi_labels.id = pegi_label_videogame.pegi_label_id

INNER JOIN reviews
ON videogames.id = reviews.videogame_id

WHERE reviews.rating >= 4


-- 7- Selezionare quali giochi erano presenti nei tornei nei quali hanno partecipato i giocatori il cui nome inizia per 'S' (474)
SELECT DISTINCT videogames.*
FROM players

INNER JOIN player_tournament
ON players.id = player_tournament.player_id

INNER JOIN tournaments
ON tournaments.id = player_tournament.tournament_id


INNER JOIN tournament_videogame
ON tournaments.id = tournament_videogame.tournament_id

INNER JOIN videogames
ON videogames.id = tournament_videogame.videogame_id

WHERE players.name LIKE 'S%'


-- 8- Selezionare le città in cui è stato giocato il gioco dell'anno del 2018 (36)
SELECT tournaments.city AS tournament_city
FROM awards

INNER JOIN award_videogame
ON awards.id = award_videogame.award_id

INNER JOIN videogames
ON videogames.id = award_videogame.videogame_id

INNER JOIN tournament_videogame
ON videogames.id = tournament_videogame.videogame_id

INNER JOIN tournaments
ON tournaments.id = tournament_videogame.tournament_id

WHERE awards.name = "gioco dell'anno"
AND award_videogame.year = 2018


-- 9- Selezionare i giocatori che hanno giocato al gioco più atteso del 2018 in un torneo del 2019 (991)

SELECT DISTINCT players.*
FROM awards

INNER JOIN award_videogame
ON awards.id = award_videogame.award_id

INNER JOIN videogames
ON videogames.id = award_videogame.videogame_id

INNER JOIN tournament_videogame
ON videogames.id = tournament_videogame.videogame_id

INNER JOIN tournaments
ON tournaments.id = tournament_videogame.tournament_id

INNER JOIN player_tournament
ON tournaments.id = player_tournament.tournament_id

INNER JOIN players
ON players.id = player_tournament.player_id

WHERE awards.name = 'gioco più atteso'
AND award_videogame.year = 2018
AND tournaments.year = 2019


