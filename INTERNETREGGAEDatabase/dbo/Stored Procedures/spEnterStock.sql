








-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spEnterStock] 

 @UPC nvarchar(50)
,@Artist nvarchar(150)
,@Title nvarchar(150)
,@Label nvarchar(130)
,@Genre1 nvarchar(30)
,@Genre2 nvarchar(30)
,@Genre3 nvarchar(30)
,@Catalog nvarchar(50)
,@WallCatalogLetter nvarchar(5)
,@WallCatalogNumber int
,@Quantity int
,@Price numeric(10,2)
,@Worker nvarchar(100)
,@WorkerID int
,@Batch int
,@RandomNumberID nvarchar(50)
,@WallIDSeed int
,@UsedItem nvarchar(1)

AS

declare @HighestWallID int
set @HighestWallID=(select isnull(max(WallID),0) from EnterStock where WorkerID=@WorkerID and Batch=@Batch)
if @HighestWallID =0
 set @HighestWallID=@WallIDSeed-1

insert into EnterStock
(UPC
,Artist
,Title
,Label
,Genre1
,Genre2
,Genre3
,[Catalog]
,WallCatalogLetter
,WallCatalogNumber
,Quantity
,Price
,Worker
,WorkerID
,Batch
,RandomNumberID
,WallID
,Useditem)
values
(@UPC
,@Artist
,@Title
,@Label
,@Genre1
,@Genre2
,@Genre3
,@Catalog
,@WallCatalogLetter
,@WallCatalogNumber
,@Quantity
,@Price
,@Worker
,@WorkerID
,@Batch
,@RandomNumberID
,@HighestWallID+1
,@UsedItem)








