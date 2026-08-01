







-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spUpdateEnter7InchItem] 

 @counter int
,@Quantity int
,@SideATrack1 nvarchar(200)
,@SideBTrack1 nvarchar(150)
,@Label nvarchar(130)
,@Year nvarchar(30)
,@RhythmName nvarchar(400)
,@Genre1 nvarchar(30)
,@WallCatalogLetter nvarchar(5)
,@WallCatalogNumber int
,@Description1 nvarchar(100)
,@Description2 nvarchar(250)
,@FullDescription nvarchar(350)

AS


update Enter7Inch
set
 Quantity=@Quantity
,SideATrack1 =@SideATrack1
,SideBTrack1 =@SideBTrack1
,[Label]=@Label
,[Year] =@Year
,RhythmName=@RhythmName
,Genre1 =@Genre1
,WallCatalogLetter =@WallCatalogLetter
,WallCatalogNumber =@WallCatalogNumber
,Description1 =@WallCatalogLetter
,Description2 =@Description2
,FullDescription =@FullDescription
where counter=@counter







