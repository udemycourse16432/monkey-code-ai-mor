








-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spMarkBatchAsCompleted] 

 @Batch int
,@WorkerID int

AS

update EnterStock
set Status='completed'
where Batch=@Batch and WorkerID=@WorkerID


