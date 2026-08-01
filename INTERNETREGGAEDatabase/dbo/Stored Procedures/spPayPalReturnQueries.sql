

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].spPayPalReturnQueries

@CartName nvarchar(60)

AS

UPDATE inventory
SET inventory=inventory.inventory-Carts.Quantity
FROM inventory,Carts
WHERE Carts.ItemID=inventory.ID and Carts.CartName=@CartName

UPDATE inventory set inventory=0 where inventory<0

Update WebArtists set InStock='n'
From WebArtists
inner join Inventory on WebArtists.InventoryID=Inventory.ID
Inner join Carts on WebArtists.InventoryID=Carts.ItemID
where cartname=@CartName
and Inventory.Inventory=0

DELETE Carts where CartName=@CartName