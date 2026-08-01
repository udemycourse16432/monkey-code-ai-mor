














CREATE PROCEDURE [dbo].[MoreGenres]

 @Offset int
,@Fetch int
,@SortBy nvarchar(20)

AS

if @SortBy='P'
 begin
  select Hint as Genre, Total
  from WebSearchSuggestions 
  where SearchType='Genre'
  order by Total desc,counter desc
  offset @Offset rows
  Fetch Next @Fetch Rows only
 end
else
 begin
  select Hint as Genre, Total
  from WebSearchSuggestions 
  where SearchType='Genre'
  order by Hint
  offset @Offset rows
  Fetch Next @Fetch Rows only
 end

















