


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].spGetItemDetails

 @ID int

AS

select * from Inventory
where [ID] = @ID and deleted='n'


