-- Test Script for Movie Database

-- Add Users
SELECT add_user_with_hashed_password('user1', 'password1');
SELECT add_user_with_hashed_password('user2', 'password2');
SELECT * FROM users;

-- Add Movies with Genres and Crew Members
CALL add_movie(
    'Inception',
    '2010-07-16',
    148,
    'A skilled thief, who steals secrets through dream-sharing technology, is given the chance to erase his past crimes.',
    ARRAY['Sci-Fi', 'Thriller'],
    ARRAY[
        ARRAY['Christopher Nolan', 'Director'],
        ARRAY['Leonardo DiCaprio', 'Actor'],
        ARRAY['Hans Zimmer', 'Composer']
    ]
);

CALL add_movie(
    'The Dark Knight',
    '2008-07-18',
    152,
    'Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.',
    ARRAY['Action', 'Drama'],
    ARRAY[
        ARRAY['Christopher Nolan', 'Director'],
        ARRAY['Christian Bale', 'Actor'],
        ARRAY['Hans Zimmer', 'Composer']
    ]
);

SELECT * FROM movies;
SELECT * FROM genres;
SELECT * FROM movie_genres;
SELECT * FROM crew;
SELECT * FROM roles;

-- Add User Reviews
INSERT INTO user_reviews (movie_id, user_id, rating, review_text)
VALUES (400000, 100000, 9.0, 'Inception is a masterpiece!');

INSERT INTO user_reviews (movie_id, user_id, rating, review_text)
VALUES (400001, 100001, 8.5, 'The Dark Knight is an incredible film.');

SELECT * FROM user_reviews;

-- Check Views
SELECT * FROM top_movies_per_genre;
SELECT * FROM highest_rated_movies;

-- Test log_movie_changes trigger
UPDATE movies SET duration = 150 WHERE movie_id = 400000;
DELETE FROM movies WHERE movie_id = 400001;

SELECT * FROM audit_log;

-- Test validate_review_score trigger, through a test that should fail
DO $$
BEGIN
    INSERT INTO user_reviews (movie_id, user_id, rating, review_text)
    VALUES (400000, 100000, 11, 'Invalid rating should trigger exception');
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Caught exception: %', SQLERRM;
END;
$$;

-- Test valid review update
UPDATE user_reviews SET rating = 8.5 WHERE review_id = 700000;

-- Final Check: Ensure all data is as expected
SELECT * FROM movies;
SELECT * FROM genres;
SELECT * FROM movie_genres;
SELECT * FROM crew;
SELECT * FROM roles;
SELECT * FROM user_reviews;
SELECT * FROM audit_log;
