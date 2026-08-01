-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spUpdateCurrentCartTotalPriceColumn]

as

delete CurrentCartTotalPriceTable

insert CurrentCartTotalPriceTable
(TotalPrice,CustomerServerCounter)
select sum(Quantity*Price) as TotalPrice,cast (right(CartName,len(CartName)-7) as int) as CustomerServerCounter from Carts 
inner join Inventory on Carts.ItemID=Inventory.ID
where Inventory.Inventory>0
and ShowOnWebsite='y'
and Deleted='n'
and Carts.CartName like 'W_CART%'
group by cast (right(CartName,len(CartName)-7) as int)
order by TotalPrice desc

Update Customers set CurrentCartTotalPrice=TotalPrice
from Customers
inner join CurrentCartTotalPriceTable on Customers.counter=CurrentCartTotalPriceTable.CustomerServerCounter
