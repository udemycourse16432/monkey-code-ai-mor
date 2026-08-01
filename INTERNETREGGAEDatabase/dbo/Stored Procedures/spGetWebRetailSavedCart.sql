

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spGetWebRetailSavedCart]

 @CartPassword nvarchar(50)
,@Email nvarchar(100)

AS

select * from WebSavedRetailCarts
inner join Inventory on WebSavedRetailCarts.InventoryID=Inventory.ID
where CartPassword=@CartPassword
and Email=@Email
