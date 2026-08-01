








CREATE PROCEDURE [dbo].[spGetWallIDSeed]

 @Batch int
,@WorkerID int
AS

select isnull(min(WallID),1) as WallIDSeed from EnterStock
where Batch=@Batch
and WorkerID=@WorkerID

















