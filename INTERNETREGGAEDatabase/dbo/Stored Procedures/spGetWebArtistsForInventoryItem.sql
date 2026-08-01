
CREATE PROCEDURE [dbo].[spGetWebArtistsForInventoryItem] 

@InventoryID int

AS

select Artist from WebArtists
where InventoryID=@InventoryID
order by Artist