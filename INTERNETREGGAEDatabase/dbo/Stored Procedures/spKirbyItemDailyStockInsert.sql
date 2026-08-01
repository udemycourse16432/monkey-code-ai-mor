


create PROCEDURE [dbo].[spKirbyItemDailyStockInsert]

as

insert into KirbyItemsStockHistory
(ItemID
,Inventory)

select
 ID
,Inventory
from inventory
where KirbyItem='y'
order by ID