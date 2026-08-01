












CREATE PROCEDURE [dbo].[spKirbyItemData]

as

--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
--XXXXXXX--ORDER ITEMS TABLE--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

--BOUGHT AND SOLD HISTORY-----------------------------

declare @BoughtHistory int
declare @SoldHistory int

set @BoughtHistory= (select sum(NumberOfitems) from KirbyItemsPurchases)
set @SoldHistory= (select sum(Quantity) from OrderItems where KirbyItem='y')


--INTERMUSIC--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

--Current Inventory-----------------------------------

declare @CDInventoryQty_Intermusic int
declare @LPInventoryQty_Intermusic int
declare @OtherInventoryQty_Intermusic int
declare @TotalInventoryQty_Intermusic int

declare @CDInventoryCost_Intermusic numeric(9,2)
declare @LPInventoryCost_Intermusic numeric(9,2)
declare @OtherInventoryCost_Intermusic numeric(9,2)
declare @TotalInventoryCost_Intermusic numeric(9,2)

declare @CDInventoryKirbysCut_Intermusic numeric(9,2)
declare @LPInventoryKirbysCut_Intermusic numeric(9,2)
declare @OtherInventoryKirbysCut_Intermusic numeric(9,2)
declare @TotalInventoryKirbysCut_Intermusic numeric(9,2)

declare @CDInventoryKirbysPercentCut_Intermusic numeric(5,2)
declare @LPInventoryKirbysPercentCut_Intermusic numeric(5,2)
declare @OtherInventoryKirbysPercentCut_Intermusic numeric(5,2)
declare @TotalInventoryKirbysPercentCut_Intermusic numeric(5,2)

set @CDInventoryQty_Intermusic=(select sum(Inventory) from Inventory where KirbyItem='y' and Format='CD' and SupplierID=1029)
set @LPInventoryQty_Intermusic=(select sum(Inventory) from Inventory where KirbyItem='y' and Format='LP' and SupplierID=1029)
set @OtherInventoryQty_Intermusic=(select sum(Inventory) from Inventory where KirbyItem='y' and Format<>'LP' and Format<>'CD' and SupplierID=1029)
set @TotalInventoryQty_Intermusic=(select sum(Inventory) from Inventory where KirbyItem='y' and SupplierID=1029)

set @CDInventoryCost_Intermusic=(select sum(Inventory*KirbyCost) from Inventory where KirbyItem='y' and Format='CD' and SupplierID=1029)
set @LPInventoryCost_Intermusic=(select sum(Inventory*KirbyCost) from Inventory where KirbyItem='y' and Format='LP' and SupplierID=1029)
set @OtherInventoryCost_Intermusic=(select sum(Inventory*KirbyCost) from Inventory where KirbyItem='y' and Format<>'LP' and Format<>'CD' and SupplierID=1029)
set @TotalInventoryCost_Intermusic=(select sum(Inventory*KirbyCost) from Inventory where KirbyItem='y' and SupplierID=1029)

set @CDInventoryKirbysCut_Intermusic=(select sum(Inventory*KirbysCut) from Inventory where KirbyItem='y' and Format='CD' and SupplierID=1029)
set @LPInventoryKirbysCut_Intermusic=(select sum(Inventory*KirbysCut) from Inventory where KirbyItem='y' and Format='LP' and SupplierID=1029)
set @OtherInventoryKirbysCut_Intermusic=(select sum(Inventory*KirbysCut) from Inventory where KirbyItem='y' and Format<>'LP' and Format<>'CD' and SupplierID=1029)
set @TotalInventoryKirbysCut_Intermusic=(select sum(Inventory*KirbysCut) from Inventory where KirbyItem='y' and SupplierID=1029)

set @CDInventoryKirbysPercentCut_Intermusic=(select avg(((KirbysCut-KirbyCost)+(.06*RetailPrice))/KirbyCost) from Inventory where KirbyItem='y' and Format='CD' and SupplierID=1029 and Inventory>0)
set @LPInventoryKirbysPercentCut_Intermusic=(select avg(((KirbysCut-KirbyCost)+(.06*RetailPrice))/KirbyCost) from Inventory where KirbyItem='y' and Format='LP' and SupplierID=1029 and Inventory>0)
set @OtherInventoryKirbysPercentCut_Intermusic=(select avg(((KirbysCut-KirbyCost)+(.06*RetailPrice))/KirbyCost) from Inventory where KirbyItem='y' and Format<>'LP' and Format<>'CD' and SupplierID=1029 and Inventory>0)
set @TotalInventoryKirbysPercentCut_Intermusic=(select avg(((KirbysCut-KirbyCost)+(.06*RetailPrice))/KirbyCost) from Inventory where KirbyItem='y' and SupplierID=1029 and Inventory>0)


--INTERMUSIC Last 30 Days CDs-----------------------------------------

Declare @CD30Days_KirbysCut_Intermusic numeric(9,2)
Declare @CD30Days_Cost_Intermusic numeric(9,2)
Declare @CD30Days_Quantity_Intermusic int

set @CD30Days_KirbysCut_Intermusic=(select sum(
case when OrderItems.Inventory<Orderitems.Quantity
 then (KirbysCut)*Orderitems.Inventory
else
 (KirbysCut)*Quantity
end)
from OrderItems
inner join Orders On OrderItems.OrderNumber=Orders.OrderNumber
where [DateTime]>=GetDate()-30
and Status='ordered'
and Format='CD'
and KirbyItem='y'
and SupplierID=1029)

set @CD30Days_Cost_Intermusic=(select sum(
case when OrderItems.Inventory<Orderitems.Quantity
 then (OrderItems.KirbyCost)*Orderitems.Inventory
else
 (OrderItems.KirbyCost)*Quantity
end)
from OrderItems
inner join Orders On OrderItems.OrderNumber=Orders.OrderNumber
where [DateTime]>=GetDate()-30
and Status='ordered'
and Format='CD'
and KirbyItem='y'
and SupplierID=1029)

set @CD30Days_Quantity_Intermusic=(select sum(
case when OrderItems.Inventory<Orderitems.Quantity
 then Orderitems.Inventory
else
 Quantity
end)
from OrderItems
inner join Orders On OrderItems.OrderNumber=Orders.OrderNumber
where [DateTime]>=GetDate()-30
and Status='ordered'
and Format='CD'
and KirbyItem='y'
and SupplierID=1029)

