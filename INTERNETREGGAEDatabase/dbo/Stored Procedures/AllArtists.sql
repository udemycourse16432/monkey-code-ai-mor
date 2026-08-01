






create PROCEDURE [dbo].[AllArtists]
 @Offset int
,@Fetch int
,@SortBy nvarchar(20)

AS
if @SortBy='P'
 begin
  select WebArtists.Artist as Artist,count(WebArtists.Artist) as Total
  from Inventory
  left join WebArtists on Inventory.ID=WebArtists.InventoryID
  where WebArtists.Artist is not null
  and inventory>0
  group by WebArtists.Artist
  order by count(WebArtists.Artist) desc
  offset @Offset rows
  Fetch Next @Fetch Rows only
 end
else
 begin
  select WebArtists.Artist as Artist,count(WebArtists.Artist) as Total
  from Inventory
  left join WebArtists on Inventory.ID=WebArtists.InventoryID
  where WebArtists.Artist is not null
  and inventory>0
  group by WebArtists.Artist
  order by WebArtists.Artist
  offset @Offset rows
  Fetch Next @Fetch Rows only
 end











