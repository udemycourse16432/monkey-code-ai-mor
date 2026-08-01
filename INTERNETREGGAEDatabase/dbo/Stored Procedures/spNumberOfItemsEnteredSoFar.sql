








CREATE PROCEDURE [dbo].[spNumberOfItemsEnteredSoFar]

 @Batch int
,@WorkerID int
AS

select count(counter) as Total from EnterStock
where Batch=@Batch
and WorkerID=@WorkerID

















