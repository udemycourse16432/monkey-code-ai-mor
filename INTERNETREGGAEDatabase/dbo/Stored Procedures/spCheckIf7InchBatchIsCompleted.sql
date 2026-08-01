










-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spCheckIf7InchBatchIsCompleted] 

 @Batch nvarchar(50)
,@WorkerID int

AS

select * from Enter7Inch
where (Status='completed' or Status='downloaded')
and Batch=@Batch
and WorkerID=@WorkerID