--INTERMUSIC Last 30 Days LPs-----------------------------------------

Declare @LP30Days_KirbysCut_Intermusic numeric(9,2)
Declare @LP30Days_Cost_Intermusic numeric(9,2)
Declare @LP30Days_Quantity_Intermusic int

set @LP30Days_KirbysCut_Intermusic=(select sum(
case when OrderItems.Inventory<Orderitems.Quantity
 then (KirbysCut)*Orderitems.Inventory
else
 (KirbysCut)*Quantity
end)
from OrderItems
inner join Orders On OrderItems.OrderNumber=Orders.OrderNumber
where [DateTime]>=GetDate()-30
and Status='ordered'
and Format='LP'
and KirbyItem='y'
and SupplierID=1029)

set @LP30Days_Cost_Intermusic=(select sum(
case when OrderItems.Inventory<Orderitems.Quantity
 then (OrderItems.KirbyCost)*Orderitems.Inventory
else
 (OrderItems.KirbyCost)*Quantity
end)
from OrderItems
inner join Orders On OrderItems.OrderNumber=Orders.OrderNumber
where [DateTime]>=GetDate()-30
and Status='ordered'
and Format='LP'
and KirbyItem='y'
and SupplierID=1029)

set @LP30Days_Quantity_Intermusic=(select sum(
case when OrderItems.Inventory<Orderitems.Quantity
 then Orderitems.Inventory
else
 Quantity
end)
from OrderItems
inner join Orders On OrderItems.OrderNumber=Orders.OrderNumber
where [DateTime]>=GetDate()-30
and Status='ordered'
and Format='LP'
and KirbyItem='y'
and SupplierID=1029)

--INTERMUSIC Last 30 Days Other Formats-----------------------------------------

Declare @Other30Days_KirbysCut_Intermusic numeric(9,2)
Declare @Other30Days_Cost_Intermusic numeric(9,2)
Declare @Other30Days_Quantity_Intermusic int

set @Other30Days_KirbysCut_Intermusic=(select sum(
case when OrderItems.Inventory<Orderitems.Quantity
 then (KirbysCut)*Orderitems.Inventory
else
 (KirbysCut)*Quantity
end)
from OrderItems
inner join Orders On OrderItems.OrderNumber=Orders.OrderNumber
where [DateTime]>=GetDate()-30
and Status='ordered'
and Format<>'CD' and Format<>'LP'
and KirbyItem='y'
and SupplierID=1029)

set @Other30Days_Cost_Intermusic=(select sum(
case when OrderItems.Inventory<Orderitems.Quantity
 then (OrderItems.KirbyCost)*Orderitems.Inventory
else
 (OrderItems.KirbyCost)*Quantity
end)
from OrderItems
inner join Orders On OrderItems.OrderNumber=Orders.OrderNumber
where [DateTime]>=GetDate()-30
and Status='ordered'
and Format<>'CD' and Format<>'LP'
and KirbyItem='y'
and SupplierID=1029)

set @Other30Days_Quantity_Intermusic=(select sum(
case when OrderItems.Inventory<Orderitems.Quantity
 then Orderitems.Inventory
else
 Quantity
end)
from OrderItems
inner join Orders On OrderItems.OrderNumber=Orders.OrderNumber
where [DateTime]>=GetDate()-30
and Status='ordered'
and Format<>'CD' and Format<>'LP'
and KirbyItem='y'
and SupplierID=1029)

--INTERMUSIC Last 30 Days Total-----------------------------------------

Declare @Total30Days_KirbysCut_Intermusic numeric(9,2)
Declare @Total30Days_Cost_Intermusic numeric(9,2)
Declare @Total30Days_Quantity_Intermusic int

set @Total30Days_KirbysCut_Intermusic=(select sum(
case when OrderItems.Inventory<Orderitems.Quantity
 then (KirbysCut)*Orderitems.Inventory
else
 (KirbysCut)*Quantity
end)
from OrderItems
inner join Orders On OrderItems.OrderNumber=Orders.OrderNumber
where [DateTime]>=GetDate()-30
and Status='ordered'
and KirbyItem='y'
and SupplierID=1029)

set @Total30Days_Cost_Intermusic=(select sum(
case when OrderItems.Inventory<Orderitems.Quantity
 then (OrderItems.KirbyCost)*Orderitems.Inventory
else
 (OrderItems.KirbyCost)*Quantity
end)
from OrderItems
inner join Orders On OrderItems.OrderNumber=Orders.OrderNumber
where [DateTime]>=GetDate()-30
and Status='ordered'
and KirbyItem='y'
and SupplierID=1029)

set @Total30Days_Quantity_Intermusic=(select sum(
case when OrderItems.Inventory<Orderitems.Quantity
 then Orderitems.Inventory
else
 Quantity
end)
from OrderItems
inner join Orders On OrderItems.OrderNumber=Orders.OrderNumber
where [DateTime]>=GetDate()-30
and Status='ordered'
and KirbyItem='y'
and SupplierID=1029)

--ALL SUPPLIERS--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

--Current Inventory-----------------------------------

declare @CDInventoryQty int
declare @LPInventoryQty int
declare @OtherInventoryQty int
declare @TotalInventoryQty int

declare @CDInventoryCost numeric(9,2)
declare @LPInventoryCost numeric(9,2)
declare @OtherInventoryCost numeric(9,2)
declare @TotalInventoryCost numeric(9,2)

declare @CDInventoryKirbysCut numeric(9,2)
declare @LPInventoryKirbysCut numeric(9,2)
declare @OtherInventoryKirbysCut numeric(9,2)
declare @TotalInventoryKirbysCut numeric(9,2)

declare @CDInventoryKirbysPercentCut numeric(5,2)
declare @LPInventoryKirbysPercentCut numeric(5,2)
declare @OtherInventoryKirbysPercentCut numeric(5,2)
declare @TotalInventoryKirbysPercentCut numeric(5,2)

