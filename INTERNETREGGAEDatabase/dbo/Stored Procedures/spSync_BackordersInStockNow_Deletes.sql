





-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spSync_BackordersInStockNow_Deletes]

@counter int

AS

delete BackordersInStockNow where counter=@counter





