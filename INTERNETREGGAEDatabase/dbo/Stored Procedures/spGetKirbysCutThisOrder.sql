








-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spGetKirbysCutThisOrder] 

@OrderNumber nvarchar(15)

AS

declare @ThisOrder6PercentCut nvarchar(20)
declare @ThisOrderKirbyItemCut nvarchar(20)
declare @ThisOrderKirbyCapDealCut nvarchar(20)

--Kirby 6% Cut
set @ThisOrder6PercentCut = (select sum(
case when OrderItems.Inventory<Orderitems.Quantity
 then Price*Orderitems.Inventory
else
 Price*Quantity
end) as ThisOrder
from OrderItems
inner join Orders On OrderItems.OrderNumber=Orders.OrderNumber
where Orders.OrderNumber=@OrderNumber)

--Kirby Label Cut
set @ThisOrderKirbyItemCut = (select sum(
case when OrderItems.Inventory<Orderitems.Quantity
 then (KirbysCut-Orderitems.KirbyCost)*Orderitems.Inventory
else
 (KirbysCut-Orderitems.KirbyCost)*Quantity
end) as ThisOrder
from OrderItems
inner join Orders On OrderItems.OrderNumber=Orders.OrderNumber
where Orders.OrderNumber=@OrderNumber
and KirbyItem='y')

--Kirby Cap Deal Cut
set @ThisOrderKirbyCapDealCut = (select sum(
case when OrderItems.Inventory<Orderitems.Quantity
 then Price*Orderitems.Inventory
else
 Price*Quantity
end) as ThisOrder
from OrderItems
inner join Orders On OrderItems.OrderNumber=Orders.OrderNumber
where Orders.OrderNumber=@OrderNumber
and SupplierID=1074)

select isnull(@ThisOrder6PercentCut,0) as ThisOrder6PercentCut, isnull(@ThisOrderKirbyItemCut,'0') as ThisOrderKirbyItemCut, isnull(@ThisOrderKirbyCapDealCut,'0') as ThisOrderKirbyCapDealCut








