






CREATE PROCEDURE [dbo].[GenreArtists]
 @Text nvarchar(255)
,@Offset int
,@Fetch int
,@SortBy nvarchar(20)

AS
if @SortBy='P'
 begin
  select WebArtists.Artist as GenreArtist,count(WebArtists.Artist) as Total
  from Inventory
  left join WebArtists on Inventory.ID=WebArtists.InventoryID
  where (Genre1=@Text or Genre2=@Text or Genre3=@Text or Genre4=@Text or Genre5=@Text or Genre6=@Text or Genre7=@Text or Genre8=@Text or Genre9=@Text)
  and WebArtists.Artist is not null
  and inventory>0
  group by WebArtists.Artist
  order by count(WebArtists.Artist) desc
  offset @Offset rows
  Fetch Next @Fetch Rows only
 end
else
 begin
  select WebArtists.Artist as GenreArtist,count(WebArtists.Artist) as Total
  from Inventory
  left join WebArtists on Inventory.ID=WebArtists.InventoryID
  where (Genre1=@Text or Genre2=@Text or Genre3=@Text or Genre4=@Text or Genre5=@Text or Genre6=@Text or Genre7=@Text or Genre8=@Text or Genre9=@Text)
  and WebArtists.Artist is not null
  and inventory>0
  group by WebArtists.Artist
  order by WebArtists.Artist
  offset @Offset rows
  Fetch Next @Fetch Rows only
 end











