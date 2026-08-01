CREATE PROCEDURE [dbo].[AdjustCart]
  @ID int,
  @Price smallmoney,
  @Type int,
  @Qty int,
  @CartName nvarchar(60),
  @IPAddress nvarchar(20),
  @SearchCriteriaStatisticsID nvarchar(50),
  @CustomerID int
AS

insert into Carts_log (ts, event_name, cart_name, delete_cnt, carts_affected, total_cnt) values (
  CURRENT_TIMESTAMP,
  'AdjustCart',
  @CartName,
  0,
  0,
  (select count(*) from Carts)
);

BEGIN
  if @Qty>0
  BEGIN
    if exists (select ItemID from Carts where CartName=@CartName and ItemID=@ID)
    BEGIN
      update Carts set Quantity=@Qty, Price=@Price, [DateTime]=GetDate() where CartName=@CartName and ItemID=@ID;
    END 
    else
    BEGIN
      insert into Carts (ItemID, Price, Quantity, CartName, IPAddress, SearchCriteriaStatisticsID)
      values (@ID, @Price, @Qty, @CartName, @IPAddress, @SearchCriteriaStatisticsID);
    END
  END
  else 
  BEGIN
    delete Carts where CartName=@CartName and ItemID=@ID;
    if @Type=-2
    BEGIN
      delete from BackordersInStockNow where BackorderInventoryID=@ID and CustomerID=@CustomerID;
      insert DeleteBackordersInStockNow (CustomerID,DeleteBackorderInventoryID) values (@CustomerID, @ID);
    END
  END
END
