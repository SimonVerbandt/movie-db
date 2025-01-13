-- This script contains the configuration for the movie database with it's tables, triggers, default users, procedures and sequences
-- If the database does not exist, create it with the following commands (in psql shell):
-- CREATE DATABASE movie_db;
-- \c movie_db;

---------------------------------------------------------------------------
--                                                                       --
--          Sequences for movie_id, user_id, and review_id               --
--                                                                       --
---------------------------------------------------------------------------

CREATE SEQUENCE user_id_seq START 100000;
CREATE SEQUENCE movie_id_seq START 400000;
CREATE SEQUENCE review_id_seq START 700000;

---------------------------------------------------------------------------
--                                                                       --
--                  Tables for the Movie database                        --
--                                                                       --
---------------------------------------------------------------------------

CREATE TABLE users (
    user_id INT PRIMARY KEY DEFAULT nextval('user_id_seq'),
    username VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL
);

CREATE TABLE genres (
    genre_id SERIAL PRIMARY KEY,
    genre_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE crew (
    crew_id SERIAL PRIMARY KEY,
    crew_name VARCHAR(255) NOT NULL,
    date_of_birth DATE,
    biography TEXT
);

CREATE TABLE movies (
    movie_id INT PRIMARY KEY DEFAULT nextval('movie_id_seq'),
    title VARCHAR(255) NOT NULL,
    release_date DATE,
    duration  INT,
    summary TEXT
);

CREATE TABLE roles (
    role_id SERIAL PRIMARY KEY,
    movie_id INT,
    crew_id INT,
    role_type VARCHAR(100) NOT NULL,
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id) ON DELETE CASCADE,
    FOREIGN KEY (crew_id) REFERENCES crew(crew_id) ON DELETE CASCADE
);

CREATE TABLE movie_genres (
    movie_id INT,
    genre_id INT,
    PRIMARY KEY (movie_id, genre_id),
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id) ON DELETE CASCADE,
    FOREIGN KEY (genre_id) REFERENCES genres(genre_id) ON DELETE CASCADE
);

