
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].spHTTPUpdates_HoldPileItems

 @HoldPileNumber nvarchar(20)
,@InventoryID int
,@Quantity int
,@HoldPrice money
,@OverflowQuantity int
,@DownloadGroup int
,@ItemStatus nvarchar(20)
,@CustID nvarchar(30)
,@TagCodeSuffix int

AS

IF EXISTS (Select HoldPileNumber from HoldPileItemsForWeb
 WHERE HoldPileNumber=@HoldPileNumber
 AND InventoryID=@InventoryID)

 BEGIN
  UPDATE HoldPileItemsForWeb SET
   HoldPileNumber =@HoldPileNumber
  ,InventoryID =@InventoryID
  ,Quantity =@Quantity
  ,HoldPrice =@HoldPrice
  ,OverflowQuantity =@OverflowQuantity
  ,DownloadGroup =@DownloadGroup
  ,ItemStatus =@ItemStatus
  ,CustID =@CustID
  ,TagCodeSuffix=@TagCodeSuffix
  WHERE HoldPileNumber=@HoldPileNumber
  AND InventoryID=@InventoryID
 END

ELSE

 BEGIN
  INSERT INTO HoldPileItemsForWeb
  (HoldPileNumber
  ,InventoryID
  ,Quantity
  ,HoldPrice
  ,OverflowQuantity
  ,DownloadGroup
  ,ItemStatus
  ,CustID
  ,TagCodeSuffix)
  VALUES
  (@HoldPileNumber
  ,@InventoryID
  ,@Quantity
  ,@HoldPrice
  ,@OverflowQuantity
  ,@DownloadGroup
  ,@ItemStatus
  ,@CustID
  ,@TagCodeSuffix)
 END
