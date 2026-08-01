CREATE PROCEDURE [dbo].[spFigureWebSearchSuggestionsARTISTS]
  @Artist1 nvarchar(255),
  @Artist2 nvarchar(255),
  @Artist3 nvarchar(255),
  @Artist4 nvarchar(255),
  @Artist5 nvarchar(255),
  @Artist6 nvarchar(255),
  @Artist1Word1 nvarchar(50),
  @Artist1Word2 nvarchar(50),
  @Artist1Word3 nvarchar(50),
  @Artist1Word4 nvarchar(50),
  @Artist1Word5 nvarchar(50),
  @Artist1Word6 nvarchar(50),
  @Artist1Word7 nvarchar(50),
  @Artist1Word8 nvarchar(50),
  @Artist1Word9 nvarchar(50),
  @Artist1Word10 nvarchar(50),
  @Artist2Word1 nvarchar(50),
  @Artist2Word2 nvarchar(50),
  @Artist2Word3 nvarchar(50),
  @Artist2Word4 nvarchar(50),
  @Artist2Word5 nvarchar(50),
  @Artist2Word6 nvarchar(50),
  @Artist2Word7 nvarchar(50),
  @Artist2Word8 nvarchar(50),
  @Artist2Word9 nvarchar(50),
  @Artist2Word10 nvarchar(50),
  @Artist3Word1 nvarchar(50),
  @Artist3Word2 nvarchar(50),
  @Artist3Word3 nvarchar(50),
  @Artist3Word4 nvarchar(50),
  @Artist3Word5 nvarchar(50),
  @Artist3Word6 nvarchar(50),
  @Artist3Word7 nvarchar(50),
  @Artist3Word8 nvarchar(50),
  @Artist3Word9 nvarchar(50),
  @Artist3Word10 nvarchar(50),
  @Artist4Word1 nvarchar(50),
  @Artist4Word2 nvarchar(50),
  @Artist4Word3 nvarchar(50),
  @Artist4Word4 nvarchar(50),
  @Artist4Word5 nvarchar(50),
  @Artist4Word6 nvarchar(50),
  @Artist4Word7 nvarchar(50),
  @Artist4Word8 nvarchar(50),
  @Artist4Word9 nvarchar(50),
  @Artist4Word10 nvarchar(50),
  @Artist5Word1 nvarchar(50),
  @Artist5Word2 nvarchar(50),
  @Artist5Word3 nvarchar(50),
  @Artist5Word4 nvarchar(50),
  @Artist5Word5 nvarchar(50),
  @Artist5Word6 nvarchar(50),
  @Artist5Word7 nvarchar(50),
  @Artist5Word8 nvarchar(50),
  @Artist5Word9 nvarchar(50),
  @Artist5Word10 nvarchar(50),
  @Artist6Word1 nvarchar(50),
  @Artist6Word2 nvarchar(50),
  @Artist6Word3 nvarchar(50),
  @Artist6Word4 nvarchar(50),
  @Artist6Word5 nvarchar(50),
  @Artist6Word6 nvarchar(50),
  @Artist6Word7 nvarchar(50),
  @Artist6Word8 nvarchar(50),
  @Artist6Word9 nvarchar(50),
  @Artist6Word10 nvarchar(50)
AS

declare @QtyCD int
declare @QtyVinyl int
declare @QtyOther int

