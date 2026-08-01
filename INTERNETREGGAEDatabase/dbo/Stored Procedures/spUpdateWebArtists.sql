










CREATE PROCEDURE [dbo].[spUpdateWebArtists]
 @Artist1 nvarchar(255)
,@Artist2 nvarchar(255)
,@Artist3 nvarchar(255)
,@Artist4 nvarchar(255)
,@Artist5 nvarchar(255)
,@Artist6 nvarchar(255)
,@Format nvarchar(50)
,@InventoryID int

AS

declare @WebArtistFormat nvarchar(50)
if @Format='CD'
 set @WebArtistFormat='CD'
else if @Format='LP' or @Format='12"' or @Format='10"' or @Format='7"'
 set @WebArtistFormat='Vinyl'
else if @Format='DVD' or @Format='VHS'
 set @WebArtistFormat='DVDorVHS'
else
 set @WebArtistFormat='Other'

--Artist1
if @Artist1<>'---'
begin
if exists (select InventoryID from WebArtists
   where InventoryID=@InventoryID and Artist=@Artist1)
    begin
     Update WebArtists set
      [Format]=@WebArtistFormat
     ,InStock='y'
     where InventoryID=@InventoryID and Artist=@Artist1
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
     ,@InventoryID
     ,@WebArtistFormat
     ,'y')
    end
end

--Artist2
if @Artist2<>'---'
begin
if exists (select InventoryID from WebArtists
   where InventoryID=@InventoryID and Artist=@Artist2)
    begin
     Update WebArtists set
      [Format]=@WebArtistFormat
     ,InStock='y'
     where InventoryID=@InventoryID and Artist=@Artist2
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
     ,@InventoryID
     ,@WebArtistFormat
     ,'y')
    end
end
--Artist3
if @Artist3<>'---'
begin
if exists (select InventoryID from WebArtists
   where InventoryID=@InventoryID and Artist=@Artist3)
    begin
     Update WebArtists set
      [Format]=@WebArtistFormat
     ,InStock='y'
     where InventoryID=@InventoryID and Artist=@Artist3
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
     ,@InventoryID
     ,@WebArtistFormat
     ,'y')
    end
end
--Artist4
if @Artist4<>'---'
begin
if exists (select InventoryID from WebArtists
   where InventoryID=@InventoryID and Artist=@Artist4)
    begin
     Update WebArtists set
      [Format]=@WebArtistFormat
     ,InStock='y'
     where InventoryID=@InventoryID and Artist=@Artist4
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
     ,@InventoryID
     ,@WebArtistFormat
     ,'y')
    end
end
--Artist5
if @Artist5<>'---'
begin
if exists (select InventoryID from WebArtists
   where InventoryID=@InventoryID and Artist=@Artist5)
    begin
     Update WebArtists set
      [Format]=@WebArtistFormat
     ,InStock='y'
     where InventoryID=@InventoryID and Artist=@Artist5
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
     ,@InventoryID
     ,@WebArtistFormat
     ,'y')
    end
end
--Artist6
if @Artist6<>'---'
begin
if exists (select InventoryID from WebArtists
   where InventoryID=@InventoryID and Artist=@Artist6)
    begin
     Update WebArtists set
      [Format]=@WebArtistFormat
     ,InStock='y'
     where InventoryID=@InventoryID and Artist=@Artist6
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
     ,@InventoryID
     ,@WebArtistFormat
     ,'y')
    end
end












