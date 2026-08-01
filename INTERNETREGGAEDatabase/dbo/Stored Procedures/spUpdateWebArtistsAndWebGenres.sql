











create PROCEDURE [dbo].[spUpdateWebArtistsAndWebGenres]
 @Artist1 nvarchar(255)
,@Artist2 nvarchar(255)
,@Artist3 nvarchar(255)
,@Artist4 nvarchar(255)
,@Artist5 nvarchar(255)
,@Artist6 nvarchar(255)
,@Format nvarchar(50)
,@InventoryID int
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

--WebArtists table--------------------------------------------------------------
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

--WebGenres table--------------------------------------------------------------------------------

--Genre1
if @Genre1 is not null
begin
if exists (select InventoryID from WebGenres
   where InventoryID=@InventoryID and Genre=@Genre1)
    begin
     Update WebGenres set
      [Format]=@WebArtistFormat
     ,InStock='y'
     where InventoryID=@InventoryID and Genre=@Genre1
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
     ,@InventoryID
     ,@WebArtistFormat
     ,'y')
    end
end

--Genre2
if @Genre2 is not null
begin
if exists (select InventoryID from WebGenres
   where InventoryID=@InventoryID and Genre=@Genre2)
    begin
     Update WebGenres set
      [Format]=@WebArtistFormat
     ,InStock='y'
     where InventoryID=@InventoryID and Genre=@Genre2
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
     ,@InventoryID
     ,@WebArtistFormat
     ,'y')
    end
end

--Genre3
if @Genre3 is not null
begin
if exists (select InventoryID from WebGenres
   where InventoryID=@InventoryID and Genre=@Genre3)
    begin
     Update WebGenres set
      [Format]=@WebArtistFormat
     ,InStock='y'
     where InventoryID=@InventoryID and Genre=@Genre3
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
     ,@InventoryID
     ,@WebArtistFormat
     ,'y')
    end
end

--Genre4
if @Genre4 is not null
begin
if exists (select InventoryID from WebGenres
   where InventoryID=@InventoryID and Genre=@Genre4)
    begin
     Update WebGenres set
      [Format]=@WebArtistFormat
     ,InStock='y'
     where InventoryID=@InventoryID and Genre=@Genre4
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
     ,@InventoryID
     ,@WebArtistFormat
     ,'y')
    end
end

--Genre5
if @Genre5 is not null
begin
if exists (select InventoryID from WebGenres
   where InventoryID=@InventoryID and Genre=@Genre5)
    begin
     Update WebGenres set
      [Format]=@WebArtistFormat
     ,InStock='y'
     where InventoryID=@InventoryID and Genre=@Genre5
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
     ,@InventoryID
     ,@WebArtistFormat
     ,'y')
    end
end

--Genre6
if @Genre6 is not null
begin
if exists (select InventoryID from WebGenres
   where InventoryID=@InventoryID and Genre=@Genre6)
    begin
     Update WebGenres set
      [Format]=@WebArtistFormat
     ,InStock='y'
     where InventoryID=@InventoryID and Genre=@Genre6
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
     ,@InventoryID
     ,@WebArtistFormat
     ,'y')
    end
end

--Genre7
if @Genre7 is not null
begin
if exists (select InventoryID from WebGenres
   where InventoryID=@InventoryID and Genre=@Genre7)
    begin
     Update WebGenres set
      [Format]=@WebArtistFormat
     ,InStock='y'
     where InventoryID=@InventoryID and Genre=@Genre7
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
     ,@InventoryID
     ,@WebArtistFormat
     ,'y')
    end
end

--Genre8
if @Genre8 is not null
begin
if exists (select InventoryID from WebGenres
   where InventoryID=@InventoryID and Genre=@Genre8)
    begin
     Update WebGenres set
      [Format]=@WebArtistFormat
     ,InStock='y'
     where InventoryID=@InventoryID and Genre=@Genre8
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
     ,@InventoryID
     ,@WebArtistFormat
     ,'y')
    end
end

--Genre9
if @Genre9 is not null
begin
if exists (select InventoryID from WebGenres
   where InventoryID=@InventoryID and Genre=@Genre9)
    begin
     Update WebGenres set
      [Format]=@WebArtistFormat
     ,InStock='y'
     where InventoryID=@InventoryID and Genre=@Genre9
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
     ,@InventoryID
     ,@WebArtistFormat
     ,'y')
    end
end












