USE anime_portfolio;
-- Results describe SYNTHETIC sample data only.

-- Series by primary genre
SELECT g.genre_name, COUNT(a.series_id) AS series_count FROM Genres g LEFT JOIN Anime_Series a ON a.genre_id=g.genre_id GROUP BY g.genre_id,g.genre_name ORDER BY series_count DESC,g.genre_name;

-- Studio output and mean score
SELECT s.studio_name, COUNT(a.series_id) AS series_count, ROUND(AVG(a.rating),2) AS average_rating FROM Studio s LEFT JOIN Anime_Series a ON a.studio_id=s.studio_id GROUP BY s.studio_id,s.studio_name ORDER BY series_count DESC,s.studio_name;

-- Highest rated series
SELECT title,rating,release_year FROM Anime_Series ORDER BY rating DESC,title LIMIT 5;

-- Episode coverage and runtime
SELECT a.title,a.status,COUNT(e.episode_id) AS stored_episodes,COALESCE(SUM(e.duration_minutes),0) AS runtime_minutes FROM Anime_Series a LEFT JOIN Episodes e ON e.series_id=a.series_id GROUP BY a.series_id,a.title,a.status ORDER BY stored_episodes DESC,a.title;

-- Actor workload across series
SELECT v.actor_name,COUNT(c.character_id) AS character_count,COUNT(DISTINCT c.series_id) AS series_count FROM Voice_Actor v LEFT JOIN Main_Character c ON c.actor_id=v.actor_id GROUP BY v.actor_id,v.actor_name ORDER BY character_count DESC,v.actor_name;

-- Cast directory
SELECT a.title,c.character_name,c.role,v.actor_name,v.language FROM Main_Character c JOIN Anime_Series a ON a.series_id=c.series_id JOIN Voice_Actor v ON v.actor_id=c.actor_id ORDER BY a.title,c.character_name;

-- Annual release trend
SELECT release_year,COUNT(*) AS series_count,ROUND(AVG(rating),2) AS average_rating FROM Anime_Series GROUP BY release_year ORDER BY release_year;

-- Rank within each genre
SELECT g.genre_name,a.title,a.rating,DENSE_RANK() OVER (PARTITION BY a.genre_id ORDER BY a.rating DESC) AS genre_rank FROM Anime_Series a JOIN Genres g ON g.genre_id=a.genre_id ORDER BY g.genre_name,genre_rank,a.title;

-- Series above overall mean score
SELECT title,rating FROM Anime_Series WHERE rating > (SELECT AVG(rating) FROM Anime_Series) ORDER BY rating DESC,title;

-- Episode number gaps; zero rows expected
SELECT series_id,COUNT(*) AS stored_count,MIN(episode_number) AS first_episode,MAX(episode_number) AS last_episode FROM Episodes GROUP BY series_id HAVING MIN(episode_number) <> 1 OR MAX(episode_number) <> COUNT(*);