set @CDInventoryQty=(select sum(Inventory) from Inventory where KirbyItem='y' and Format='CD')
set @LPInventoryQty=(select sum(Inventory) from Inventory where KirbyItem='y' and Format='LP')
set @OtherInventoryQty=(select sum(Inventory) from Inventory where KirbyItem='y' and Format<>'LP' and Format<>'CD')
set @TotalInventoryQty=(select sum(Inventory) from Inventory where KirbyItem='y')

set @CDInventoryCost=(select sum(Inventory*KirbyCost) from Inventory where KirbyItem='y' and Format='CD')
set @LPInventoryCost=(select sum(Inventory*KirbyCost) from Inventory where KirbyItem='y' and Format='LP')
set @OtherInventoryCost=(select sum(Inventory*KirbyCost) from Inventory where KirbyItem='y' and Format<>'LP' and Format<>'CD')
set @TotalInventoryCost=(select sum(Inventory*KirbyCost) from Inventory where KirbyItem='y')

set @CDInventoryKirbysCut=(select sum(Inventory*KirbysCut) from Inventory where KirbyItem='y' and Format='CD')
set @LPInventoryKirbysCut=(select sum(Inventory*KirbysCut) from Inventory where KirbyItem='y' and Format='LP')
set @OtherInventoryKirbysCut=(select sum(Inventory*KirbysCut) from Inventory where KirbyItem='y' and Format<>'LP' and Format<>'CD')
set @TotalInventoryKirbysCut=(select sum(Inventory*KirbysCut) from Inventory where KirbyItem='y')

set @CDInventoryKirbysPercentCut=(select avg(((KirbysCut-KirbyCost)+(.06*RetailPrice))/KirbyCost) from Inventory where KirbyItem='y' and Format='CD' and Inventory>0)
set @LPInventoryKirbysPercentCut=(select avg(((KirbysCut-KirbyCost)+(.06*RetailPrice))/KirbyCost) from Inventory where KirbyItem='y' and Format='LP' and Inventory>0)
set @OtherInventoryKirbysPercentCut=(select avg(((KirbysCut-KirbyCost)+(.06*RetailPrice))/KirbyCost) from Inventory where KirbyItem='y' and Format<>'LP' and Format<>'CD' and Inventory>0)
set @TotalInventoryKirbysPercentCut=(select avg(((KirbysCut-KirbyCost)+(.06*RetailPrice))/KirbyCost) from Inventory where KirbyItem='y' and Inventory>0)


--Last 30 Days CDs-----------------------------------------

Declare @CD30Days_KirbysCut numeric(9,2)
Declare @CD30Days_Cost numeric(9,2)
Declare @CD30Days_Quantity int

set @CD30Days_KirbysCut=(select sum(
case when OrderItems.Inventory<Orderitems.Quantity
 then (KirbysCut)*Orderitems.Inventory
else
 (KirbysCut)*Quantity
end)
from OrderItems
inner join Orders On OrderItems.OrderNumber=Orders.OrderNumber
where [DateTime]>=GetDate()-30
and Status='ordered'
and Format='CD'
and KirbyItem='y')

set @CD30Days_Cost=(select sum(
case when OrderItems.Inventory<Orderitems.Quantity
 then (OrderItems.KirbyCost)*Orderitems.Inventory
else
 (OrderItems.KirbyCost)*Quantity
end)
from OrderItems
inner join Orders On OrderItems.OrderNumber=Orders.OrderNumber
where [DateTime]>=GetDate()-30
and Status='ordered'
and Format='CD'
and KirbyItem='y')

set @CD30Days_Quantity=(select sum(
case when OrderItems.Inventory<Orderitems.Quantity
 then Orderitems.Inventory
else
 Quantity
end)
from OrderItems
inner join Orders On OrderItems.OrderNumber=Orders.OrderNumber
where [DateTime]>=GetDate()-30
and Status='ordered'
and Format='CD'
and KirbyItem='y')

--Last 30 Days LPs-----------------------------------------

Declare @LP30Days_KirbysCut numeric(9,2)
Declare @LP30Days_Cost numeric(9,2)
Declare @LP30Days_Quantity int

set @LP30Days_KirbysCut=(select sum(
case when OrderItems.Inventory<Orderitems.Quantity
 then (KirbysCut)*Orderitems.Inventory
else
 (KirbysCut)*Quantity
end)
from OrderItems
inner join Orders On OrderItems.OrderNumber=Orders.OrderNumber
where [DateTime]>=GetDate()-30
and Status='ordered'
and Format='LP'
and KirbyItem='y')

set @LP30Days_Cost=(select sum(
case when OrderItems.Inventory<Orderitems.Quantity
 then (OrderItems.KirbyCost)*Orderitems.Inventory
else
 (OrderItems.KirbyCost)*Quantity
end)
from OrderItems
inner join Orders On OrderItems.OrderNumber=Orders.OrderNumber
where [DateTime]>=GetDate()-30
and Status='ordered'
and Format='LP'
and KirbyItem='y')

set @LP30Days_Quantity=(select sum(
case when OrderItems.Inventory<Orderitems.Quantity
 then Orderitems.Inventory
else
 Quantity
end)
from OrderItems
inner join Orders On OrderItems.OrderNumber=Orders.OrderNumber
where [DateTime]>=GetDate()-30
and Status='ordered'
and Format='LP'
and KirbyItem='y')

--Last 30 Days Other Formats-----------------------------------------

Declare @Other30Days_KirbysCut numeric(9,2)
Declare @Other30Days_Cost numeric(9,2)
Declare @Other30Days_Quantity int

set @Other30Days_KirbysCut=(select sum(
case when OrderItems.Inventory<Orderitems.Quantity
 then (KirbysCut)*Orderitems.Inventory
else
 (KirbysCut)*Quantity
end)
from OrderItems
inner join Orders On OrderItems.OrderNumber=Orders.OrderNumber
where [DateTime]>=GetDate()-30
and Status='ordered'
and Format<>'CD' and Format<>'LP'
and KirbyItem='y')

set @Other30Days_Cost=(select sum(
case when OrderItems.Inventory<Orderitems.Quantity
 then (OrderItems.KirbyCost)*Orderitems.Inventory
else
 (OrderItems.KirbyCost)*Quantity
end)
from OrderItems
inner join Orders On OrderItems.OrderNumber=Orders.OrderNumber
where [DateTime]>=GetDate()-30
and Status='ordered'
and Format<>'CD' and Format<>'LP'
and KirbyItem='y')

