DELETE FROM movies WHERE movie_id = 400001;
DELETE FROM movies WHERE movie_id = 400002;
DELETE FROM movies WHERE movie_id = 400003;
DELETE FROM user_reviews WHERE review_id = 700001;
DELETE FROM user_reviews WHERE review_id = 700002;
DELETE FROM user_reviews WHERE review_id = 700003;
DELETE FROM crew WHERE crew_id = 1;
DELETE FROM crew WHERE crew_id = 2;
DELETE FROM crew WHERE crew_id = 3;
DELETE FROM genres WHERE genre_id = 5;
DELETE FROM genres WHERE genre_id = 6;
DELETE FROM genres WHERE genre_id = 7;

-- check tables
SELECT * FROM movies;
SELECT * FROM genres;
SELECT * FROM movie_genres;
SELECT * FROM crew;
SELECT * FROM roles;
SELECT * FROM user_reviews;
SELECT * FROM audit_log;

-- check views
SELECT * FROM top_movies_per_genre;
SELECT * FROM highest_rated_movies;