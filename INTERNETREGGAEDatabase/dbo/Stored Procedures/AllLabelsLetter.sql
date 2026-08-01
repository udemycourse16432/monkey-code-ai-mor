






CREATE PROCEDURE [dbo].[AllLabelsLetter]

 @Fetch int
,@Letter nvarchar(1)

as
if @Letter='A'
 set @Letter='-'

declare @StartRecord int

set @StartRecord=(
select top 1 count(Hint) over () as StartRecord from WebSearchSuggestions
where Hint<@Letter
and SearchType='Label'
order by Hint)

set @StartRecord=ISNULL(@StartRecord,0)+1
if @Letter='A' or @Letter='-'
 begin
  set  @StartRecord=1
 end

select Hint as Label,@StartRecord as StartRecord,Total from WebSearchSuggestions
where Hint>=@Letter
and SearchType='Label'
order by Hint
offset 0 rows
Fetch Next @Fetch Rows only











