CREATE PROCEDURE [dbo].[spDeleteCartItem]
  @CartName nvarchar(60),
  @ItemID int
AS

insert into Carts_log (ts, event_name, cart_name, delete_cnt, carts_affected, total_cnt) values (
  CURRENT_TIMESTAMP,
  'spDeleteCartItem',
  @CartName,
  1,
  1,
  (select count(*) from Carts)
);

delete from Carts where ItemID=@ItemID and CartName=@CartName;
