CREATE PROCEDURE [dbo].[spDeleteCart]
  @CartName nvarchar(60)
AS

insert into Carts_log (ts, event_name, cart_name, delete_cnt, carts_affected, total_cnt) values (
  CURRENT_TIMESTAMP,
  'spDeleteCart',
  @CartName,
  (select count(*) from Carts where CartName=@CartName),
  1,
  (select count(*) from Carts)
);

delete from Carts where CartName=@CartName;
