










-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spOrderedQueries]

 @CartName1 nvarchar(60)
,@CartName2 nvarchar(60)
,@CustomerServerCounter int

AS

--Inventory table
begin transaction UpdateInventory
UPDATE inventory
SET inventory=inventory.inventory-Carts.Quantity
FROM inventory,Carts
WHERE Carts.ItemID=inventory.ID and CartName=@CartName1
and Carts.SubtractedInventory is null
and Carts.SaveForLater is null
UPDATE inventory set inventory=0 where inventory<0
UPDATE Carts set SubtractedInventory='y' where CartName=@CartName1
and Carts.SaveForLater is null
commit transaction UpdateInventory

--CustomerCartsNotifications table
update Customers
set
NumberofCartReminderEmailsSent=null,
DateOfLastCartReminderEmailSent=null
where counter=@CustomerServerCounter

--Customers table
Update Customers
set CartQuantity=0
,DateOfLastOrder=getdate()
where counter=@CustomerServerCounter

--Delete Shopping Cart
DELETE Carts where CartName=@CartName1
and SaveForLater is null
DELETE Carts where CartName=@CartName2
and SaveForLater is null









