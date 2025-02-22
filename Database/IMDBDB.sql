CREATE DATABASE IMDBDB;
USE IMDBDB;

CREATE SCHEMA foundation

CREATE TABLE foundation.Actors
(
Id int IDENTITY(1,1) PRIMARY KEY,
Name varchar(200) NOT NULL,
Sex varchar(6),
DOB date,
Bio varchar(max),
);

CREATE TABLE foundation.Producers
(
Id int IDENTITY(1,1) PRIMARY KEY,
Name varchar(200) NOT NULL,
Sex varchar(6),
DOB date,
Bio varchar(max),
);

CREATE TABLE foundation.Movies
(
Id int IDENTITY(1,1) PRIMARY KEY,
Name varchar(200) NOT NULL,
YearOfRelease int,
Plot varchar(max),
Poster varchar(max),
Producer varchar(200)
);

CREATE TABLE foundation.Genres
(
Id int IDENTITY(1,1) PRIMARY KEY,
Name varchar(200) NOT NULL 
);

CREATE TABLE foundation.Reviews
(
Id int IDENTITY(1,1) PRIMARY KEY,
Message varchar(200),
MovieId int NOT NULL
);


CREATE TABLE foundation.Actors_Movies
(
ActorId int NOT NULL FOREIGN KEY REFERENCES foundation.Actors(id),
MovieId int NOT NULL FOREIGN KEY REFERENCES foundation.Movies(id)
);

CREATE TABLE foundation.Genres_Movies
(
GenreId int NOT NULL FOREIGN KEY REFERENCES foundation.Genres(id),
MovieId int NOT NULL FOREIGN KEY REFERENCES foundation.Movies(id)
);

INSERT INTO foundation.Actors 
VALUES('Vijay','Male','1974-06-22','Vijay was born in a Tamil in Madras');

INSERT INTO foundation.Actors 
VALUES('Rashmika','Female','1996-04-05','Rashmika Mandanna is an Indian model and actress');

INSERT INTO foundation.Actors 
VALUES('Vishnu','Male','1978-02-01','Vishnu Vishal is an Indian Producer and Actor');

INSERT INTO foundation.Producers 
VALUES('Dil Raju','Male','1970-12-17','Dil Raju, is an Indian film producer');

INSERT INTO foundation.Producers 
VALUES('Vishnu','Male','1987-02-01','Vishnu Vishal is an Indian Producer and Actor');

INSERT INTO foundation.Movies 
VALUES('Varisu',2023,'About the movie','https://en.wikipedia.org/wiki/Varisu#/media/File:Varisu_poster.jpg','Dil Raju');

INSERT INTO foundation.Movies 
VALUES('Dear Comrade',2019,'About the movie','https://en.wikipedia.org/wiki/Dear_Comrade#/media/File:Dear_Comrade.jpg','Vishnu');

INSERT INTO foundation.Actors_Movies 
VALUES(1,1);

INSERT INTO foundation.Actors_Movies 
VALUES(2,1);

INSERT INTO foundation.Actors_Movies 
VALUES(1,2);

INSERT INTO foundation.Actors_Movies 
VALUES(1,3);


INSERT INTO foundation.Genres 
VALUES('Horror');

INSERT INTO foundation.Genres 
VALUES('Action');

INSERT INTO foundation.Reviews
VALUES('Message 1',1);

INSERT INTO foundation.Reviews
VALUES('Message 1',2);

INSERT INTO foundation.Genres_Movies 
VALUES(1,1);

INSERT INTO foundation.Genres_Movies 
VALUES(2,2);

CREATE PROCEDURE usp_AddMovie @Name VARCHAR(200)
	,@YearOfRelease INT
	,@Plot VARCHAR(max)
	,@Producer VARCHAR(200)
	,@CoverImage VARCHAR(max)
	,@ActorIds VARCHAR(max)
	,@GenreIds VARCHAR(max)
	,@MovieId INT OUTPUT
AS
BEGIN
	INSERT INTO foundation.Movies (
		NAME
		,YearOfRelease
		,Plot
		,Producer
		,Poster
		)
	VALUES (
		@Name
		,@YearOfRelease
		,@Plot
		,@Producer
		,@CoverImage
		)

	SET @MovieId = SCOPE_IDENTITY()

	INSERT INTO foundation.Actors_Movies (
		MovieId
		,ActorId
		)
	SELECT CAST(@MovieId AS INT) [MovieId]
		,CAST([value] AS INT) [ActorId]
	FROM string_split(@ActorIds, ',')

	INSERT INTO foundation.Genres_Movies (
		MovieId
		,GenreId
		)
	SELECT CAST(@MovieId AS INT) [MovieId]
		,CAST([value] AS INT) [GenreId]
	FROM string_split(@GenreIds, ',')
END

CREATE PROCEDURE usp_UpdateMovie @MovieId INT
	,@Name VARCHAR(200)
	,@YearOfRelease INT
	,@Plot VARCHAR(max)
	,@Producer VARCHAR(200)
	,@CoverImage VARCHAR(max)
	,@ActorIds VARCHAR(max)
	,@GenreIds VARCHAR(max)
AS
BEGIN
	UPDATE foundation.Movies
	SET Name = @Name
		,YearOfRelease = @YearOfRelease
		,Plot = @Plot
		,Producer = @Producer
		,Poster = @CoverImage
	WHERE Id = @MovieId

	DELETE
	FROM foundation.Actors_Movies
	WHERE MovieId = @MovieId

	DELETE
	FROM foundation.Genres_Movies
	WHERE MovieId = @MovieId

	INSERT INTO foundation.Actors_Movies (
		MovieId
		,ActorId
		)
	SELECT CAST(@MovieId AS INT) [MovieId]
		,CAST([value] AS INT) [ActorId]
	FROM string_split(@ActorIds, ',')

	INSERT INTO foundation.Genres_Movies (
		MovieId
		,GenreId
		)
	SELECT CAST(@MovieId AS INT) [MovieId]
		,CAST([value] AS INT) [GenreId]
	FROM string_split(@GenreIds, ',')
END

CREATE PROCEDURE usp_DeleteMovie @Id INT
AS
BEGIN
	DELETE
	FROM foundation.Actors_Movies
	WHERE MovieId = @Id;

	DELETE
	FROM foundation.Genres_Movies
	WHERE MovieId = @Id;

	DELETE
	FROM foundation.Reviews
	WHERE MovieId = @Id;

	DELETE
	FROM foundation.Movies
	WHERE Id = @Id;
END

CREATE PROCEDURE usp_DeleteActor @Id INT
AS
BEGIN
	DELETE
	FROM foundation.Actors_Movies
	WHERE ActorId = @Id;

	DELETE
	FROM foundation.Actors
	WHERE Id = @Id;
END


CREATE PROCEDURE usp_DeleteGenre @Id INT
AS
BEGIN
	DELETE
	FROM foundation.Genres_Movies
	WHERE GenreId = @Id;

	DELETE
	FROM foundation.Genres
	WHERE Id = @Id;
END

 


 select * from foundation.movies
