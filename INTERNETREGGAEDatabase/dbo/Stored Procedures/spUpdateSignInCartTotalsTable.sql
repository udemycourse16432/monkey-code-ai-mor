

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spUpdateSignInCartTotalsTable]

as

--Delete SignInCartTotalsTable
delete SignInCartTotalsTable

--Insert Cart Data
insert SignInCartTotalsTable
(TotalPrice,TotalQuantity,CustomerServerCounter,LastCartAdjustment)
select
sum(Quantity*Price) as TotalPrice,
sum(Quantity) as TotalQuantity,
cast (right(CartName,len(CartName)-7) as int) as CustomerServerCounter,
max(DateTime)
from Carts 
inner join Inventory on Carts.ItemID=Inventory.ID
where Inventory.Inventory>0
and ShowOnWebsite='y'
and Deleted='n'
and Carts.CartName like 'W_CART%'
group by cast (right(CartName,len(CartName)-7) as int)
having sum(Quantity*Price)>0
order by TotalPrice desc

--Update Customer Data
Update SignInCartTotalsTable
set
FullName=Customers.FullName,
City=Customers.City,
CustomerID=Customers.CustomerID
from Customers
inner join SignInCartTotalsTable on Customers.counter=SignInCartTotalsTable.CustomerServerCounter

