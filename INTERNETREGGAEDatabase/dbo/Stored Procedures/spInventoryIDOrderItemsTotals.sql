















create PROCEDURE [dbo].[spInventoryIDOrderItemsTotals]
@InventoryID int
AS

select Year(OrderItemsDateTime) as Yr,Month(OrderItemsDateTime) as Mth,sum(Quantity) as TotalQuantity,sum(Quantity*Price) as TotalPrice
from OrderItems where InventoryID=@InventoryID
group by Year(OrderItemsDateTime),Month(OrderItemsDateTime)
order by Yr desc,Mth desc












