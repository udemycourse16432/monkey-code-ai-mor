
create PROCEDURE [dbo].[spGetWebArtistsForInventoryItemByCounter] 

@InventoryID int

AS

select Artist from WebArtists
where InventoryID=@InventoryID
order by counter