set @Other30Days_Quantity=(select sum(
case when OrderItems.Inventory<Orderitems.Quantity
 then Orderitems.Inventory
else
 Quantity
end)
from OrderItems
inner join Orders On OrderItems.OrderNumber=Orders.OrderNumber
where [DateTime]>=GetDate()-30
and Status='ordered'
and Format<>'CD' and Format<>'LP'
and KirbyItem='y')

--Last 30 Days Total-----------------------------------------

Declare @Total30Days_KirbysCut numeric(9,2)
Declare @Total30Days_Cost numeric(9,2)
Declare @Total30Days_Quantity int

set @Total30Days_KirbysCut=(select sum(
case when OrderItems.Inventory<Orderitems.Quantity
 then (KirbysCut)*Orderitems.Inventory
else
 (KirbysCut)*Quantity
end)
from OrderItems
inner join Orders On OrderItems.OrderNumber=Orders.OrderNumber
where [DateTime]>=GetDate()-30
and Status='ordered'
and KirbyItem='y')

set @Total30Days_Cost=(select sum(
case when OrderItems.Inventory<Orderitems.Quantity
 then (OrderItems.KirbyCost)*Orderitems.Inventory
else
 (OrderItems.KirbyCost)*Quantity
end)
from OrderItems
inner join Orders On OrderItems.OrderNumber=Orders.OrderNumber
where [DateTime]>=GetDate()-30
and Status='ordered'
and KirbyItem='y')

set @Total30Days_Quantity=(select sum(
case when OrderItems.Inventory<Orderitems.Quantity
 then Orderitems.Inventory
else
 Quantity
end)
from OrderItems
inner join Orders On OrderItems.OrderNumber=Orders.OrderNumber
where [DateTime]>=GetDate()-30
and Status='ordered'
and KirbyItem='y')


--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
--XXXXXXX--SOLD ITEMS TABLE--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

--BOUGHT AND SOLD HISTORY-----------------------------

declare @SoldHistory_FSI int

set @SoldHistory_FSI= (select sum(Quantity) from SoldItems where KirbyItem='y')

--INTERMUSIC--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

--INTERMUSIC Last 30 Days CDs-----------------------------------------

declare @SoldItemsDaysBehind int
set @SoldItemsDaysBehind=(select abs(datediff(day,GetDate(),max(InvoiceDate))) from SoldItems)

Declare @CD30Days_KirbysCut_Intermusic_FSI numeric(9,2)
Declare @CD30Days_Cost_Intermusic_FSI numeric(9,2)
Declare @CD30Days_Quantity_Intermusic_FSI int

set @CD30Days_KirbysCut_Intermusic_FSI=(select sum(SoldItems.KirbysCut*Quantity)
from SoldItems
inner join Inventory On SoldItems.ItemID=Inventory.ID
where [InvoiceDate]>=GetDate()-30
and Format='CD'
and SoldItems.KirbyItem='y'
and FalseSale=0
and SoldItems.SupplierID=1029)

set @CD30Days_Cost_Intermusic_FSI=(select sum(SoldItems.KirbyCost*Quantity)
from SoldItems
inner join Inventory On SoldItems.ItemID=Inventory.ID
where [InvoiceDate]>=GetDate()-30
and Format='CD'
and SoldItems.KirbyItem='y'
and FalseSale=0
and SoldItems.SupplierID=1029)

set @CD30Days_Quantity_Intermusic_FSI=(select sum(Quantity)
from SoldItems
inner join Inventory On SoldItems.ItemID=Inventory.ID
where [InvoiceDate]>=GetDate()-30
and Format='CD'
and SoldItems.KirbyItem='y'
and FalseSale=0
and SoldItems.SupplierID=1029)

--INTERMUSIC Last 30 Days LPs-----------------------------------------

Declare @LP30Days_KirbysCut_Intermusic_FSI numeric(9,2)
Declare @LP30Days_Cost_Intermusic_FSI numeric(9,2)
Declare @LP30Days_Quantity_Intermusic_FSI int

set @LP30Days_KirbysCut_Intermusic_FSI=(select sum(SoldItems.KirbysCut*Quantity)
from SoldItems
inner join Inventory On SoldItems.ItemID=Inventory.ID
where [InvoiceDate]>=GetDate()-30
and Format='LP'
and SoldItems.KirbyItem='y'
and FalseSale=0
and SoldItems.SupplierID=1029)

set @LP30Days_Cost_Intermusic_FSI=(select sum(SoldItems.KirbyCost*Quantity)
from SoldItems
inner join Inventory On SoldItems.ItemID=Inventory.ID
where [InvoiceDate]>=GetDate()-30
and Format='LP'
and SoldItems.KirbyItem='y'
and FalseSale=0
and SoldItems.SupplierID=1029)

set @LP30Days_Quantity_Intermusic_FSI=(select sum(Quantity)
from SoldItems
inner join Inventory On SoldItems.ItemID=Inventory.ID
where [InvoiceDate]>=GetDate()-30
and Format='LP'
and SoldItems.KirbyItem='y'
and FalseSale=0
and SoldItems.SupplierID=1029)

--INTERMUSIC Last 30 Days Other Formats-----------------------------------------

Declare @Other30Days_KirbysCut_Intermusic_FSI numeric(9,2)
Declare @Other30Days_Cost_Intermusic_FSI numeric(9,2)
Declare @Other30Days_Quantity_Intermusic_FSI int

set @Other30Days_KirbysCut_Intermusic_FSI=(select sum(SoldItems.KirbysCut*Quantity)
from SoldItems
inner join Inventory On SoldItems.ItemID=Inventory.ID
where [InvoiceDate]>=GetDate()-30
and Format='Other'
and SoldItems.KirbyItem='y'
and FalseSale=0
and SoldItems.SupplierID=1029)

set @Other30Days_Cost_Intermusic_FSI=(select sum(SoldItems.KirbyCost*Quantity)
from SoldItems
inner join Inventory On SoldItems.ItemID=Inventory.ID
where [InvoiceDate]>=GetDate()-30
and Format='Other'
and SoldItems.KirbyItem='y'
and FalseSale=0
and SoldItems.SupplierID=1029)

