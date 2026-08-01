

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spGetCartTotalsGrouped]

@CartName nvarchar(60)

AS

select format, sum(quantity) as sumquantity from Carts
left join inventory on Carts.ItemID = inventory.ID
where Carts.CartName=@CartName and Inventory>0
group by format
