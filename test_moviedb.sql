-- Test Script for Movie Database
-- Add Users
SELECT add_user_with_hashed_password('user1', 'password1');
SELECT add_user_with_hashed_password('user2', 'password2');
SELECT add_user_with_hashed_password('user3', 'password3');
SELECT add_user_with_hashed_password('user4', 'password4');

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

CALL add_movie(
    'Interstellar',
    '2014-11-07',
    169,
    'A group of astronauts travel through a wormhole in search of a new home for humanity.',
    ARRAY['Sci-Fi', 'Adventure'],
    ARRAY[
        ARRAY['Christopher Nolan', 'Director'],
        ARRAY['Matthew McConaughey', 'Actor'],
        ARRAY['Hans Zimmer', 'Composer']
    ]
);

CALL add_movie(
    'The Matrix',
    '1999-03-31',
    136,
    'A computer hacker learns about the true nature of reality and his role in the war against its controllers.',
    ARRAY['Sci-Fi', 'Action'],
    ARRAY[
        ARRAY['Lana Wachowski', 'Director'],
        ARRAY['Keanu Reeves', 'Actor'],
        ARRAY['Don Davis', 'Composer']
    ]
);

CALL add_movie(
    'Gladiator',
    '2000-05-05',
    155,
    'A betrayed Roman general seeks revenge against the corrupt emperor who murdered his family.',
    ARRAY['Action', 'Drama'],
    ARRAY[
        ARRAY['Ridley Scott', 'Director'],
        ARRAY['Russell Crowe', 'Actor'],
        ARRAY['Hans Zimmer', 'Composer']
    ]
);

CALL add_movie(
    'Titanic',
    '1997-12-19',
    195,
    'A love story unfolds aboard the ill-fated RMS Titanic.',
    ARRAY['Romance', 'Drama'],
    ARRAY[
        ARRAY['James Cameron', 'Director'],
        ARRAY['Leonardo DiCaprio', 'Actor'],
        ARRAY['James Horner', 'Composer']
    ]
);

CALL add_movie(
    'The Godfather',
    '1972-03-24',
    175,
    'The aging patriarch of an organized crime dynasty transfers control of his empire to his reluctant son.',
    ARRAY['Crime', 'Drama'],
    ARRAY[
        ARRAY['Francis Ford Coppola', 'Director'],
        ARRAY['Marlon Brando', 'Actor'],
        ARRAY['Nino Rota', 'Composer']
    ]
);

CALL add_movie(
    'Forrest Gump',
    '1994-07-06',
    142,
    'The story of a man with a low IQ who accomplishes great things in life despite his limitations.',
    ARRAY['Drama', 'Comedy'],
    ARRAY[
        ARRAY['Robert Zemeckis', 'Director'],
        ARRAY['Tom Hanks', 'Actor'],
        ARRAY['Alan Silvestri', 'Composer']
    ]
);

CALL add_movie(
    'Avengers: Endgame',
    '2019-04-26',
    181,
    'The Avengers assemble once more in order to reverse Thanos'' actions and restore balance to the universe.',
    ARRAY['Action', 'Sci-Fi'],
    ARRAY[
        ARRAY['Anthony Russo', 'Director'],
        ARRAY['Robert Downey Jr.', 'Actor'],
        ARRAY['Alan Silvestri', 'Composer']
    ]
);

CALL add_movie(
    'Jurassic Park',
    '1993-06-11',
    127,
    'A theme park showcasing cloned dinosaurs turns into chaos when the creatures break loose.',
    ARRAY['Adventure', 'Sci-Fi'],
    ARRAY[
        ARRAY['Steven Spielberg', 'Director'],
        ARRAY['Sam Neill', 'Actor'],
        ARRAY['John Williams', 'Composer']
    ]
);