set @Other30Days_Quantity_Intermusic_FSI=(select sum(Quantity)
from SoldItems
inner join Inventory On SoldItems.ItemID=Inventory.ID
where [InvoiceDate]>=GetDate()-30
and Format='Other'
and SoldItems.KirbyItem='y'
and FalseSale=0
and SoldItems.SupplierID=1029)

--INTERMUSIC Last 30 Days Total-----------------------------------------

Declare @Total30Days_KirbysCut_Intermusic_FSI numeric(9,2)
Declare @Total30Days_Cost_Intermusic_FSI numeric(9,2)
Declare @Total30Days_Quantity_Intermusic_FSI int

set @Total30Days_KirbysCut_Intermusic_FSI=(select sum(SoldItems.KirbysCut*Quantity)
from SoldItems
inner join Inventory On SoldItems.ItemID=Inventory.ID
where [InvoiceDate]>=GetDate()-30
and SoldItems.KirbyItem='y'
and FalseSale=0
and SoldItems.SupplierID=1029)

set @Total30Days_Cost_Intermusic_FSI=(select sum(SoldItems.KirbyCost*Quantity)
from SoldItems
inner join Inventory On SoldItems.ItemID=Inventory.ID
where [InvoiceDate]>=GetDate()-30
and SoldItems.KirbyItem='y'
and FalseSale=0
and SoldItems.SupplierID=1029)

set @Total30Days_Quantity_Intermusic_FSI=(select sum(Quantity)
from SoldItems
inner join Inventory On SoldItems.ItemID=Inventory.ID
where [InvoiceDate]>=GetDate()-30
and SoldItems.KirbyItem='y'
and FalseSale=0
and SoldItems.SupplierID=1029)

--ALL SUPPLIERS--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

--Last 30 Days CDs-----------------------------------------

Declare @CD30Days_KirbysCut_FSI numeric(9,2)
Declare @CD30Days_Cost_FSI numeric(9,2)
Declare @CD30Days_Quantity_FSI int

set @CD30Days_KirbysCut_FSI=(select sum(SoldItems.KirbysCut*Quantity)
from SoldItems
inner join Inventory On SoldItems.ItemID=Inventory.ID
where [InvoiceDate]>=GetDate()-30
and Format='CD'
and SoldItems.KirbyItem='y'
and FalseSale=0
and SoldItems.SupplierID=1029)

set @CD30Days_Cost_FSI=(select sum(SoldItems.KirbyCost*Quantity)
from SoldItems
inner join Inventory On SoldItems.ItemID=Inventory.ID
where [InvoiceDate]>=GetDate()-30
and Format='CD'
and SoldItems.KirbyItem='y'
and FalseSale=0
and SoldItems.SupplierID=1029)

set @CD30Days_Quantity_FSI=(select sum(Quantity)
from SoldItems
inner join Inventory On SoldItems.ItemID=Inventory.ID
where [InvoiceDate]>=GetDate()-30
and Format='CD'
and SoldItems.KirbyItem='y'
and FalseSale=0
and SoldItems.SupplierID=1029)

--Last 30 Days LPs-----------------------------------------

Declare @LP30Days_KirbysCut_FSI numeric(9,2)
Declare @LP30Days_Cost_FSI numeric(9,2)
Declare @LP30Days_Quantity_FSI int

set @LP30Days_KirbysCut_FSI=(select sum(SoldItems.KirbysCut*Quantity)
from SoldItems
inner join Inventory On SoldItems.ItemID=Inventory.ID
where [InvoiceDate]>=GetDate()-30
and Format='LP'
and SoldItems.KirbyItem='y'
and FalseSale=0
and SoldItems.SupplierID=1029)

set @LP30Days_Cost_FSI=(select sum(SoldItems.KirbyCost*Quantity)
from SoldItems
inner join Inventory On SoldItems.ItemID=Inventory.ID
where [InvoiceDate]>=GetDate()-30
and Format='LP'
and SoldItems.KirbyItem='y'
and FalseSale=0
and SoldItems.SupplierID=1029)

set @LP30Days_Quantity_FSI=(select sum(Quantity)
from SoldItems
inner join Inventory On SoldItems.ItemID=Inventory.ID
where [InvoiceDate]>=GetDate()-30
and Format='LP'
and SoldItems.KirbyItem='y'
and FalseSale=0
and SoldItems.SupplierID=1029)

--Last 30 Days Other Formats-----------------------------------------

Declare @Other30Days_KirbysCut_FSI numeric(9,2)
Declare @Other30Days_Cost_FSI numeric(9,2)
Declare @Other30Days_Quantity_FSI int

set @Other30Days_KirbysCut_FSI=(select sum(SoldItems.KirbysCut*Quantity)
from SoldItems
inner join Inventory On SoldItems.ItemID=Inventory.ID
where [InvoiceDate]>=GetDate()-30
and Format='Other'
and SoldItems.KirbyItem='y'
and FalseSale=0
and SoldItems.SupplierID=1029)

set @Other30Days_Cost_FSI=(select sum(SoldItems.KirbyCost*Quantity)
from SoldItems
inner join Inventory On SoldItems.ItemID=Inventory.ID
where [InvoiceDate]>=GetDate()-30
and Format='Other'
and SoldItems.KirbyItem='y'
and FalseSale=0
and SoldItems.SupplierID=1029)

set @Other30Days_Quantity_FSI=(select sum(Quantity)
from SoldItems
inner join Inventory On SoldItems.ItemID=Inventory.ID
where [InvoiceDate]>=GetDate()-30
and Format='Other'
and SoldItems.KirbyItem='y'
and FalseSale=0
and SoldItems.SupplierID=1029)

--Last 30 Days Total-----------------------------------------

Declare @Total30Days_KirbysCut_FSI numeric(9,2)
Declare @Total30Days_Cost_FSI numeric(9,2)
Declare @Total30Days_Quantity_FSI int

set @Total30Days_KirbysCut_FSI=(select sum(SoldItems.KirbysCut*Quantity)
from SoldItems
inner join Inventory On SoldItems.ItemID=Inventory.ID
where [InvoiceDate]>=GetDate()-30
and SoldItems.KirbyItem='y'
and FalseSale=0
and SoldItems.SupplierID=1029)

