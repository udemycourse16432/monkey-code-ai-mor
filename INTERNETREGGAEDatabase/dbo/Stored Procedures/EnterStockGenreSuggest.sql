


CREATE PROCEDURE [dbo].[EnterStockGenreSuggest]
 @Text nvarchar(255)

AS

select top 10 Genre,count(counter) as Qty from WebGenres
where Genre like @Text
group by Genre
order by Qty desc

