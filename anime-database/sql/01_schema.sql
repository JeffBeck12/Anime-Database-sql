-- MySQL 8.0.16+ / 8.4. Fresh installation; fails safely if tables already exist.
CREATE DATABASE IF NOT EXISTS anime_portfolio CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE anime_portfolio;

CREATE TABLE Studio (
  studio_id INT NOT NULL PRIMARY KEY,
  studio_name VARCHAR(100) NOT NULL,
  country VARCHAR(60) NOT NULL,
  UNIQUE (studio_name)
) ENGINE=InnoDB;

CREATE TABLE Genres (
  genre_id INT NOT NULL PRIMARY KEY,
  genre_name VARCHAR(50) NOT NULL,
  description VARCHAR(255) NOT NULL,
  UNIQUE (genre_name)
) ENGINE=InnoDB;

CREATE TABLE Anime_Series (
  series_id INT NOT NULL PRIMARY KEY,
  title VARCHAR(150) NOT NULL,
  studio_id INT NOT NULL,
  genre_id INT NOT NULL,
  release_year SMALLINT NOT NULL,
  rating DECIMAL(3,1) NOT NULL,
  status VARCHAR(20) NOT NULL,
  UNIQUE (title),
  CONSTRAINT chk_year CHECK (release_year BETWEEN 1900 AND 2100),
  CONSTRAINT chk_rating CHECK (rating BETWEEN 0 AND 10),
  CONSTRAINT chk_status CHECK (status IN ('Completed','Ongoing')),
  FOREIGN KEY (studio_id) REFERENCES Studio(studio_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  FOREIGN KEY (genre_id) REFERENCES Genres(genre_id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE Episodes (
  episode_id INT NOT NULL PRIMARY KEY,
  series_id INT NOT NULL,
  episode_number SMALLINT NOT NULL,
  title VARCHAR(150) NOT NULL,
  duration_minutes SMALLINT NOT NULL,
  air_date DATE NOT NULL,
  UNIQUE (series_id, episode_number),
  CONSTRAINT chk_episode CHECK (episode_number > 0),
  CONSTRAINT chk_duration CHECK (duration_minutes > 0),
  FOREIGN KEY (series_id) REFERENCES Anime_Series(series_id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE Voice_Actor (
  actor_id INT NOT NULL PRIMARY KEY,
  actor_name VARCHAR(100) NOT NULL,
  language VARCHAR(40) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE Main_Character (
  character_id INT NOT NULL PRIMARY KEY,
  series_id INT NOT NULL,
  actor_id INT NOT NULL,
  character_name VARCHAR(100) NOT NULL,
  role VARCHAR(20) NOT NULL,
  UNIQUE (series_id, character_name),
  CONSTRAINT chk_role CHECK (role IN ('Protagonist','Deuteragonist','Antagonist')),
  FOREIGN KEY (series_id) REFERENCES Anime_Series(series_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  FOREIGN KEY (actor_id) REFERENCES Voice_Actor(actor_id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB;

