








-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spEnter7Inch] 

 @Quantity int
,@SideATrack1 nvarchar(200)
,@SideBTrack1 nvarchar(150)
,@Label nvarchar(130)
,@Year nvarchar(30)
,@RhythmName nvarchar(400)
,@WallCatalogLetter nvarchar(5)
,@WallCatalogNumber int
,@Genre1 nvarchar(30)
,@Genre2 nvarchar(30)
,@Genre3 nvarchar(30)
,@Description1 nvarchar(100)
,@Description2 nvarchar(250)
,@FullDescription nvarchar(350)
,@Worker nvarchar(100)
,@WorkerID int
,@Batch nvarchar(50)
,@RandomNumberID nvarchar(50)


AS

declare @HighestWallID int
set @HighestWallID=(select isnull(max(WallID),0) from Enter7Inch where WorkerID=@WorkerID)

insert into Enter7Inch
(Quantity
,SideATrack1
,SideBTrack1
,[Label]
,[Year]
,RhythmName
,WallCatalogLetter
,WallCatalogNumber
,Genre1
,Genre2
,Genre3
,Description1
,Description2
,FullDescription
,Worker
,WorkerID
,Batch
,RandomNumberID
,WallID)
values
(@Quantity
,@SideATrack1
,@SideBTrack1
,@Label
,@Year
,@RhythmName
,@WallCatalogLetter
,@WallCatalogNumber
,@Genre1
,@Genre2
,@Genre3
,@Description1
,@Description2
,@FullDescription
,@Worker
,@WorkerID
,@Batch
,@RandomNumberID
,@HighestWallID+1)








