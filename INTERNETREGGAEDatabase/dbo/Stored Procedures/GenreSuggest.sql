














CREATE PROCEDURE [dbo].[GenreSuggest]
 @Text nvarchar(255)
,@Top nvarchar(5)

AS

exec ('select top '+@Top+' Hint as Genre, Total as Quantity
from WebSearchSuggestions 
where Hint like '''+@Text+'''
and SearchType=''Genre''
order by Total desc')



















