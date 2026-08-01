







-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spUpdateEnterStockItem] 

 @counter int
,@UPC nvarchar(50)
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

AS


update EnterStock
set
 UPC=@UPC
,Artist=@Artist
,Title=@Title
,Label=@Label
,Genre1=@Genre1
,Genre2=@Genre2
,Genre3=@Genre3
,Catalog=@Catalog
,WallCatalogLetter=@WallCatalogLetter
,WallCatalogNumber=@WallCatalogNumber
,Quantity=@Quantity
,Price=@Price
where counter=@counter







