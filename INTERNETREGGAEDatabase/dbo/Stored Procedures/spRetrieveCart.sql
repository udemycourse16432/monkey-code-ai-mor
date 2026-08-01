

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spRetrieveCart]

 @CartPassword nvarchar(50)
,@Email nvarchar(100)
,@CartName nvarchar(60)
,@IPAddress nvarchar(20)

AS

DELETE Carts
FROM Carts
INNER JOIN WebSavedRetailCarts on Carts.ItemId=WebSavedRetailCarts.InventoryID
WHERE Carts.CartName=@CartName
AND WebSavedRetailCarts.Email=@Email
AND WebSavedRetailCarts.CartPassword=@CartPassword

INSERT INTO Carts (ItemID,DateTime,Price,Quantity,CartName,IPAddress,SearchCriteriaStatisticsID)
SELECT
Inventory.ID
,getdate()
,Inventory.RetailPrice
,WebSavedRetailCarts.Quantity
,@CartName
,@IPAddress
, WebSavedRetailCarts.SearchCriteriaStatisticsID
FROM WebSavedRetailCarts
inner JOIN inventory on WebSavedRetailCarts.InventoryID = inventory.ID
WHERE CartPassword=@CartPassword and Email=@Email
