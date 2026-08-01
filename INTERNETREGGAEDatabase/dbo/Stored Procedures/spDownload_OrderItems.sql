







CREATE PROCEDURE [dbo].[spDownload_OrderItems]

@OrderNumber nvarchar(20)

AS

select
InventoryID,
Price,
Quantity,
counter,
Inventory,
SearchCriteriaStatisticsID
from OrderItems
where OrderNumber=@OrderNumber