CREATE TABLE user_reviews (
    review_id INT PRIMARY KEY DEFAULT nextval('review_id_seq'),
    movie_id INT,
    user_id INT,
    rating NUMERIC CHECK (rating BETWEEN 1 AND 10),
    review_text TEXT,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE audit_log (
    log_id SERIAL PRIMARY KEY,
    movie_id INT,
    action VARCHAR(100),
    changed_by VARCHAR(100),
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

---------------------------------------------------------------------------
--                                                                       --
--               User Management for the Movie database                  --
--                                                                       --
---------------------------------------------------------------------------

-- Create new user with hashed password (normally, passwords are hashed automatically with the algorithm as stated 
-- in password_encryption value in postgresql.conf). This procedure is located here and not in the procedures 
-- section because it is used to create the default users
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE OR REPLACE FUNCTION add_user_with_hashed_password(
    p_Username VARCHAR,
    p_Password VARCHAR
) RETURNS VOID AS $$
DECLARE 
    v_HashedPassword VARCHAR;
BEGIN
    v_HashedPassword := crypt(p_Password, gen_salt('bf'));
    EXECUTE format('CREATE USER %I WITH PASSWORD %L', p_Username, p_Password);
    INSERT INTO users (username, password) VALUES (p_Username, v_HashedPassword);
END;
$$ LANGUAGE plpgsql;

-- Create roles
CREATE ROLE ADMIN;
CREATE ROLE CONTRIBUTOR;
CREATE ROLE API_ACCESS;

-- Create users through add_user_with_hashed_password function
SELECT add_user_with_hashed_password('admin_user', 'admin_password');
SELECT add_user_with_hashed_password('contributor_user', 'contributor_password');
SELECT add_user_with_hashed_password('api_user', 'api_password');

-- Grant roles to users
GRANT ADMIN TO admin_user;
GRANT CONTRIBUTOR TO contributor_user;
GRANT API_ACCESS TO api_user;

-- Set default roles
ALTER ROLE admin_user SET ROLE ADMIN;
ALTER ROLE contributor_user SET ROLE CONTRIBUTOR;
ALTER ROLE api_user SET ROLE API_ACCESS;

-- Grant privileges to roles
GRANT SELECT, INSERT, UPDATE, DELETE ON movies TO ADMIN, CONTRIBUTOR;
GRANT SELECT, INSERT, UPDATE, DELETE ON crew TO ADMIN, CONTRIBUTOR;
GRANT SELECT, INSERT, UPDATE, DELETE ON genres TO ADMIN, CONTRIBUTOR;
GRANT SELECT, INSERT, UPDATE, DELETE ON roles TO ADMIN, CONTRIBUTOR;
GRANT SELECT, INSERT, UPDATE, DELETE ON user_reviews TO ADMIN, CONTRIBUTOR;
GRANT SELECT ON movies TO API_ACCESS;
GRANT SELECT ON genres TO API_ACCESS;
---------------------------------------------------------------------------
--                                                                       --
--                  Views for the Movie database                         --
--                                                                       --
---------------------------------------------------------------------------

-- Top movies per genre view
CREATE OR REPLACE VIEW top_movies_per_genre AS
SELECT g.genre_name, m.title, AVG(r.rating) AS average_rating
FROM movies m
JOIN movie_genres mg ON m.movie_id = mg.movie_id
JOIN genres g ON mg.genre_id = g.genre_id
JOIN user_reviews r ON m.movie_id = r.movie_id
GROUP BY g.genre_name, m.title
ORDER BY g.genre_name, average_rating DESC;

-- Highest rated movies view
CREATE OR REPLACE VIEW highest_rated_movies AS
SELECT m.title, AVG(r.rating) AS average_rating
FROM movies m
JOIN user_reviews r ON m.movie_id = r.movie_id
GROUP BY m.title
ORDER BY average_rating DESC;

---------------------------------------------------------------------------
--                                                                       --
--                  Procedures for the Movie database                    --
--                                                                       --
---------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE add_movie(
    p_Title VARCHAR,
    p_ReleaseDate DATE,
    p_Duration INT,
    p_Summary TEXT,
    p_Genres TEXT[], 
    p_CrewMembers TEXT[][] 
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_MovieID INT;
    v_GenreID INT;
    v_CrewID INT;
    v_GenreName VARCHAR;
    v_Name VARCHAR;
    v_RoleType VARCHAR;
    i INT;
    crew_member TEXT[];
BEGIN
    -- Insert the new movie
    INSERT INTO movies (title, release_date, duration, summary)
    VALUES (p_Title, p_ReleaseDate, p_Duration, p_Summary)
    RETURNING movie_id INTO v_MovieID;

    -- Insert genres
    FOR i IN 1.. array_length(p_Genres, 1) LOOP
        v_GenreName := p_Genres[i];
        SELECT genre_id INTO v_GenreID FROM genres WHERE genre_name = v_GenreName;
        IF v_GenreID IS NULL THEN
            INSERT INTO genres (genre_name) VALUES (v_GenreName) RETURNING genre_id INTO v_GenreID;
        END IF;
        IF v_GenreID IS NOT NULL THEN
            INSERT INTO movie_genres (movie_id, genre_id) VALUES (v_MovieID, v_GenreID);
        END IF;
    END LOOP;

    -- Insert crew members and roles
    FOR i IN 1.. array_length(p_CrewMembers, 1) LOOP
            v_Name := p_CrewMembers[i][1];
            v_RoleType := p_CrewMembers[i][2];
            SELECT crew_id INTO v_CrewID FROM crew WHERE crew_name = v_Name;
            IF v_CrewID IS NULL THEN
                INSERT INTO crew (crew_name) VALUES (v_Name) RETURNING crew_id INTO v_CrewID;
                INSERT INTO roles (movie_id, crew_id, role_type) VALUES (v_MovieID, v_CrewID, v_RoleType);
            END IF;
    END LOOP;
END;
$$;

---------------------------------------------------------------------------
--                                                                       --
--                  Triggers for the Movie database                      --
--                                                                       --
---------------------------------------------------------------------------

-- Audit log trigger
CREATE OR REPLACE FUNCTION log_movie_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO audit_log (movie_id, action, changed_by) VALUES (NEW.movie_id, 'INSERT', CURRENT_USER);
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO audit_log (movie_id, action, changed_by) VALUES (NEW.movie_id, 'UPDATE', CURRENT_USER);
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO audit_log (movie_id, action, changed_by) VALUES (OLD.movie_id, 'DELETE', CURRENT_USER);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER log_movie_changes_trigger
AFTER INSERT OR UPDATE OR DELETE ON movies
FOR EACH ROW
EXECUTE FUNCTION log_movie_changes();

-- Rating validation trigger
CREATE OR REPLACE FUNCTION validate_review_score()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.rating < 1 OR NEW.rating > 10 THEN
        RAISE EXCEPTION 'Rating must be between 1 and 10';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER review_score_trigger
BEFORE INSERT OR UPDATE ON user_reviews
FOR EACH ROW
EXECUTE FUNCTION validate_review_score();