








-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spMark7InchBatchAsCompleted] 

 @Batch nvarchar(50)
,@WorkerID int

AS

update Enter7Inch
set Status='completed'
where Batch=@Batch and WorkerID=@WorkerID


