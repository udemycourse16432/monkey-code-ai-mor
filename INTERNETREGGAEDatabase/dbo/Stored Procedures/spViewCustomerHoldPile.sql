

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spViewCustomerHoldPile]

 @HoldPileNumber nvarchar(20)

AS

select InventoryID,HoldPileItemsForWeb.HoldPileNumber as HoldPileNumber,Format,Quantity,OverflowQuantity,ArtistTitle,ItemDetailsWeb,HoldPilesForWeb.Date as [Date],HoldPileStatus,HoldPrice,label
,FullName,StreetAddress1,StreetAddress2,City,Island,StateProvince,PostalCode,Country,ShippingMethod,GiftCardAmount,OrderProcessChoice,Tax,Shipping,OrderTotal
 from ((HoldPilesForWeb inner join HoldPileItemsForWeb on HoldPilesForWeb.HoldPileNumber=HoldPileItemsForWeb.HoldPileNumber)
 Left Join Inventory on HoldPileItemsForWeb.InventoryID=Inventory.ID)
 Left Join Orders on HoldPilesForWeb.HoldPileNumber=Orders.OrderNumber
 where HoldPileItemsForWeb.HoldPileNumber=@HoldPileNumber
 and HoldPileStatus<>'Canceled' and HoldPileStatus<>'Invoiced'
 and (Quantity>0 or OverflowQuantity>0)
 order by [Format],ArtistTitle



