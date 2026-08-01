



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spGetCartNumberOfLineItems]

@CartName nvarchar(60)
AS

select count(counter) as NumberOfLineItems from Carts
left join inventory on Carts.ItemID = inventory.ID
where CartName =@CartName
and SaveForLater is null

