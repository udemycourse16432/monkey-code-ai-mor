




-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spGetWeightOfProduct]

@CartName nvarchar(60)
AS

--SET NOCOUNT ON; -- Stop wasting network traffic with "x rows affected"

select isnull(sum(
case when Quantity>=Inventory then WeightInGrams*Inventory
else WeightInGrams*Quantity
end
),0) as sumweight from Carts
left join inventory on Carts.ItemID = inventory.ID
where CartName=@CartName
and inventory >0
and SaveForLater is null


