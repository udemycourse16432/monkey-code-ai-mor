CREATE PROCEDURE [dbo].[spFigureWebSearchSuggestionsRHYTHM]
  @Hint nvarchar(255),
  @Word1 nvarchar(50),
  @Word2 nvarchar(50),
  @Word3 nvarchar(50),
  @Word4 nvarchar(50),
  @Word5 nvarchar(50),
  @Word6 nvarchar(50),
  @Word7 nvarchar(50),
  @Word8 nvarchar(50),
  @Word9 nvarchar(50),
  @Word10 nvarchar(50)
AS

declare @QtyCD int
declare @QtyVinyl int
declare @QtyOther int

  set @QtyCD=(select count(ID) from Inventory
   where RhythmName=@Hint
   and Format='CD'
   and Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyVinyl=(select count(ID) from Inventory
   where RhythmName=@Hint
   and (Format='LP' or Format='12"' or Format='10"' or Format='7"')
   and Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyOther=(select count(ID) from Inventory
   where RhythmName=@Hint
   and Format<>'CD' and Format<>'LP' and Format<>'12"' and Format<>'10"' and Format<>'7"'
   and Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  if @QtyCD+@QtyVinyl+@QtyOther>0
   begin
    if not exists(select counter from WebSearchSuggestions where Hint=@Hint and SearchType='Rhythm')
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
        Total,
        CD,
        Vinyl,
        Other,
        SearchType
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
        @QtyCD+@QtyVinyl+@QtyOther,
        @QtyCD,
        @QtyVinyl,
        @QtyOther,
        'Rhythm'
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
      ,Total=@QtyCD+@QtyVinyl+@QtyOther
      ,CD=@QtyCD
      ,Vinyl=@QtyVinyl
      ,Other=@QtyOther
      where Hint=@Hint and SearchType='Rhythm'
     end
    end
  else
   delete WebSearchSuggestions where Hint=@Hint and SearchType='Rhythm'
