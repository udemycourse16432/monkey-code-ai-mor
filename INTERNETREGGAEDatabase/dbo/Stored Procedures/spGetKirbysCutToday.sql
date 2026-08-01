








-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spGetKirbysCutToday] 

AS

declare @Today6PercentCut nvarchar(20)
declare @TodayKirbyItemCut nvarchar(20)
declare @TodayKirbyCapDealCut nvarchar(20)

--Kirby 6% Cut
set @Today6PercentCut=(select sum(
case when OrderItems.Inventory<Orderitems.Quantity
 then Price*Orderitems.Inventory
else
 Price*Quantity
end) as Today
from OrderItems
inner join Orders On OrderItems.OrderNumber=Orders.OrderNumber
where month([DateTime])=month(GetDate())
and year([DateTime])=year(GetDate())
and day([DateTime])=day(GetDate())
and Status='ordered')

--Kirby Label Cut
set @TodayKirbyItemCut=(select sum(
case when OrderItems.Inventory<Orderitems.Quantity
 then (KirbysCut-Orderitems.KirbyCost)*Orderitems.Inventory
else
 (KirbysCut-Orderitems.KirbyCost)*Quantity
end) as Today
from OrderItems
inner join Orders On OrderItems.OrderNumber=Orders.OrderNumber
where month([DateTime])=month(GetDate())
and year([DateTime])=year(GetDate())
and day([DateTime])=day(GetDate())
and Status='ordered'
and KirbyItem='y')

--Kirby Cap Deal Cut
set @TodayKirbyCapDealCut=(select sum(
case when OrderItems.Inventory<Orderitems.Quantity
 then Price*Orderitems.Inventory
else
 Price*Quantity
end) as Today
from OrderItems
inner join Orders On OrderItems.OrderNumber=Orders.OrderNumber
where month([DateTime])=month(GetDate())
and year([DateTime])=year(GetDate())
and day([DateTime])=day(GetDate())
and Status='ordered'
and supplierid=1074)



select isnull(@Today6PercentCut,0) as Today6PercentCut, isnull(@TodayKirbyItemCut,'0') as TodayKirbyItemCut, isnull(@TodayKirbyCapDealCut,'0') as TodayKirbyCapDealCut







