-- Test adding a new movie
EXEC AddNewMovie('The Matrix', TO_DATE('1999-03-31', 'YYYY-MM-DD'), 136, 'A computer hacker learns from mysterious rebels about the true nature of his reality and his role in the war against its controllers.', 'Action,Science Fiction', SYS.ODCIVARCHAR2LIST('Keanu Reeves,Actor', 'Lana Wachowski,Director', 'Lilly Wachowski,Director'));

-- Test adding a review
INSERT INTO UserReviews (MovieID, UserID, Rating, ReviewText)
VALUES (100000, 100000, 9.5, 'An absolute classic!');

-- Test the views
SELECT * FROM TopMoviesByGenre;
SELECT * FROM HighestRatedMovies;
