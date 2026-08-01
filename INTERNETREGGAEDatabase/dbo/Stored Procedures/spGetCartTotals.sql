




-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spGetCartTotals]

@CartName nvarchar(60)
AS

select isnull(sum(quantity),0) as sumquantity
,isnull(sum(case
 when Price<RetailPrice and datediff(day,Carts.DateTime,GetDate())<=30 then Price*Quantity
 else RetailPrice*Quantity
end),0) as sumprice
,isnull(sum(WeightInGrams*quantity),0) as sumweight from Carts
left join inventory on Carts.ItemID = inventory.ID
where CartName=@CartName
and inventory >0
and SaveForLater is null


