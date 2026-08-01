CREATE PROCEDURE [dbo].[spCartPricesSalePricesToo]

 @NameOfCart nvarchar(60)

AS

select Carts.counter as CartCounter,Price,Carts.ItemID,RetailPrice,StorePrice,ExportPrice,Sale_RetailPrice,Sale_RetailEndDate,Sale_WholesalePrice,Sale_WholesaleEndDate from Carts
  inner join inventory on carts.itemid=inventory.id
  where Carts.CartName=@NameOfCart
  and inventory.inventory>0