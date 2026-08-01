

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].spGetInventoryItem

 @ID int

AS

select * from Inventory
where ID=@ID

