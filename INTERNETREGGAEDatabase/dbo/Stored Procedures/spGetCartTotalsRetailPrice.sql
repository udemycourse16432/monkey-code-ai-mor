




-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spGetCartTotalsRetailPrice]

@CartName nvarchar(60)
AS

select Quantity
,Carts.DateTime
,datediff(day,Carts.DateTime,GetDate()) as datedifference
,Price,
case
 when Price<RetailPrice and datediff(day,Carts.DateTime,GetDate())<=30 then Price
 else RetailPrice
end as PriceForCart
,RetailPrice,Format from Inventory
left join Carts on Inventory.ID = Carts.ItemID
where Carts.CartName=@CartName
and Inventory>0
and SaveForLater is null
order by [formatorder]


