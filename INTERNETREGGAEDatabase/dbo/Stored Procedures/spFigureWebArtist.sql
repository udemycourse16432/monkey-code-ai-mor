
CREATE PROCEDURE spFigureWebArtist 

 @ID int
,@WebArtistFormat nvarchar(50)
,@IsInStock nvarchar(1)
,@Artist1 nvarchar(255)
,@Artist2 nvarchar(255)
,@Artist3 nvarchar(255)
,@Artist4 nvarchar(255)
,@Artist5 nvarchar(255)
,@Artist6 nvarchar(255)

AS

--Artist1
if @Artist1<>'---'
begin
if exists (select InventoryID from WebArtists
   where InventoryID=@ID and Artist=@Artist1)
    begin
     Update WebArtists set
      [Format]=@WebArtistFormat
     ,InStock=@IsInStock
     where InventoryID=@ID and Artist=@Artist1
    end
else
    begin
     insert into WebArtists
     (Artist
     ,InventoryID
     ,[Format]
     ,InStock)
     values
     (@Artist1
     ,@ID
     ,@WebArtistFormat
     ,@IsInStock)
    end
end

--Artist2
if @Artist2<>'---'
begin
if exists (select InventoryID from WebArtists
   where InventoryID=@ID and Artist=@Artist2)
    begin
     Update WebArtists set
      [Format]=@WebArtistFormat
     ,InStock=@IsInStock
     where InventoryID=@ID and Artist=@Artist2
    end
else
    begin
     insert into WebArtists
     (Artist
     ,InventoryID
     ,[Format]
     ,InStock)
     values
     (@Artist2
     ,@ID
     ,@WebArtistFormat
     ,@IsInStock)
    end
end
--Artist3
if @Artist3<>'---'
begin
if exists (select InventoryID from WebArtists
   where InventoryID=@ID and Artist=@Artist3)
    begin
     Update WebArtists set
      [Format]=@WebArtistFormat
     ,InStock=@IsInStock
     where InventoryID=@ID and Artist=@Artist3
    end
else
    begin
     insert into WebArtists
     (Artist
     ,InventoryID
     ,[Format]
     ,InStock)
     values
     (@Artist3
     ,@ID
     ,@WebArtistFormat
     ,@IsInStock)
    end
end
--Artist4
if @Artist4<>'---'
begin
if exists (select InventoryID from WebArtists
   where InventoryID=@ID and Artist=@Artist4)
    begin
     Update WebArtists set
      [Format]=@WebArtistFormat
     ,InStock=@IsInStock
     where InventoryID=@ID and Artist=@Artist4
    end
else
    begin
     insert into WebArtists
     (Artist
     ,InventoryID
     ,[Format]
     ,InStock)
     values
     (@Artist4
     ,@ID
     ,@WebArtistFormat
     ,@IsInStock)
    end
end
--Artist5
if @Artist5<>'---'
begin
if exists (select InventoryID from WebArtists
   where InventoryID=@ID and Artist=@Artist5)
    begin
     Update WebArtists set
      [Format]=@WebArtistFormat
     ,InStock=@IsInStock
     where InventoryID=@ID and Artist=@Artist5
    end
else
    begin
     insert into WebArtists
     (Artist
     ,InventoryID
     ,[Format]
     ,InStock)
     values
     (@Artist5
     ,@ID
     ,@WebArtistFormat
     ,@IsInStock)
    end
end
--Artist6
if @Artist6<>'---'
begin
if exists (select InventoryID from WebArtists
   where InventoryID=@ID and Artist=@Artist6)
    begin
     Update WebArtists set
      [Format]=@WebArtistFormat
     ,InStock=@IsInStock
     where InventoryID=@ID and Artist=@Artist6
    end
else
    begin
     insert into WebArtists
     (Artist
     ,InventoryID
     ,[Format]
     ,InStock)
     values
     (@Artist6
     ,@ID
     ,@WebArtistFormat
     ,@IsInStock)
    end
end