
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].spHTTPUpdates_HoldPileItemsForWebQUANTITYONLY

 @HoldPileNumber nvarchar(20)
,@InventoryID int
,@Quantity int
,@OverflowQuantity int

AS

  UPDATE HoldPileItemsForWeb SET
  Quantity =@Quantity
  ,OverflowQuantity =@OverflowQuantity
  WHERE HoldPileNumber=@HoldPileNumber
  AND InventoryID=@InventoryID
