-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE DeleteBackorders 

@CartName nvarchar(25),
@CustomerID int

AS

--Insert Ordered Backorders into DeleteBackordersInStockNow table
insert into DeleteBackordersInStockNow
(CustomerID,
 DeleteBackorderInventoryID)
select
BackordersInStockNow.CustomerID,Carts.ItemID from Carts
inner join backordersinstocknow on carts.ItemID=backordersinstocknow.BackorderInventoryID
inner join inventory on carts.itemid=inventory.id
where cartname=@CartName
and CustomerID=@CustomerID
and Inventory>0

--Delete Ordered Backorders from BackordersInStockNow table
delete  b from BackordersInStockNow b
inner join Carts c on b.BackorderInventoryID=c.ItemID
inner join inventory i on c.itemid=i.id
where cartname=@CartName
and CustomerID=@CustomerID
and Inventory>0
