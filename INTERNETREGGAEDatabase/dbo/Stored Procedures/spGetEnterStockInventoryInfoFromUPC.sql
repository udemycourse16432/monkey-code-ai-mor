








CREATE PROCEDURE [dbo].[spGetEnterStockInventoryInfoFromUPC]

@UPC nvarchar(50)

AS

select

ID,
ArtistTitle,
Label,
Genre1,
Genre2,
Genre3,
RetailPrice,
StorePrice,
Inventory,
UsedItem,
ItemFeatures1

from inventory

where UPC=@UPC

order by UsedItem desc
















