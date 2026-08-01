

CREATE PROCEDURE [dbo].[EnterStockArtistSuggest]
 @Text nvarchar(255)

AS

select top 10 Artist,count(counter) as Qty from WebArtists
where Artist like @Text
group by Artist
order by Qty desc
