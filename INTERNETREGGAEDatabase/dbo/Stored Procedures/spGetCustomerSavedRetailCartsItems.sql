

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spGetCustomerSavedRetailCartsItems]

 @Email nvarchar(100)


AS

select Inventory,Email,CartPassword,Quantity,DateTime,Format,ArtistTitle,[formatorder],[UsedItem],Inventory.ID as ID from WebSavedRetailCarts
inner join Inventory on WebSavedRetailCarts.InventoryID=Inventory.ID
where email like '%' + @Email + '%'
order by Email,CartPassword,[formatorder], [UsedItem],ArtistTitle
