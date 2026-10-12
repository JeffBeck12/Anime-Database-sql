# Data dictionary

All columns are NOT NULL and have no default. Integer keys are explicitly assigned, not AUTO_INCREMENT. All five foreign keys use RESTRICT for updates and deletes. Parent records must exist before insertion. InnoDB indexes foreign keys automatically; composite unique keys also support series lookups.

## Studio

| Column | MySQL type | Meaning / constraint |
|---|---|---|
| studio_id | INT | Primary key |
| studio_name | VARCHAR(100) | Unique fictional studio name |
| country | VARCHAR(60) | Studio country |

Additional constraints: UNIQUE (studio_name)

## Genres

| Column | MySQL type | Meaning / constraint |
|---|---|---|
| genre_id | INT | Primary key |
| genre_name | VARCHAR(50) | Unique primary genre |
| description | VARCHAR(255) | Genre description |

Additional constraints: UNIQUE (genre_name)

## Anime_Series

| Column | MySQL type | Meaning / constraint |
|---|---|---|
| series_id | INT | Primary key |
| title | VARCHAR(150) | Unique fictional title |
| studio_id | INT | Foreign key to Studio |
| genre_id | INT | Foreign key to Genres |
| release_year | SMALLINT | 1900 through 2100 |
| rating | DECIMAL(3,1) | Synthetic score, 0 through 10 |
| status | VARCHAR(20) | Completed or Ongoing |

Additional constraints: UNIQUE (title); CONSTRAINT chk_year CHECK (release_year BETWEEN 1900 AND 2100); CONSTRAINT chk_rating CHECK (rating BETWEEN 0 AND 10); CONSTRAINT chk_status CHECK (status IN ('Completed','Ongoing')); FOREIGN KEY (studio_id) REFERENCES Studio(studio_id) ON DELETE RESTRICT ON UPDATE RESTRICT; FOREIGN KEY (genre_id) REFERENCES Genres(genre_id) ON DELETE RESTRICT ON UPDATE RESTRICT

## Episodes

| Column | MySQL type | Meaning / constraint |
|---|---|---|
| episode_id | INT | Primary key |
| series_id | INT | Foreign key to Anime_Series |
| episode_number | SMALLINT | Positive sequence within series |
| title | VARCHAR(150) | Fictional episode title |
| duration_minutes | SMALLINT | Positive duration |
| air_date | DATE | Synthetic air date |

Additional constraints: UNIQUE (series_id, episode_number); CONSTRAINT chk_episode CHECK (episode_number > 0); CONSTRAINT chk_duration CHECK (duration_minutes > 0); FOREIGN KEY (series_id) REFERENCES Anime_Series(series_id) ON DELETE RESTRICT ON UPDATE RESTRICT

## Voice_Actor

| Column | MySQL type | Meaning / constraint |
|---|---|---|
| actor_id | INT | Primary key |
| actor_name | VARCHAR(100) | Fictional actor name; names need not be unique |
| language | VARCHAR(40) | Performance language |

Additional constraints: None beyond the primary key.

## Main_Character

| Column | MySQL type | Meaning / constraint |
|---|---|---|
| character_id | INT | Primary key |
| series_id | INT | Foreign key to Anime_Series |
| actor_id | INT | Foreign key to Voice_Actor |
| character_name | VARCHAR(100) | Unique within series |
| role | VARCHAR(20) | Protagonist, Deuteragonist, or Antagonist |

Additional constraints: UNIQUE (series_id, character_name); CONSTRAINT chk_role CHECK (role IN ('Protagonist','Deuteragonist','Antagonist')); FOREIGN KEY (series_id) REFERENCES Anime_Series(series_id) ON DELETE RESTRICT ON UPDATE RESTRICT; FOREIGN KEY (actor_id) REFERENCES Voice_Actor(actor_id) ON DELETE RESTRICT ON UPDATE RESTRICT

