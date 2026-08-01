






CREATE PROCEDURE [dbo].[GenreArtistsLetter]
 @Text nvarchar(255)
,@Fetch int
,@Letter nvarchar(1)

as
if @Letter='A'
 set @Letter='-'

declare @StartRecord int

set @StartRecord=(
select top 1 count(*) over () as StartRecord
  from Inventory
  left join WebArtists on Inventory.ID=WebArtists.InventoryID
  where (Genre1=@Text or Genre2=@Text or Genre3=@Text or Genre4=@Text or Genre5=@Text or Genre6=@Text or Genre7=@Text or Genre8=@Text or Genre9=@Text)
  and WebArtists.Artist is not null
  and inventory>0
  and WebArtists.Artist<@Letter
  group by WebArtists.Artist
  order by WebArtists.Artist)

  set @StartRecord=ISNULL(@StartRecord,0)+1
  if @Letter='A' or @Letter='-'
   begin
   set  @StartRecord=1
   end

  select WebArtists.Artist as GenreArtist,count(WebArtists.Artist) as Total,@StartRecord as StartRecord
  from Inventory
  left join WebArtists on Inventory.ID=WebArtists.InventoryID
  where (Genre1=@Text or Genre2=@Text or Genre3=@Text or Genre4=@Text or Genre5=@Text or Genre6=@Text or Genre7=@Text or Genre8=@Text or Genre9=@Text)
  and WebArtists.Artist is not null
  and inventory>0
  and Artist>=@Letter
  group by WebArtists.Artist
  order by WebArtists.Artist
  offset 0 rows
  Fetch Next @Fetch Rows only











