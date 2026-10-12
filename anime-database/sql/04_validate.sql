USE anime_portfolio;
-- Every orphan_count must be zero.
SELECT 'Anime_Series.studio_id' AS relationship,COUNT(*) AS orphan_count FROM Anime_Series c LEFT JOIN Studio p ON c.studio_id=p.studio_id WHERE p.studio_id IS NULL;
SELECT 'Anime_Series.genre_id' AS relationship,COUNT(*) AS orphan_count FROM Anime_Series c LEFT JOIN Genres p ON c.genre_id=p.genre_id WHERE p.genre_id IS NULL;
SELECT 'Episodes.series_id' AS relationship,COUNT(*) AS orphan_count FROM Episodes c LEFT JOIN Anime_Series p ON c.series_id=p.series_id WHERE p.series_id IS NULL;
SELECT 'Main_Character.series_id' AS relationship,COUNT(*) AS orphan_count FROM Main_Character c LEFT JOIN Anime_Series p ON c.series_id=p.series_id WHERE p.series_id IS NULL;
SELECT 'Main_Character.actor_id' AS relationship,COUNT(*) AS orphan_count FROM Main_Character c LEFT JOIN Voice_Actor p ON c.actor_id=p.actor_id WHERE p.actor_id IS NULL;

-- Expected sample counts.
SELECT 'Studio' AS table_name,COUNT(*) AS actual_count,4 AS expected_count FROM Studio
UNION ALL
SELECT 'Genres' AS table_name,COUNT(*) AS actual_count,5 AS expected_count FROM Genres
UNION ALL
SELECT 'Anime_Series' AS table_name,COUNT(*) AS actual_count,12 AS expected_count FROM Anime_Series
UNION ALL
SELECT 'Episodes' AS table_name,COUNT(*) AS actual_count,128 AS expected_count FROM Episodes
UNION ALL
SELECT 'Voice_Actor' AS table_name,COUNT(*) AS actual_count,8 AS expected_count FROM Voice_Actor
UNION ALL
SELECT 'Main_Character' AS table_name,COUNT(*) AS actual_count,36 AS expected_count FROM Main_Character;
