







-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spGetKirbysCutThisMonth] 

AS

declare @ThisMonth6PercentCut nvarchar(20)
declare @ThisMonthKirbyItemCut nvarchar(20)
declare @ThisMonthKirbyCapDealCut nvarchar(20)

--6% Cut
set @ThisMonth6PercentCut=(select sum(
case when OrderItems.Inventory<Orderitems.Quantity
 then Price*Orderitems.Inventory
else
 Price*Quantity
end) as ThisMonth
from OrderItems
inner join Orders On OrderItems.OrderNumber=Orders.OrderNumber
where month([DateTime])=month(GetDate())
and year([DateTime])=year(GetDate())
and Status='ordered')

--Kirby Labels
set @ThisMonthKirbyItemCut=(select sum(
case when OrderItems.Inventory<Orderitems.Quantity
 then (KirbysCut-Orderitems.KirbyCost)*Orderitems.Inventory
else
 (KirbysCut-Orderitems.KirbyCost)*Quantity
end) as ThisMonth
from OrderItems
inner join Orders On OrderItems.OrderNumber=Orders.OrderNumber
where month([DateTime])=month(GetDate())
and year([DateTime])=year(GetDate())
and Status='ordered'
and KirbyItem='y')

--Cap Deal
set @ThisMonthKirbyCapDealCut=(select sum(
case when OrderItems.Inventory<Orderitems.Quantity
 then Price*Orderitems.Inventory
else
 Price*Quantity
end) as ThisMonth
from OrderItems
inner join Orders On OrderItems.OrderNumber=Orders.OrderNumber
where month([DateTime])=month(GetDate())
and year([DateTime])=year(GetDate())
and Status='ordered'
and SupplierID=1074)

select isnull(@ThisMonth6PercentCut,0) as ThisMonth6PercentCut, isnull(@ThisMonthKirbyItemCut,'0') as ThisMonthKirbyItemCut, isnull(@ThisMonthKirbyCapDealCut,'0') as ThisMonthKirbyCapDealCut