set @Total30Days_Cost_FSI=(select sum(SoldItems.KirbyCost*Quantity)
from SoldItems
inner join Inventory On SoldItems.ItemID=Inventory.ID
where [InvoiceDate]>=GetDate()-30
and SoldItems.KirbyItem='y'
and FalseSale=0
and SoldItems.SupplierID=1029)

set @Total30Days_Quantity_FSI=(select sum(Quantity)
from SoldItems
inner join Inventory On SoldItems.ItemID=Inventory.ID
where [InvoiceDate]>=GetDate()-30
and SoldItems.KirbyItem='y'
and FalseSale=0
and SoldItems.SupplierID=1029)


--Record Data--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

if not exists
 (select counter from KirbyItemData
 where Year([DateTime])=Year(GetDate())
 and Month([DateTime])=Month(GetDate())
 and Day([DateTime])=Day(GetDate()))
 begin
  insert KirbyItemData
  (CDInventoryQty_Intermusic
  ,CDInventoryCost_Intermusic
  ,CDInventoryKirbysCut_Intermusic
  ,CDInventoryKirbysPercentCut_Intermusic
  ,LPInventoryQty_Intermusic
  ,LPInventoryCost_Intermusic
  ,LPInventoryKirbysCut_Intermusic
  ,LPInventoryKirbysPercentCut_Intermusic
  ,OtherInventoryQty_Intermusic
  ,OtherInventoryCost_Intermusic
  ,OtherInventoryKirbysCut_Intermusic
  ,OtherInventoryKirbysPercentCut_Intermusic
  ,TotalInventoryQty_Intermusic
  ,TotalInventoryCost_Intermusic
  ,TotalInventoryKirbysCut_Intermusic
  ,TotalInventoryKirbysPercentCut_Intermusic
  ,CD30Days_KirbysCut_Intermusic
  ,CD30Days_Cost_Intermusic
  ,CD30Days_Quantity_Intermusic
  ,LP30Days_KirbysCut_Intermusic
  ,LP30Days_Cost_Intermusic
  ,LP30Days_Quantity_Intermusic
  ,Other30Days_KirbysCut_Intermusic
  ,Other30Days_Cost_Intermusic
  ,Other30Days_Quantity_Intermusic
  ,Total30Days_KirbysCut_Intermusic
  ,Total30Days_Cost_Intermusic
  ,Total30Days_Quantity_Intermusic
  ,CDInventoryQty
  ,CDInventoryCost
  ,CDInventoryKirbysCut
  ,CDInventoryKirbysPercentCut
  ,LPInventoryQty
  ,LPInventoryCost
  ,LPInventoryKirbysCut
  ,LPInventoryKirbysPercentCut
  ,OtherInventoryQty
  ,OtherInventoryCost
  ,OtherInventoryKirbysCut
  ,OtherInventoryKirbysPercentCut
  ,TotalInventoryQty
  ,TotalInventoryCost
  ,TotalInventoryKirbysCut
  ,TotalInventoryKirbysPercentCut
  ,CD30Days_KirbysCut
  ,CD30Days_Cost
  ,CD30Days_Quantity
  ,LP30Days_KirbysCut
  ,LP30Days_Cost
  ,LP30Days_Quantity
  ,Other30Days_KirbysCut
  ,Other30Days_Cost
  ,Other30Days_Quantity
  ,Total30Days_KirbysCut
  ,Total30Days_Cost
  ,Total30Days_Quantity
  ,SoldItemsTableDaysBehind
  ,CD30Days_KirbysCut_Intermusic_FSI
  ,CD30Days_Cost_Intermusic_FSI
  ,CD30Days_Quantity_Intermusic_FSI
  ,LP30Days_KirbysCut_Intermusic_FSI
  ,LP30Days_Cost_Intermusic_FSI
  ,LP30Days_Quantity_Intermusic_FSI
  ,Other30Days_KirbysCut_Intermusic_FSI
  ,Other30Days_Cost_Intermusic_FSI
  ,Other30Days_Quantity_Intermusic_FSI
  ,Total30Days_KirbysCut_Intermusic_FSI
  ,Total30Days_Cost_Intermusic_FSI
  ,Total30Days_Quantity_Intermusic_FSI
  ,CD30Days_KirbysCut_FSI
  ,CD30Days_Cost_FSI
  ,CD30Days_Quantity_FSI
  ,LP30Days_KirbysCut_FSI
  ,LP30Days_Cost_FSI
  ,LP30Days_Quantity_FSI
  ,Other30Days_KirbysCut_FSI
  ,Other30Days_Cost_FSI
  ,Other30Days_Quantity_FSI
  ,Total30Days_KirbysCut_FSI
  ,Total30Days_Cost_FSI
  ,Total30Days_Quantity_FSI)

 values
  (isnull(@CDInventoryQty_Intermusic,0)
  ,isnull(@CDInventoryCost_Intermusic,0)
  ,isnull(@CDInventoryKirbysCut_Intermusic,0)
  ,isnull(@CDInventoryKirbysPercentCut_Intermusic,0)
  ,isnull(@LPInventoryQty_Intermusic,0)
  ,isnull(@LPInventoryCost_Intermusic,0)
  ,isnull(@LPInventoryKirbysCut_Intermusic,0)
  ,isnull(@LPInventoryKirbysPercentCut_Intermusic,0)
  ,isnull(@OtherInventoryQty_Intermusic,0)
  ,isnull(@OtherInventoryCost_Intermusic,0)
  ,isnull(@OtherInventoryKirbysCut_Intermusic,0)
  ,isnull(@OtherInventoryKirbysPercentCut_Intermusic,0)
  ,isnull(@TotalInventoryQty_Intermusic,0)
  ,isnull(@TotalInventoryCost_Intermusic,0)
  ,isnull(@TotalInventoryKirbysCut_Intermusic,0)
  ,isnull(@TotalInventoryKirbysPercentCut_Intermusic,0)
  ,isnull(@CD30Days_KirbysCut_Intermusic,0)
  ,isnull(@CD30Days_Cost_Intermusic,0)
  ,isnull(@CD30Days_Quantity_Intermusic,0)
  ,isnull(@LP30Days_KirbysCut_Intermusic,0)
  ,isnull(@LP30Days_Cost_Intermusic,0)
  ,isnull(@LP30Days_Quantity_Intermusic,0)
  ,isnull(@Other30Days_KirbysCut_Intermusic,0)
  ,isnull(@Other30Days_Cost_Intermusic,0)
  ,isnull(@Other30Days_Quantity_Intermusic,0)
  ,isnull(@Total30Days_KirbysCut_Intermusic,0)
  ,isnull(@Total30Days_Cost_Intermusic,0)
  ,isnull(@Total30Days_Quantity_Intermusic,0)
  ,isnull(@CDInventoryQty,0)
  ,isnull(@CDInventoryCost,0)
  ,isnull(@CDInventoryKirbysCut,0)
  ,isnull(@CDInventoryKirbysPercentCut,0)
  ,isnull(@LPInventoryQty,0)
  ,isnull(@LPInventoryCost,0)
  ,isnull(@LPInventoryKirbysCut,0)
  ,isnull(@LPInventoryKirbysPercentCut,0)
  ,isnull(@OtherInventoryQty,0)
  ,isnull(@OtherInventoryCost,0)
  ,isnull(@OtherInventoryKirbysCut,0)
  ,isnull(@OtherInventoryKirbysPercentCut,0)
  ,isnull(@TotalInventoryQty,0)
  ,isnull(@TotalInventoryCost,0)
  ,isnull(@TotalInventoryKirbysCut,0)
  ,isnull(@TotalInventoryKirbysPercentCut,0)
  ,isnull(@CD30Days_KirbysCut,0)
  ,isnull(@CD30Days_Cost,0)
  ,isnull(@CD30Days_Quantity,0)
  ,isnull(@LP30Days_KirbysCut,0)
  ,isnull(@LP30Days_Cost,0)
  ,isnull(@LP30Days_Quantity,0)
  ,isnull(@Other30Days_KirbysCut,0)
  ,isnull(@Other30Days_Cost,0)
  ,isnull(@Other30Days_Quantity,0)
  ,isnull(@Total30Days_KirbysCut,0)
  ,isnull(@Total30Days_Cost,0)
  ,isnull(@Total30Days_Quantity,0)
  ,isnull(@SoldItemsDaysBehind,0)
  ,isnull(@CD30Days_KirbysCut_Intermusic_FSI,0)
  ,isnull(@CD30Days_Cost_Intermusic_FSI,0)
  ,isnull(@CD30Days_Quantity_Intermusic_FSI,0)
  ,isnull(@LP30Days_KirbysCut_Intermusic_FSI,0)
  ,isnull(@LP30Days_Cost_Intermusic_FSI,0)
  ,isnull(@LP30Days_Quantity_Intermusic_FSI,0)
  ,isnull(@Other30Days_KirbysCut_Intermusic_FSI,0)
  ,isnull(@Other30Days_Cost_Intermusic_FSI,0)
  ,isnull(@Other30Days_Quantity_Intermusic_FSI,0)
  ,isnull(@Total30Days_KirbysCut_Intermusic_FSI,0)
  ,isnull(@Total30Days_Cost_Intermusic_FSI,0)
  ,isnull(@Total30Days_Quantity_Intermusic_FSI,0)
  ,isnull(@CD30Days_KirbysCut_FSI,0)
  ,isnull(@CD30Days_Cost_FSI,0)
  ,isnull(@CD30Days_Quantity_FSI,0)
  ,isnull(@LP30Days_KirbysCut_FSI,0)
  ,isnull(@LP30Days_Cost_FSI,0)
  ,isnull(@LP30Days_Quantity_FSI,0)
  ,isnull(@Other30Days_KirbysCut_FSI,0)
  ,isnull(@Other30Days_Cost_FSI,0)
  ,isnull(@Other30Days_Quantity_FSI,0)
  ,isnull(@Total30Days_KirbysCut_FSI,0)
  ,isnull(@Total30Days_Cost_FSI,0)
  ,isnull(@Total30Days_Quantity_FSI,0))
