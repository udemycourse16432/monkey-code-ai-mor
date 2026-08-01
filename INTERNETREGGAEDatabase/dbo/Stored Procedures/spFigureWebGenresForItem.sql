





-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spFigureWebGenresForItem]

 @ID int
,@Inventory int
,@Deleted nvarchar(1)
,@ShowOnWebsite nvarchar(1)
,@Format nvarchar(7)
,@Genre1 nvarchar(30)
,@Genre2 nvarchar(30)
,@Genre3 nvarchar(30)
,@Genre4 nvarchar(30)
,@Genre5 nvarchar(30)
,@Genre6 nvarchar(30)
,@Genre7 nvarchar(30)
,@Genre8 nvarchar(30)
,@Genre9 nvarchar(30)

AS

declare @WebGenreFormat nvarchar(50)
if @Format='CD'
 set @WebGenreFormat='CD'
else if @Format='LP' or @Format='12"' or @Format='10"' or @Format='7"'
 set @WebGenreFormat='Vinyl'
else
 set @WebGenreFormat='Other'

declare @IsInStock nvarchar(1)
if @Inventory>0 and @Deleted='n' and @ShowOnWebsite='y'
 set @IsInStock='y'
else
 set @IsInStock='n'

--WebGenres table--------------------------------------------------------------------------------

--Genre1
if @Genre1 <>'---'
begin
if exists (select InventoryID from WebGenres
   where InventoryID=@ID and Genre=@Genre1)
    begin
     Update WebGenres set
      [Format]=@WebGenreFormat
     ,InStock=@IsInStock
     where InventoryID=@ID and Genre=@Genre1
    end
else
    begin
     insert into WebGenres
     (Genre
     ,InventoryID
     ,[Format]
     ,InStock)
     values
     (@Genre1
     ,@ID
     ,@WebGenreFormat
     ,@IsInStock)
    end
end

--Genre2
if @Genre2 <>'---'
begin
if exists (select InventoryID from WebGenres
   where InventoryID=@ID and Genre=@Genre2)
    begin
     Update WebGenres set
      [Format]=@WebGenreFormat
     ,InStock=@IsInStock
     where InventoryID=@ID and Genre=@Genre2
    end
else
    begin
     insert into WebGenres
     (Genre
     ,InventoryID
     ,[Format]
     ,InStock)
     values
     (@Genre2
     ,@ID
     ,@WebGenreFormat
     ,@IsInStock)
    end
end

--Genre3
if @Genre3 <>'---'
begin
if exists (select InventoryID from WebGenres
   where InventoryID=@ID and Genre=@Genre3)
    begin
     Update WebGenres set
      [Format]=@WebGenreFormat
     ,InStock=@IsInStock
     where InventoryID=@ID and Genre=@Genre3
    end
else
    begin
     insert into WebGenres
     (Genre
     ,InventoryID
     ,[Format]
     ,InStock)
     values
     (@Genre3
     ,@ID
     ,@WebGenreFormat
     ,@IsInStock)
    end
end

--Genre4
if @Genre4 <>'---'
begin
if exists (select InventoryID from WebGenres
   where InventoryID=@ID and Genre=@Genre4)
    begin
     Update WebGenres set
      [Format]=@WebGenreFormat
     ,InStock=@IsInStock
     where InventoryID=@ID and Genre=@Genre4
    end
else
    begin
     insert into WebGenres
     (Genre
     ,InventoryID
     ,[Format]
     ,InStock)
     values
     (@Genre4
     ,@ID
     ,@WebGenreFormat
     ,@IsInStock)
    end
end

--Genre5
if @Genre5 <>'---'
begin
if exists (select InventoryID from WebGenres
   where InventoryID=@ID and Genre=@Genre5)
    begin
     Update WebGenres set
      [Format]=@WebGenreFormat
     ,InStock=@IsInStock
     where InventoryID=@ID and Genre=@Genre5
    end
else
    begin
     insert into WebGenres
     (Genre
     ,InventoryID
     ,[Format]
     ,InStock)
     values
     (@Genre5
     ,@ID
     ,@WebGenreFormat
     ,@IsInStock)
    end
end

--Genre6
if @Genre6 <>'---'
begin
if exists (select InventoryID from WebGenres
   where InventoryID=@ID and Genre=@Genre6)
    begin
     Update WebGenres set
      [Format]=@WebGenreFormat
     ,InStock=@IsInStock
     where InventoryID=@ID and Genre=@Genre6
    end
else
    begin
     insert into WebGenres
     (Genre
     ,InventoryID
     ,[Format]
     ,InStock)
     values
     (@Genre6
     ,@ID
     ,@WebGenreFormat
     ,@IsInStock)
    end
end

--Genre7
if @Genre7 <>'---'
begin
if exists (select InventoryID from WebGenres
   where InventoryID=@ID and Genre=@Genre7)
    begin
     Update WebGenres set
      [Format]=@WebGenreFormat
     ,InStock=@IsInStock
     where InventoryID=@ID and Genre=@Genre7
    end
else
    begin
     insert into WebGenres
     (Genre
     ,InventoryID
     ,[Format]
     ,InStock)
     values
     (@Genre7
     ,@ID
     ,@WebGenreFormat
     ,@IsInStock)
    end
end

--Genre8
if @Genre8 <>'---'
begin
if exists (select InventoryID from WebGenres
   where InventoryID=@ID and Genre=@Genre8)
    begin
     Update WebGenres set
      [Format]=@WebGenreFormat
     ,InStock=@IsInStock
     where InventoryID=@ID and Genre=@Genre8
    end
else
    begin
     insert into WebGenres
     (Genre
     ,InventoryID
     ,[Format]
     ,InStock)
     values
     (@Genre8
     ,@ID
     ,@WebGenreFormat
     ,@IsInStock)
    end
end

--Genre9
if @Genre9 <>'---'
begin
if exists (select InventoryID from WebGenres
   where InventoryID=@ID and Genre=@Genre9)
    begin
     Update WebGenres set
      [Format]=@WebGenreFormat
     ,InStock=@IsInStock
     where InventoryID=@ID and Genre=@Genre9
    end
else
    begin
     insert into WebGenres
     (Genre
     ,InventoryID
     ,[Format]
     ,InStock)
     values
     (@Genre9
     ,@ID
     ,@WebGenreFormat
     ,@IsInStock)
    end
end











