CREATE PROCEDURE [dbo].[spDeleteOldCartItems]
AS

insert into Carts_log (ts, event_name, cart_name, delete_cnt, carts_affected, total_cnt) values (
  CURRENT_TIMESTAMP,
  'spDeleteOldCartItems',
  CONCAT((select count(*) from carts where datetime<getdate()-360),'/',(select count(*) from Carts where datetime<getdate()-60 and cartname not like 'W_CART%')),
  0,
  0,
  (select count(*) from Carts)
);

delete carts where datetime<getdate()-360;

delete carts where datetime<getdate()-60 and cartname not like 'W_CART%';
