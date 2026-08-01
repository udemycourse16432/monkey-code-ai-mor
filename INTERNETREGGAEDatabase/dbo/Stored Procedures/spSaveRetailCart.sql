
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].spSaveRetailCart

 @CartPassword nvarchar(50)
,@Email nvarchar(100)
,@CartName nvarchar(60)
,@IPAddress nvarchar(20)

AS

delete from WebSavedRetailCarts
where CartPassword=@CartPassword
and Email=@Email
INSERT INTO WebSavedRetailCarts (InventoryID,DateTime,Price,SearchCriteriaStatisticsID,Quantity,IPAddress
,Email,CartPassword)
SELECT
Inventory.ID
,Carts.[DateTime]
,Carts.Price
,Carts.SearchCriteriaStatisticsID
,Carts.Quantity
,@IPAddress
,@Email
,@CartPassword
FROM Carts
INNER JOIN inventory on Carts.ItemID = inventory.ID
where CartName=@CartName