CALL add_movie(
    'The Lion King',
    '1994-06-24',
    88,
    'A young lion prince flees his kingdom only to learn the true meaning of responsibility and bravery.',
    ARRAY['Animation', 'Drama'],
    ARRAY[
        ARRAY['Roger Allers', 'Director'],
        ARRAY['Matthew Broderick', 'Actor'],
        ARRAY['Hans Zimmer', 'Composer']
    ]
);

CALL add_movie(
    'Pulp Fiction',
    '1994-10-14',
    154,
    'The lives of two mob hitmen, a boxer, and others intertwine in a tale of violence and redemption.',
    ARRAY['Crime', 'Drama'],
    ARRAY[
        ARRAY['Quentin Tarantino', 'Director'],
        ARRAY['John Travolta', 'Actor'],
        ARRAY['Various Artists', 'Composer']
    ]
);

-- Add User Reviews
INSERT INTO user_reviews (movie_id, user_id, rating, review_text)
VALUES (400000, 100003, 9.0, 'Inception is a masterpiece!');
INSERT INTO user_reviews (movie_id, user_id, rating, review_text)
VALUES (400000, 100006, 10.0, 'Inception is a mind-bending journey that keeps you hooked.');
INSERT INTO user_reviews (movie_id, user_id, rating, review_text)
VALUES (400000, 100003, 8.5, 'A complex but highly rewarding film.');
INSERT INTO user_reviews (movie_id, user_id, rating, review_text)
VALUES (400000, 100004, 7.0, 'Good, but the dream layers were a bit confusing.');

INSERT INTO user_reviews (movie_id, user_id, rating, review_text)
VALUES (400001, 100003, 8.5, 'The Dark Knight is an incredible film.');
INSERT INTO user_reviews (movie_id, user_id, rating, review_text)
VALUES (400001, 100005, 10.0, 'The Joker is iconic! A perfect film.');
INSERT INTO user_reviews (movie_id, user_id, rating, review_text)
VALUES (400001, 100006, 9.0, 'Fantastic storytelling and action sequences.');
INSERT INTO user_reviews (movie_id, user_id, rating, review_text)
VALUES (400001, 100004, 8.0, 'A great movie, but a bit too long.');

INSERT INTO user_reviews (movie_id, user_id, rating, review_text)
VALUES (400002, 100006, 9.0, 'Stunning visuals and an emotional story.');
INSERT INTO user_reviews (movie_id, user_id, rating, review_text)
VALUES (400002, 100004, 8.0, 'An ambitious film with a few pacing issues.');
INSERT INTO user_reviews (movie_id, user_id, rating, review_text)
VALUES (400002, 100003, 10.0, 'One of the best science fiction movies of all time.');

INSERT INTO user_reviews (movie_id, user_id, rating, review_text)
VALUES (400005, 100006, 8.5, 'A visually stunning and emotional film.');
INSERT INTO user_reviews (movie_id, user_id, rating, review_text)
VALUES (400005, 100005, 7.0, 'Great production, but the story didn''t resonate with me.');
INSERT INTO user_reviews (movie_id, user_id, rating, review_text)
VALUES (400005, 100004, 9.5, 'A timeless love story with incredible performances.');

INSERT INTO user_reviews (movie_id, user_id, rating, review_text)
VALUES (400011, 100004, 10.0, 'Every scene in Pulp Fiction is unforgettable.');
INSERT INTO user_reviews (movie_id, user_id, rating, review_text)
VALUES (400011, 100005, 9.0, 'Quentin Tarantino''s masterpiece!');
INSERT INTO user_reviews (movie_id, user_id, rating, review_text)
VALUES (400011, 100006, 8.0, 'Great movie, but the nonlinear storytelling was confusing.');

-- Test validate_review_score trigger, through a test that should fail
DO $$
BEGIN
    INSERT INTO user_reviews (movie_id, user_id, rating, review_text)
    VALUES (400000, 100000, 11, 'Invalid rating should trigger exception');
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Caught exception: %', SQLERRM;
END;
$$;
