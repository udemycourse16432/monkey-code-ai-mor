
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CartNumberOfItems]

@CartName nvarchar(60)
AS
BEGIN
 select sum(Quantity) as SumOfQuantity
 from Carts
 inner join Inventory on Carts.ItemID=Inventory.ID
 where Inventory>0
 and CartName like @CartName

END

