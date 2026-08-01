

create PROCEDURE [dbo].KIRBY_INVENTORY_CHECK_2 as

select max(inventory)-min(inventory) from orderitems
where inventoryid=277702
and OrderItemsDateTime>= '3/3/2024'


select sum(quantity) from orderitems
where inventoryid=277702
and OrderItemsDateTime>= '3/3/2024'




select * from orderitems
where inventoryid=277702
and OrderItemsDateTime>= '3/3/2024'
 order by counter desc