if @Artist1 <>'---'
 begin
  set @QtyCD=(select count(ID) from Inventory
   inner join WebArtists on Inventory.ID=WebArtists.InventoryID
   where WebArtists.Artist=@Artist1
   and Inventory.Format='CD'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyVinyl=(select count(ID) from Inventory
   inner join WebArtists on Inventory.ID=WebArtists.InventoryID
   where WebArtists.Artist=@Artist1
   and (Inventory.Format='LP' or Inventory.Format='12"' or Inventory.Format='10"' or Inventory.Format='7"')
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyOther=(select count(ID) from Inventory
   inner join WebArtists on Inventory.ID=WebArtists.InventoryID
   where WebArtists.Artist=@Artist1
   and Inventory.Format<>'CD' and Inventory.Format<>'LP' and Inventory.Format<>'12"' and Inventory.Format<>'10"' and Inventory.Format<>'7"'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  if @QtyCD+@QtyVinyl+@QtyOther>0
   begin
    if not exists(select counter from WebSearchSuggestions where Hint=@Artist1 and SearchType='Artist')
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
        @Artist1,
        @Artist1Word1,
        @Artist1Word2,
        @Artist1Word3,
        @Artist1Word4,
        @Artist1Word5,
        @Artist1Word6,
        @Artist1Word7,
        @Artist1Word8,
        @Artist1Word9,
        @Artist1Word10,
        @QtyCD+@QtyVinyl+@QtyOther,
        @QtyCD,
        @QtyVinyl,
        @QtyOther,
        'Artist'
      )
     end
    else
     begin
      update WebSearchSuggestions
      set
       Total=@QtyCD+@QtyVinyl+@QtyOther
      ,CD=@QtyCD
      ,Vinyl=@QtyVinyl
      ,Other=@QtyOther
      where Hint=@Artist1 and SearchType='Artist'
     end
    end
  else
   delete WebSearchSuggestions where Hint=@Artist1 and SearchType='Artist'
 end

if @Artist2 <>'---'
 begin
  set @QtyCD=(select count(ID) from Inventory
   inner join WebArtists on Inventory.ID=WebArtists.InventoryID
   where WebArtists.Artist=@Artist2
   and Inventory.Format='CD'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyVinyl=(select count(ID) from Inventory
   inner join WebArtists on Inventory.ID=WebArtists.InventoryID
   where WebArtists.Artist=@Artist2
   and (Inventory.Format='LP' or Inventory.Format='12"' or Inventory.Format='10"' or Inventory.Format='7"')
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyOther=(select count(ID) from Inventory
   inner join WebArtists on Inventory.ID=WebArtists.InventoryID
   where WebArtists.Artist=@Artist2
   and Inventory.Format<>'CD' and Inventory.Format<>'LP' and Inventory.Format<>'12"' and Inventory.Format<>'10"' and Inventory.Format<>'7"'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  if @QtyCD+@QtyVinyl+@QtyOther>0
   begin
    if not exists(select counter from WebSearchSuggestions where Hint=@Artist2 and SearchType='Artist')
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
        @Artist2,
        @Artist2Word1,
        @Artist2Word2,
        @Artist2Word3,
        @Artist2Word4,
        @Artist2Word5,
        @Artist2Word6,
        @Artist2Word7,
        @Artist2Word8,
        @Artist2Word9,
        @Artist2Word10,
        @QtyCD+@QtyVinyl+@QtyOther,
        @QtyCD,
        @QtyVinyl,
        @QtyOther,
        'Artist'
      )
     end
    else
     begin
      update WebSearchSuggestions
      set
       Total=@QtyCD+@QtyVinyl+@QtyOther
      ,CD=@QtyCD
      ,Vinyl=@QtyVinyl
      ,Other=@QtyOther
      where Hint=@Artist2 and SearchType='Artist'
     end
    end
  else
   delete WebSearchSuggestions where Hint=@Artist2 and SearchType='Artist'
 end

if @Artist3 <>'---'
 begin
  set @QtyCD=(select count(ID) from Inventory
   inner join WebArtists on Inventory.ID=WebArtists.InventoryID
   where WebArtists.Artist=@Artist3
   and Inventory.Format='CD'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyVinyl=(select count(ID) from Inventory
   inner join WebArtists on Inventory.ID=WebArtists.InventoryID
   where WebArtists.Artist=@Artist3
   and (Inventory.Format='LP' or Inventory.Format='12"' or Inventory.Format='10"' or Inventory.Format='7"')
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyOther=(select count(ID) from Inventory
   inner join WebArtists on Inventory.ID=WebArtists.InventoryID
   where WebArtists.Artist=@Artist3
   and Inventory.Format<>'CD' and Inventory.Format<>'LP' and Inventory.Format<>'12"' and Inventory.Format<>'10"' and Inventory.Format<>'7"'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  if @QtyCD+@QtyVinyl+@QtyOther>0
   begin
    if not exists(select counter from WebSearchSuggestions where Hint=@Artist3 and SearchType='Artist')
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
        @Artist3,
        @Artist3Word1,
        @Artist3Word2,
        @Artist3Word3,
        @Artist3Word4,
        @Artist3Word5,
        @Artist3Word6,
        @Artist3Word7,
        @Artist3Word8,
        @Artist3Word9,
        @Artist3Word10,
        @QtyCD+@QtyVinyl+@QtyOther,
        @QtyCD,
        @QtyVinyl,
        @QtyOther,
        'Artist'
      )
     end
    else
     begin
      update WebSearchSuggestions
      set
       Total=@QtyCD+@QtyVinyl+@QtyOther
      ,CD=@QtyCD
      ,Vinyl=@QtyVinyl
      ,Other=@QtyOther
      where Hint=@Artist3 and SearchType='Artist'
     end
    end
  else
   delete WebSearchSuggestions where Hint=@Artist3 and SearchType='Artist'
 end

if @Artist4 <>'---'
 begin
  set @QtyCD=(select count(ID) from Inventory
   inner join WebArtists on Inventory.ID=WebArtists.InventoryID
   where WebArtists.Artist=@Artist4
   and Inventory.Format='CD'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyVinyl=(select count(ID) from Inventory
   inner join WebArtists on Inventory.ID=WebArtists.InventoryID
   where WebArtists.Artist=@Artist4
   and (Inventory.Format='LP' or Inventory.Format='12"' or Inventory.Format='10"' or Inventory.Format='7"')
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyOther=(select count(ID) from Inventory
   inner join WebArtists on Inventory.ID=WebArtists.InventoryID
   where WebArtists.Artist=@Artist4
   and Inventory.Format<>'CD' and Inventory.Format<>'LP' and Inventory.Format<>'12"' and Inventory.Format<>'10"' and Inventory.Format<>'7"'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  if @QtyCD+@QtyVinyl+@QtyOther>0
   begin
    if not exists(select counter from WebSearchSuggestions where Hint=@Artist4 and SearchType='Artist')
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
        @Artist4,
        @Artist4Word1,
        @Artist4Word2,
        @Artist4Word3,
        @Artist4Word4,
        @Artist4Word5,
        @Artist4Word6,
        @Artist4Word7,
        @Artist4Word8,
        @Artist4Word9,
        @Artist4Word10,
        @QtyCD+@QtyVinyl+@QtyOther,
        @QtyCD,
        @QtyVinyl,
        @QtyOther,
        'Artist'
      )
     end
    else
     begin
      update WebSearchSuggestions
      set
       Total=@QtyCD+@QtyVinyl+@QtyOther
      ,CD=@QtyCD
      ,Vinyl=@QtyVinyl
      ,Other=@QtyOther
      where Hint=@Artist4 and SearchType='Artist'
     end
    end
  else
   delete WebSearchSuggestions where Hint=@Artist4 and SearchType='Artist'
 end

if @Artist5 <>'---'
 begin
  set @QtyCD=(select count(ID) from Inventory
   inner join WebArtists on Inventory.ID=WebArtists.InventoryID
   where WebArtists.Artist=@Artist5
   and Inventory.Format='CD'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyVinyl=(select count(ID) from Inventory
   inner join WebArtists on Inventory.ID=WebArtists.InventoryID
   where WebArtists.Artist=@Artist5
   and (Inventory.Format='LP' or Inventory.Format='12"' or Inventory.Format='10"' or Inventory.Format='7"')
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyOther=(select count(ID) from Inventory
   inner join WebArtists on Inventory.ID=WebArtists.InventoryID
   where WebArtists.Artist=@Artist5
   and Inventory.Format<>'CD' and Inventory.Format<>'LP' and Inventory.Format<>'12"' and Inventory.Format<>'10"' and Inventory.Format<>'7"'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  if @QtyCD+@QtyVinyl+@QtyOther>0
   begin
    if not exists(select counter from WebSearchSuggestions where Hint=@Artist5 and SearchType='Artist')
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
        @Artist5,
        @Artist5Word1,
        @Artist5Word2,
        @Artist5Word3,
        @Artist5Word4,
        @Artist5Word5,
        @Artist5Word6,
        @Artist5Word7,
        @Artist5Word8,
        @Artist5Word9,
        @Artist5Word10,
        @QtyCD+@QtyVinyl+@QtyOther,
        @QtyCD,
        @QtyVinyl,
        @QtyOther,
       'Artist'
     )
     end
    else
     begin
      update WebSearchSuggestions
      set
       Total=@QtyCD+@QtyVinyl+@QtyOther
      ,CD=@QtyCD
      ,Vinyl=@QtyVinyl
      ,Other=@QtyOther
      where Hint=@Artist5 and SearchType='Artist'
     end
    end
  else
   delete WebSearchSuggestions where Hint=@Artist5 and SearchType='Artist'
 end

if @Artist6 <>'---'
 begin
  set @QtyCD=(select count(ID) from Inventory
   inner join WebArtists on Inventory.ID=WebArtists.InventoryID
   where WebArtists.Artist=@Artist6
   and Inventory.Format='CD'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyVinyl=(select count(ID) from Inventory
   inner join WebArtists on Inventory.ID=WebArtists.InventoryID
   where WebArtists.Artist=@Artist6
   and (Inventory.Format='LP' or Inventory.Format='12"' or Inventory.Format='10"' or Inventory.Format='7"')
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyOther=(select count(ID) from Inventory
   inner join WebArtists on Inventory.ID=WebArtists.InventoryID
   where WebArtists.Artist=@Artist6
   and Inventory.Format<>'CD' and Inventory.Format<>'LP' and Inventory.Format<>'12"' and Inventory.Format<>'10"' and Inventory.Format<>'7"'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  if @QtyCD+@QtyVinyl+@QtyOther>0
   begin
    if not exists(select counter from WebSearchSuggestions where Hint=@Artist6 and SearchType='Artist')
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
        @Artist6,
        @Artist6Word1,
        @Artist6Word2,
        @Artist6Word3,
        @Artist6Word4,
        @Artist6Word5,
        @Artist6Word6,
        @Artist6Word7,
        @Artist6Word8,
        @Artist6Word9,
        @Artist6Word10,
        @QtyCD+@QtyVinyl+@QtyOther,
        @QtyCD,
        @QtyVinyl,
        @QtyOther,
        'Artist'
      )
     end
    else
     begin
      update WebSearchSuggestions
      set
       Total=@QtyCD+@QtyVinyl+@QtyOther
      ,CD=@QtyCD
      ,Vinyl=@QtyVinyl
      ,Other=@QtyOther
      where Hint=@Artist6 and SearchType='Artist'
     end
    end
  else
   delete WebSearchSuggestions where Hint=@Artist6 and SearchType='Artist'
 end
