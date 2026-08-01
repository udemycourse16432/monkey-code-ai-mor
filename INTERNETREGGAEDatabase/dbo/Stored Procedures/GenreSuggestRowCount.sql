














CREATE PROCEDURE [dbo].[GenreSuggestRowCount]
@Text nvarchar(255)
AS
BEGIN
 select count(distinct Genre) as CountOfGenre
 from WebGenres
 where Genre like @Text
 and InStock='y'
END












