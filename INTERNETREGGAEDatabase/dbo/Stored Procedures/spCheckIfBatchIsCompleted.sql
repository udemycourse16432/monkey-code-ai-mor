










-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spCheckIfBatchIsCompleted] 

 @Batch int
,@WorkerID int

AS

select * from EnterStock
where (Status='completed' or Status='downloaded')
and Batch=@Batch
and WorkerID=@WorkerID




