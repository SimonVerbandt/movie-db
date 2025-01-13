UPDATE movies SET duration = 150 WHERE movie_id = 400000;
UPDATE user_reviews SET rating = 8.5 WHERE review_id = 700000;
UPDATE crew SET biography = 'A visionary actor & director' WHERE crew_id = 5;
UPDATE genres SET genre_name = 'Science Fiction' WHERE genre_id = 5;
UPDATE roles SET role_type = 'Director' WHERE role_id = 5;
-- Final Check: Ensure all data is as expected
SELECT * FROM movies;
SELECT * FROM genres;
SELECT * FROM movie_genres;
SELECT * FROM crew;
SELECT * FROM roles;
SELECT * FROM user_reviews;
SELECT * FROM audit_log;
