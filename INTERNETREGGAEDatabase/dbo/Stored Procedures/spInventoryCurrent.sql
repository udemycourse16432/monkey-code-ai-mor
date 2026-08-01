-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spInventoryCurrent]


AS

delete InventoryCurrent

insert into InventoryCurrent
(UPC
,ArtistTitle
,Inventory
,Millions_ItemID
,[Format]
,SupplierID
,RetailPrice)

select
 UPC
,ArtistTitle
,Inventory
,ID
,[Format]
,SupplierID
,RetailPrice
from Inventory
where inventory>0
order by ID

update InventoryCurrent
set UPC='xx' where UPC is null