end

--Select--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

select 
 isnull(@BoughtHistory,0) as BoughtHistory
,isnull(@SoldHistory,0) as SoldHistory
,isnull(@CDInventoryQty_Intermusic,0) as CDInventoryQty_Intermusic
,isnull(@CDInventoryCost_Intermusic,0) as CDInventoryCost_Intermusic
,isnull(@CDInventoryKirbysCut_Intermusic,0) as CDInventoryKirbysCut_Intermusic
,isnull(@CDInventoryKirbysPercentCut_Intermusic,0) as CDInventoryKirbysPercentCut_Intermusic
,isnull(@LPInventoryQty_Intermusic,0) as LPInventoryQty_Intermusic
,isnull(@LPInventoryCost_Intermusic,0) as LPInventoryCost_Intermusic
,isnull(@LPInventoryKirbysCut_Intermusic,0) as LPInventoryKirbysCut_Intermusic
,isnull(@LPInventoryKirbysPercentCut_Intermusic,0) as LPInventoryKirbysPercentCut_Intermusic
,isnull(@OtherInventoryQty_Intermusic,0) as OtherInventoryQty_Intermusic
,isnull(@OtherInventoryCost_Intermusic,0) as OtherInventoryCost_Intermusic
,isnull(@OtherInventoryKirbysCut_Intermusic,0) as OtherInventoryKirbysCut_Intermusic
,isnull(@OtherInventoryKirbysPercentCut_Intermusic,0) as OtherInventoryKirbysPercentCut_Intermusic
,isnull(@TotalInventoryQty_Intermusic,0) as TotalInventoryQty_Intermusic
,isnull(@TotalInventoryCost_Intermusic,0) as TotalInventoryCost_Intermusic
,isnull(@TotalInventoryKirbysCut_Intermusic,0) as TotalInventoryKirbysCut_Intermusic
,isnull(@TotalInventoryKirbysPercentCut_Intermusic,0) as TotalInventoryKirbysPercentCut_Intermusic
,isnull(@CD30Days_KirbysCut_Intermusic,0) as CD30Days_KirbysCut_Intermusic
,isnull(@CD30Days_Cost_Intermusic,0) as CD30Days_Cost_Intermusic
,isnull(@CD30Days_Quantity_Intermusic,0) as CD30Days_Quantity_Intermusic
,isnull(@LP30Days_KirbysCut_Intermusic,0) as LP30Days_KirbysCut_Intermusic
,isnull(@LP30Days_Cost_Intermusic,0) as LP30Days_Cost_Intermusic
,isnull(@LP30Days_Quantity_Intermusic,0) as LP30Days_Quantity_Intermusic
,isnull(@Other30Days_KirbysCut_Intermusic,0) as Other30Days_KirbysCut_Intermusic
,isnull(@Other30Days_Cost_Intermusic,0) as Other30Days_Cost_Intermusic
,isnull(@Other30Days_Quantity_Intermusic,0) as Other30Days_Quantity_Intermusic
,isnull(@Total30Days_KirbysCut_Intermusic,0) as Total30Days_KirbysCut_Intermusic
,isnull(@Total30Days_Cost_Intermusic,0) as Total30Days_Cost_Intermusic
,isnull(@Total30Days_Quantity_Intermusic,0) as Total30Days_Quantity_Intermusic
,isnull(@CDInventoryQty,0) as CDInventoryQty
,isnull(@CDInventoryCost,0) as CDInventoryCost
,isnull(@CDInventoryKirbysCut,0) as CDInventoryKirbysCut
,isnull(@CDInventoryKirbysPercentCut,0) as CDInventoryKirbysPercentCut
,isnull(@LPInventoryQty,0) as LPInventoryQty
,isnull(@LPInventoryCost,0) as LPInventoryCost
,isnull(@LPInventoryKirbysCut,0) as LPInventoryKirbysCut
,isnull(@LPInventoryKirbysPercentCut,0) as LPInventoryKirbysPercentCut
,isnull(@OtherInventoryQty,0) as OtherInventoryQty
,isnull(@OtherInventoryCost,0) as OtherInventoryCost
,isnull(@OtherInventoryKirbysCut,0) as OtherInventoryKirbysCut
,isnull(@OtherInventoryKirbysPercentCut,0) as OtherInventoryKirbysPercentCut
,isnull(@TotalInventoryQty,0) as TotalInventoryQty
,isnull(@TotalInventoryCost,0) as TotalInventoryCost
,isnull(@TotalInventoryKirbysCut,0) as TotalInventoryKirbysCut
,isnull(@TotalInventoryKirbysPercentCut,0) as TotalInventoryKirbysPercentCut
,isnull(@CD30Days_KirbysCut,0) as CD30Days_KirbysCut
,isnull(@CD30Days_Cost,0) as CD30Days_Cost
,isnull(@CD30Days_Quantity,0) as CD30Days_Quantity
,isnull(@LP30Days_KirbysCut,0) as LP30Days_KirbysCut
,isnull(@LP30Days_Cost,0) as LP30Days_Cost
,isnull(@LP30Days_Quantity,0) as LP30Days_Quantity
,isnull(@Other30Days_KirbysCut,0) as Other30Days_KirbysCut
,isnull(@Other30Days_Cost,0) as Other30Days_Cost
,isnull(@Other30Days_Quantity,0) as Other30Days_Quantity
,isnull(@Total30Days_KirbysCut,0) as Total30Days_KirbysCut
,isnull(@Total30Days_Cost,0) as Total30Days_Cost
,isnull(@Total30Days_Quantity,0) as Total30Days_Quantity

