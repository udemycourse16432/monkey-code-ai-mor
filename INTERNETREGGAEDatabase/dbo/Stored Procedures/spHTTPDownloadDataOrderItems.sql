










CREATE PROCEDURE [dbo].[spHTTPDownloadDataOrderItems]

@OrderNumber nvarchar(20)

AS

select
InventoryID,
Price,
Quantity,
counter,
Inventory,
SearchCriteriaStatisticsID,
SupplierID,
KirbyItem,
KirbysCut,
Cost,
KirbyCost

from OrderItems
where OrderNumber=@OrderNumber







