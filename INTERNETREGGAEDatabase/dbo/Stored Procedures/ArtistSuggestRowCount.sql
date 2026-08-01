













CREATE PROCEDURE [dbo].[ArtistSuggestRowCount]
@Text nvarchar(255)
AS
BEGIN
 select count(counter) as CountOfArtist
 from WebSearchSuggestions
 where Hint like @Text +'%'
END











