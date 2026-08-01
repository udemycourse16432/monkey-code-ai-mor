







-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spGetEnterStockItemsForScans] 

 @Batch int
,@WorkerID int

AS

select * from EnterStock where Batch=@Batch and WorkerID=@WorkerID
order by counter 

