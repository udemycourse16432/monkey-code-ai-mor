


CREATE PROCEDURE [dbo].[spFigureTHEforArtist]
 @Text nvarchar(255)

AS
declare @ArtistWithoutThe nvarchar(255)
declare @ArtistWithThe nvarchar(255)

set @ArtistWithoutThe = (select count(counter) as Qty from WebArtists
inner join inventory on WebArtists.InventoryID=Inventory.ID
where Artist = @Text
and Inventory.Inventory>0)

set @ArtistWithThe = (select count(counter) as Qty from WebArtists
inner join inventory on WebArtists.InventoryID=Inventory.ID
where Artist = 'The ' + @Text
and Inventory.Inventory>0)

select @ArtistWithoutThe as [WithoutThe], @ArtistWithThe as [WithThe]

