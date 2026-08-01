







-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spGetEnter7InchItemsFromBatchNumber] 

 @Batch nvarchar(50)
,@WorkerID int

AS

select * from Enter7Inch where Batch=@Batch and WorkerID=@WorkerID
order by counter desc

