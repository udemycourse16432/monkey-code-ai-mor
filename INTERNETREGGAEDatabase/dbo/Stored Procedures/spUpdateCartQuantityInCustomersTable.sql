



CREATE PROCEDURE [dbo].[spUpdateCartQuantityInCustomersTable] 

@CustomerServerCounter int

AS
declare @CartQuantity int
set @CartQuantity=(select sum(Quantity) from Carts 
inner join Inventory on Carts.ItemID=Inventory.ID
where CartName='W_CART_'+cast(@CustomerServerCounter as nvarchar(20))
and Inventory.Inventory>0)
set @CartQuantity=isnull(@CartQuantity,0)

declare @CartTotalPrice numeric(8,2)
set @CartTotalPrice=(select sum(Quantity*Price) from Carts 
inner join Inventory on Carts.ItemID=Inventory.ID
where CartName='W_CART_'+cast(@CustomerServerCounter as nvarchar(20))
and Inventory.Inventory>0)
set @CartTotalPrice=isnull(@CartTotalPrice,0)

update customers
set CartQuantity=@CartQuantity
where Customers.counter=@CustomerServerCounter

update customers
set CurrentCartTotalPrice=@CartTotalPrice
where Customers.counter=@CustomerServerCounter

update customers
set DateOfLastCartAdjustment=getdate()
where Customers.counter=@CustomerServerCounter


