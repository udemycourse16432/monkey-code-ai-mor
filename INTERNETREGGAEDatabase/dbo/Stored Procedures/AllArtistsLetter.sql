






CREATE PROCEDURE [dbo].[AllArtistsLetter]
 @Fetch int
,@Letter nvarchar(1)

as
if @Letter='A'
 set @Letter='-'

declare @StartRecord int

set @StartRecord=(
select top 1 count(*) over () as StartRecord
  from Inventory
  left join WebArtists on Inventory.ID=WebArtists.InventoryID
  where WebArtists.Artist is not null
  and inventory>0
  and WebArtists.Artist<@Letter
  group by WebArtists.Artist
  order by WebArtists.Artist)

  set @StartRecord=ISNULL(@StartRecord,0)+1
  if @Letter='A' or @Letter='-'
   begin
   set  @StartRecord=1
   end

  select WebArtists.Artist as Artist,count(WebArtists.Artist) as Total,@StartRecord as StartRecord
  from Inventory
  left join WebArtists on Inventory.ID=WebArtists.InventoryID
  where WebArtists.Artist is not null
  and inventory>0
  and Artist>=@Letter
  group by WebArtists.Artist
  order by WebArtists.Artist
  offset 0 rows
  Fetch Next @Fetch Rows only











