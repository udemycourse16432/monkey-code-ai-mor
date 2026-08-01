

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spGetWeightOfCart]

@CartName nvarchar(60)

AS

select Sum([WeightInGrams]*[quantity]) AS Weight
from Carts inner join inventory on ItemID=ID
where Carts.CartName=@CartName
and Inventory.Inventory>0
and SaveForLater is null
