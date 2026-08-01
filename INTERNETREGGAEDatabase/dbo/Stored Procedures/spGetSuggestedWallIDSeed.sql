
CREATE PROCEDURE [dbo].[spGetSuggestedWallIDSeed]

 @Batch int
,@WorkerID int

AS

select isnull(max(WallID),0)+1 as SuggestedWallIDSeed from EnterStock
where WorkerID=@WorkerID
and Batch=@Batch-1
