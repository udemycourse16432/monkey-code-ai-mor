










-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spOrderCompletedViaPayPalIPNQueries]

 @PaypalTransactionID nvarchar(50)
,@PayPalEmail nvarchar(100)
,@PaypalPaymentStatus nvarchar(50)
,@PaypalAmountPaid numeric(10,2)
,@OrderNumber nvarchar(15)
,@PayPalIPNCategory nvarchar(100)
,@CustomerServerCounter int

AS

--Orders table
update orders set
PaypalTransactionID=@PaypalTransactionID
,Status='ordered'
,PayPalEmail=@PayPalEmail
,PaypalPaymentStatus=@PaypalPaymentStatus
,PaypalAmountPaid=@PaypalAmountPaid
 where OrderNumber=@OrderNumber

--HoldPileForWeb status
update HoldPilesForWeb
set HoldPileStatus='Ordered'
where HoldPileNumber=@OrderNumber

--Inventory table
begin transaction UpdateInventory
UPDATE inventory
SET inventory=inventory.inventory-Carts.Quantity
FROM inventory,Carts
WHERE Carts.ItemID=inventory.ID and Carts.OrderNumber=@OrderNumber
and Carts.SubtractedInventory is null
and Carts.SaveForLater is null
UPDATE inventory set inventory=0 where inventory<0
UPDATE Carts set SubtractedInventory='y' where Carts.OrderNumber=@OrderNumber 
and Carts.SaveForLater is null
commit transaction UpdateInventory

--Update Orders Table if Cleared E-Check
if @PayPalIPNCategory='Web Order CLEARED E-Check'
 begin
  update orders set
  PaypalPaymentStatus=@PaypalPaymentStatus
  where OrderNumber=@OrderNumber
 end

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
DELETE Carts where Carts.OrderNumber=@OrderNumber
and Carts.SaveForLater is null









