


create PROCEDURE [dbo].[spGetGenre]
 @Text nvarchar(255)

AS

select top 1 Genre from WebGenres
where Genre like @Text