,@SoldItemsDaysBehind as SoldItemsDaysBehind
,isnull(@SoldHistory_FSI,0) as SoldHistory_FSI
,isnull(@CD30Days_KirbysCut_Intermusic_FSI,0) as CD30Days_KirbysCut_Intermusic_FSI
,isnull(@CD30Days_Cost_Intermusic_FSI,0) as CD30Days_Cost_Intermusic_FSI
,isnull(@CD30Days_Quantity_Intermusic_FSI,0) as CD30Days_Quantity_Intermusic_FSI
,isnull(@LP30Days_KirbysCut_Intermusic_FSI,0) as LP30Days_KirbysCut_Intermusic_FSI
,isnull(@LP30Days_Cost_Intermusic_FSI,0) as LP30Days_Cost_Intermusic_FSI
,isnull(@LP30Days_Quantity_Intermusic_FSI,0) as LP30Days_Quantity_Intermusic_FSI
,isnull(@Other30Days_KirbysCut_Intermusic_FSI,0) as Other30Days_KirbysCut_Intermusic_FSI
,isnull(@Other30Days_Cost_Intermusic_FSI,0) as Other30Days_Cost_Intermusic_FSI
,isnull(@Other30Days_Quantity_Intermusic_FSI,0) as Other30Days_Quantity_Intermusic_FSI
,isnull(@Total30Days_KirbysCut_Intermusic_FSI,0) as Total30Days_KirbysCut_Intermusic_FSI
,isnull(@Total30Days_Cost_Intermusic_FSI,0) as Total30Days_Cost_Intermusic_FSI
,isnull(@Total30Days_Quantity_Intermusic_FSI,0) as Total30Days_Quantity_Intermusic_FSI
,isnull(@CD30Days_KirbysCut_FSI,0) as CD30Days_KirbysCut_FSI
,isnull(@CD30Days_Cost_FSI,0) as CD30Days_Cost_FSI
,isnull(@CD30Days_Quantity_FSI,0) as CD30Days_Quantity_FSI
,isnull(@LP30Days_KirbysCut_FSI,0) as LP30Days_KirbysCut_FSI
,isnull(@LP30Days_Cost_FSI,0) as LP30Days_Cost_FSI
,isnull(@LP30Days_Quantity_FSI,0) as LP30Days_Quantity_FSI
,isnull(@Other30Days_KirbysCut_FSI,0) as Other30Days_KirbysCut_FSI
,isnull(@Other30Days_Cost_FSI,0) as Other30Days_Cost_FSI
,isnull(@Other30Days_Quantity_FSI,0) as Other30Days_Quantity_FSI
,isnull(@Total30Days_KirbysCut_FSI,0) as Total30Days_KirbysCut_FSI
,isnull(@Total30Days_Cost_FSI,0) as Total30Days_Cost_FSI
,isnull(@Total30Days_Quantity_FSI,0) as Total30Days_Quantity_FSI









