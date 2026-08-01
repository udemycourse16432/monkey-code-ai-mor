CREATE PROCEDURE [dbo].[spFigureWebSearchSuggestionsALBUMTITLE]
  @Hint nvarchar(350),
  @Word1 nvarchar(50),
  @Word2 nvarchar(50),
  @Word3 nvarchar(50),
  @Word4 nvarchar(50),
  @Word5 nvarchar(50),
  @Word6 nvarchar(50),
  @Word7 nvarchar(50),
  @Word8 nvarchar(50),
  @Word9 nvarchar(50),
  @Word10 nvarchar(50),
  @Word11 nvarchar(50),
  @Word12 nvarchar(50),
  @Word13 nvarchar(50),
  @Word14 nvarchar(50),
  @Word15 nvarchar(50),
  @Word16 nvarchar(50),
  @Word17 nvarchar(50),
  @Word18 nvarchar(50),
  @Word19 nvarchar(50),
  @Word20 nvarchar(50),
  @ScanPath nvarchar(50) = NULL,
  @SortOrder INT = 10
AS

declare @QtyCD int
declare @QtyVinyl int
declare @QtyOther int
declare @SalesLast30Days int

  set @QtyCD=(select count(ID) from Inventory
   where ArtistTitle=@Hint
   and Format='CD'
   and Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyVinyl=(select count(ID) from Inventory
   where ArtistTitle=@Hint
   and (Format='LP' or Format='12"' or Format='10"' or Format='7"')
   and Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyOther=(select count(ID) from Inventory
   where ArtistTitle=@Hint
   and Format<>'CD' and Format<>'LP' and Format<>'12"' and Format<>'10"' and Format<>'7"'
   and Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @SalesLast30Days=(select sum(SalesLast30Days) from Inventory
   where ArtistTitle=@Hint
   and Inventory>0 and ShowOnWebsite='y' and Deleted='n')
 
 if @QtyCD+@QtyVinyl+@QtyOther>0
   begin
    if not exists(select counter from WebSearchSuggestions where Hint=@Hint and SearchType='Album')
     begin
      insert into WebSearchSuggestions (
        Hint,
        Word1,
        Word2,
        Word3,
        Word4,
        Word5,
        Word6,
        Word7,
        Word8,
        Word9,
        Word10,
        Word11,
        Word12,
        Word13,
        Word14,
        Word15,
        Word16,
        Word17,
        Word18,
        Word19,
        Word20,
        Total,
        CD,
        Vinyl,
        Other,
        SalesLast30Days,
        SearchType,
        ScanPath,
        SortOrder
      ) values (
        @Hint,
        @Word1,
        @Word2,
        @Word3,
        @Word4,
        @Word5,
        @Word6,
        @Word7,
        @Word8,
        @Word9,
        @Word10,
        @Word11,
        @Word12,
        @Word13,
        @Word14,
        @Word15,
        @Word16,
        @Word17,
        @Word18,
        @Word19,
        @Word20,
        @QtyCD+@QtyVinyl+@QtyOther,
        @QtyCD,
        @QtyVinyl,
        @QtyOther,
        @SalesLast30Days,
        'Album',
        @ScanPath,
        @SortOrder
      )
     end
    else
     begin
      update WebSearchSuggestions
      set
       Word1=@Word1
      ,Word2=@Word2
      ,Word3=@Word3
      ,Word4=@Word4
      ,Word5=@Word5
      ,Word6=@Word6
      ,Word7=@Word7
      ,Word8=@Word8
      ,Word9=@Word9
      ,Word10=@Word10
      ,Word11=@Word11
      ,Word12=@Word12
      ,Word13=@Word13
      ,Word14=@Word14
      ,Word15=@Word15
      ,Word16=@Word16
      ,Word17=@Word17
      ,Word18=@Word18
      ,Word19=@Word19
      ,Word20=@Word20
      ,Total=@QtyCD+@QtyVinyl+@QtyOther
      ,CD=@QtyCD
      ,Vinyl=@QtyVinyl
      ,Other=@QtyOther
      ,SalesLast30Days=@SalesLast30Days
      where Hint=@Hint and SearchType='Album'
     end
    end
  else
   delete WebSearchSuggestions where Hint=@Hint and SearchType='Album'
