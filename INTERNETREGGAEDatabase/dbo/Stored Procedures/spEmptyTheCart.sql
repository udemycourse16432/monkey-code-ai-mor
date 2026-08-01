CREATE PROCEDURE [dbo].[spEmptyTheCart]
  @CartName nvarchar(60)
AS

insert into Carts_log (ts, event_name, cart_name, delete_cnt, carts_affected, total_cnt) values (
  CURRENT_TIMESTAMP,
  'spEmptyTheCart',
  @CartName,
  (select count(*) from Carts where CartName=@CartName),
  1,
  (select count(*) from Carts)
);

delete Carts where CartName=@CartName;
