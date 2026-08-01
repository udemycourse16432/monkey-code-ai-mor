










-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spGetHighestBatchNumber] 

@WorkerID int

AS

select isnull(max(Batch),0) as HighestBatch from EnterStock
where WorkerID=@WorkerID




