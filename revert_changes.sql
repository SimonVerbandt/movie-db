-- Revert Views
DROP VIEW IF EXISTS top_movies_per_genre CASCADE;
DROP VIEW IF EXISTS highest_rated_movies CASCADE;

-- Revert Triggers and Functions
DROP TRIGGER IF EXISTS review_score_trigger ON user_reviews;
DROP TRIGGER IF EXISTS log_movie_changes_trigger ON movies;

DROP FUNCTION IF EXISTS validate_review_score;
DROP FUNCTION IF EXISTS log_movie_changes;
DROP PROCEDURE IF EXISTS add_movie;
DROP FUNCTION IF EXISTS add_user_with_hashed_password;

-- Revert Tables
DROP TABLE IF EXISTS user_reviews CASCADE;
DROP TABLE IF EXISTS audit_log CASCADE;
DROP TABLE IF EXISTS movie_genres CASCADE;
DROP TABLE IF EXISTS roles CASCADE;
DROP TABLE IF EXISTS movies CASCADE;
DROP TABLE IF EXISTS crew CASCADE;
DROP TABLE IF EXISTS genres CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- Revert Sequences
DROP SEQUENCE IF EXISTS movie_id_seq;
DROP SEQUENCE IF EXISTS user_id_seq;
DROP SEQUENCE IF EXISTS review_id_seq;

-- Revert Roles
DROP ROLE IF EXISTS ADMIN;
DROP ROLE IF EXISTS CONTRIBUTOR;
DROP ROLE IF EXISTS API_ACCESS;
DROP USER IF EXISTS user1;
DROP USER IF EXISTS user2;

-- Revert Users
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'admin_user') THEN
        DROP USER admin_user;
    END IF;

    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'contributor_user') THEN
        DROP USER contributor_user;
    END IF;

    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'api_user') THEN
        DROP USER api_user;
    END IF;
END $$;
