CREATE PROCEDURE [dbo].[spUpdateSalesLast30Days]
as

begin transaction UpdateSales

if object_id('tempdb..#SalesFigures') is not null
 drop table #SalesFigures

create table #SalesFigures (ItemID int, Qty int)

delete #SalesFigures
insert #SalesFigures (ItemID,Qty)
select ItemID, sum(Quantity) from SoldItems
where Quantity>0
and InvoiceDate>=getdate()-30
group by ItemID

update inventory set SalesLast30Days=null where SalesLast30Days is not null

Update Inventory
set SalesLast30Days=#SalesFigures.Qty
from #SalesFigures inner join Inventory on #SalesFigures.ItemID=Inventory.ID

commit transaction UpdateSales
