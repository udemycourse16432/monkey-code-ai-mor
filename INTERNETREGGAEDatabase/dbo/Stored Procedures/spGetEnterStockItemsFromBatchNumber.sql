







-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spGetEnterStockItemsFromBatchNumber] 

 @Batch int
,@WorkerID int

AS

select * from EnterStock where Batch=@Batch and WorkerID=@WorkerID
order by counter desc

