





-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spUpdateSignInCartTotalsTableErnie]

as

--Delete SignInCartTotalsTableErnie
delete SignInCartTotalsTableErnie

--Insert Cart Data
insert SignInCartTotalsTableErnie
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
Update SignInCartTotalsTableErnie
set
FullName=Customers.FullName,
City=Customers.City,
CustomerID=Customers.CustomerID,
LastSearchDone=Customers.DateofLastSearch,
LastEmailDate=Customers.DateOfLastCartReminderEmailSent,
TotalEmailsSent=Customers.NumberOfCartReminderEmailsSent
from Customers
inner join SignInCartTotalsTableErnie on Customers.counter=SignInCartTotalsTableErnie.CustomerServerCounter





