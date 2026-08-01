














create PROCEDURE [dbo].[AllLabels]

 @Offset int
,@Fetch int
,@SortBy nvarchar(20)

AS

if @SortBy='P'
 begin
  select Hint as Label, Total
  from WebSearchSuggestions 
  where SearchType='Label'
  order by Total desc,counter desc
  offset @Offset rows
  Fetch Next @Fetch Rows only
 end
else
 begin
  select Hint as Label, Total
  from WebSearchSuggestions 
  where SearchType='Label'
  order by Hint
  offset @Offset rows
  Fetch Next @Fetch Rows only
 end

















