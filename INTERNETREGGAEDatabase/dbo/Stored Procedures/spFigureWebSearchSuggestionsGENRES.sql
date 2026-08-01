CREATE PROCEDURE [dbo].[spFigureWebSearchSuggestionsGENRES]
  @Genre1 nvarchar(255),
  @Genre2 nvarchar(255),
  @Genre3 nvarchar(255),
  @Genre4 nvarchar(255),
  @Genre5 nvarchar(255),
  @Genre6 nvarchar(255),
  @Genre7 nvarchar(255),
  @Genre8 nvarchar(255),
  @Genre9 nvarchar(255),
  @Genre1Word1 nvarchar(50),
  @Genre1Word2 nvarchar(50),
  @Genre1Word3 nvarchar(50),
  @Genre1Word4 nvarchar(50),
  @Genre1Word5 nvarchar(50),
  @Genre1Word6 nvarchar(50),
  @Genre1Word7 nvarchar(50),
  @Genre1Word8 nvarchar(50),
  @Genre1Word9 nvarchar(50),
  @Genre1Word10 nvarchar(50),
  @Genre2Word1 nvarchar(50),
  @Genre2Word2 nvarchar(50),
  @Genre2Word3 nvarchar(50),
  @Genre2Word4 nvarchar(50),
  @Genre2Word5 nvarchar(50),
  @Genre2Word6 nvarchar(50),
  @Genre2Word7 nvarchar(50),
  @Genre2Word8 nvarchar(50),
  @Genre2Word9 nvarchar(50),
  @Genre2Word10 nvarchar(50),
  @Genre3Word1 nvarchar(50),
  @Genre3Word2 nvarchar(50),
  @Genre3Word3 nvarchar(50),
  @Genre3Word4 nvarchar(50),
  @Genre3Word5 nvarchar(50),
  @Genre3Word6 nvarchar(50),
  @Genre3Word7 nvarchar(50),
  @Genre3Word8 nvarchar(50),
  @Genre3Word9 nvarchar(50),
  @Genre3Word10 nvarchar(50),
  @Genre4Word1 nvarchar(50),
  @Genre4Word2 nvarchar(50),
  @Genre4Word3 nvarchar(50),
  @Genre4Word4 nvarchar(50),
  @Genre4Word5 nvarchar(50),
  @Genre4Word6 nvarchar(50),
  @Genre4Word7 nvarchar(50),
  @Genre4Word8 nvarchar(50),
  @Genre4Word9 nvarchar(50),
  @Genre4Word10 nvarchar(50),
  @Genre5Word1 nvarchar(50),
  @Genre5Word2 nvarchar(50),
  @Genre5Word3 nvarchar(50),
  @Genre5Word4 nvarchar(50),
  @Genre5Word5 nvarchar(50),
  @Genre5Word6 nvarchar(50),
  @Genre5Word7 nvarchar(50),
  @Genre5Word8 nvarchar(50),
  @Genre5Word9 nvarchar(50),
  @Genre5Word10 nvarchar(50),
  @Genre6Word1 nvarchar(50),
  @Genre6Word2 nvarchar(50),
  @Genre6Word3 nvarchar(50),
  @Genre6Word4 nvarchar(50),
  @Genre6Word5 nvarchar(50),
  @Genre6Word6 nvarchar(50),
  @Genre6Word7 nvarchar(50),
  @Genre6Word8 nvarchar(50),
  @Genre6Word9 nvarchar(50),
  @Genre6Word10 nvarchar(50),
  @Genre7Word1 nvarchar(50),
  @Genre7Word2 nvarchar(50),
  @Genre7Word3 nvarchar(50),
  @Genre7Word4 nvarchar(50),
  @Genre7Word5 nvarchar(50),
  @Genre7Word6 nvarchar(50),
  @Genre7Word7 nvarchar(50),
  @Genre7Word8 nvarchar(50),
  @Genre7Word9 nvarchar(50),
  @Genre7Word10 nvarchar(50),
  @Genre8Word1 nvarchar(50),
  @Genre8Word2 nvarchar(50),
  @Genre8Word3 nvarchar(50),
  @Genre8Word4 nvarchar(50),
  @Genre8Word5 nvarchar(50),
  @Genre8Word6 nvarchar(50),
  @Genre8Word7 nvarchar(50),
  @Genre8Word8 nvarchar(50),
  @Genre8Word9 nvarchar(50),
  @Genre8Word10 nvarchar(50),
  @Genre9Word1 nvarchar(50),
  @Genre9Word2 nvarchar(50),
  @Genre9Word3 nvarchar(50),
  @Genre9Word4 nvarchar(50),
  @Genre9Word5 nvarchar(50),
  @Genre9Word6 nvarchar(50),
  @Genre9Word7 nvarchar(50),
  @Genre9Word8 nvarchar(50),
  @Genre9Word9 nvarchar(50),
  @Genre9Word10 nvarchar(50)
AS

declare @QtyCD int
declare @QtyVinyl int
declare @QtyOther int

if @Genre1 <>'---'
 begin
  set @QtyCD=(select count(ID) from Inventory
   inner join WebGenres on Inventory.ID=WebGenres.InventoryID
   where WebGenres.Genre=@Genre1
   and Inventory.Format='CD'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyVinyl=(select count(ID) from Inventory
   inner join WebGenres on Inventory.ID=WebGenres.InventoryID
   where WebGenres.Genre=@Genre1
   and (Inventory.Format='LP' or Inventory.Format='12"' or Inventory.Format='10"' or Inventory.Format='7"')
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyOther=(select count(ID) from Inventory
   inner join WebGenres on Inventory.ID=WebGenres.InventoryID
   where WebGenres.Genre=@Genre1
   and Inventory.Format<>'CD' and Inventory.Format<>'LP' and Inventory.Format<>'12"' and Inventory.Format<>'10"' and Inventory.Format<>'7"'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  if @QtyCD+@QtyVinyl+@QtyOther>0
   begin
    if not exists(select counter from WebSearchSuggestions where Hint=@Genre1 and SearchType='Genre')
     begin
      insert into WebSearchSuggestions
      (Hint
      ,Word1
      ,Word2
      ,Word3
      ,Word4
      ,Word5
      ,Word6
      ,Word7
      ,Word8
      ,Word9
      ,Word10
      ,Total
      ,CD
      ,Vinyl
      ,Other
      ,SearchType)
      values
      (@Genre1
      ,@Genre1Word1
      ,@Genre1Word2
      ,@Genre1Word3
      ,@Genre1Word4
      ,@Genre1Word5
      ,@Genre1Word6
      ,@Genre1Word7
      ,@Genre1Word8
      ,@Genre1Word9
      ,@Genre1Word10
      ,@QtyCD+@QtyVinyl+@QtyOther
      ,@QtyCD
      ,@QtyVinyl
      ,@QtyOther
      ,'Genre')
     end
    else
     begin
      update WebSearchSuggestions
      set
       Total=@QtyCD+@QtyVinyl+@QtyOther
      ,CD=@QtyCD
      ,Vinyl=@QtyVinyl
      ,Other=@QtyOther
      where Hint=@Genre1 and SearchType='Genre'
     end
    end
  else
   delete WebSearchSuggestions where Hint=@Genre1 and SearchType='Genre'
 end

if @Genre2 <>'---'
 begin
  set @QtyCD=(select count(ID) from Inventory
   inner join WebGenres on Inventory.ID=WebGenres.InventoryID
   where WebGenres.Genre=@Genre2
   and Inventory.Format='CD'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyVinyl=(select count(ID) from Inventory
   inner join WebGenres on Inventory.ID=WebGenres.InventoryID
   where WebGenres.Genre=@Genre2
   and (Inventory.Format='LP' or Inventory.Format='12"' or Inventory.Format='10"' or Inventory.Format='7"')
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyOther=(select count(ID) from Inventory
   inner join WebGenres on Inventory.ID=WebGenres.InventoryID
   where WebGenres.Genre=@Genre2
   and Inventory.Format<>'CD' and Inventory.Format<>'LP' and Inventory.Format<>'12"' and Inventory.Format<>'10"' and Inventory.Format<>'7"'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  if @QtyCD+@QtyVinyl+@QtyOther>0
   begin
    if not exists(select counter from WebSearchSuggestions where Hint=@Genre2 and SearchType='Genre')
     begin
      insert into WebSearchSuggestions
      (Hint
      ,Word1
      ,Word2
      ,Word3
      ,Word4
      ,Word5
      ,Word6
      ,Word7
      ,Word8
      ,Word9
      ,Word10
      ,Total
      ,CD
      ,Vinyl
      ,Other
      ,SearchType)
      values
      (@Genre2
      ,@Genre2Word1
      ,@Genre2Word2
      ,@Genre2Word3
      ,@Genre2Word4
      ,@Genre2Word5
      ,@Genre2Word6
      ,@Genre2Word7
      ,@Genre2Word8
      ,@Genre2Word9
      ,@Genre2Word10
      ,@QtyCD+@QtyVinyl+@QtyOther
      ,@QtyCD
      ,@QtyVinyl
      ,@QtyOther
      ,'Genre')
     end
    else
     begin
      update WebSearchSuggestions
      set
       Total=@QtyCD+@QtyVinyl+@QtyOther
      ,CD=@QtyCD
      ,Vinyl=@QtyVinyl
      ,Other=@QtyOther
      where Hint=@Genre2 and SearchType='Genre'
     end
    end
  else
   delete WebSearchSuggestions where Hint=@Genre2 and SearchType='Genre'
 end

if @Genre3 <>'---'
 begin
  set @QtyCD=(select count(ID) from Inventory
   inner join WebGenres on Inventory.ID=WebGenres.InventoryID
   where WebGenres.Genre=@Genre3
   and Inventory.Format='CD'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyVinyl=(select count(ID) from Inventory
   inner join WebGenres on Inventory.ID=WebGenres.InventoryID
   where WebGenres.Genre=@Genre3
   and (Inventory.Format='LP' or Inventory.Format='12"' or Inventory.Format='10"' or Inventory.Format='7"')
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyOther=(select count(ID) from Inventory
   inner join WebGenres on Inventory.ID=WebGenres.InventoryID
   where WebGenres.Genre=@Genre3
   and Inventory.Format<>'CD' and Inventory.Format<>'LP' and Inventory.Format<>'12"' and Inventory.Format<>'10"' and Inventory.Format<>'7"'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  if @QtyCD+@QtyVinyl+@QtyOther>0
   begin
    if not exists(select counter from WebSearchSuggestions where Hint=@Genre3 and SearchType='Genre')
     begin
      insert into WebSearchSuggestions
      (Hint
      ,Word1
      ,Word2
      ,Word3
      ,Word4
      ,Word5
      ,Word6
      ,Word7
      ,Word8
      ,Word9
      ,Word10
      ,Total
      ,CD
      ,Vinyl
      ,Other
      ,SearchType)
      values
      (@Genre3
      ,@Genre3Word1
      ,@Genre3Word2
      ,@Genre3Word3
      ,@Genre3Word4
      ,@Genre3Word5
      ,@Genre3Word6
      ,@Genre3Word7
      ,@Genre3Word8
      ,@Genre3Word9
      ,@Genre3Word10
      ,@QtyCD+@QtyVinyl+@QtyOther
      ,@QtyCD
      ,@QtyVinyl
      ,@QtyOther
      ,'Genre')
     end
    else
     begin
      update WebSearchSuggestions
      set
       Total=@QtyCD+@QtyVinyl+@QtyOther
      ,CD=@QtyCD
      ,Vinyl=@QtyVinyl
      ,Other=@QtyOther
      where Hint=@Genre3 and SearchType='Genre'
     end
    end
  else
   delete WebSearchSuggestions where Hint=@Genre3 and SearchType='Genre'
 end

if @Genre4 <>'---'
 begin
  set @QtyCD=(select count(ID) from Inventory
   inner join WebGenres on Inventory.ID=WebGenres.InventoryID
   where WebGenres.Genre=@Genre4
   and Inventory.Format='CD'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyVinyl=(select count(ID) from Inventory
   inner join WebGenres on Inventory.ID=WebGenres.InventoryID
   where WebGenres.Genre=@Genre4
   and (Inventory.Format='LP' or Inventory.Format='12"' or Inventory.Format='10"' or Inventory.Format='7"')
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyOther=(select count(ID) from Inventory
   inner join WebGenres on Inventory.ID=WebGenres.InventoryID
   where WebGenres.Genre=@Genre4
   and Inventory.Format<>'CD' and Inventory.Format<>'LP' and Inventory.Format<>'12"' and Inventory.Format<>'10"' and Inventory.Format<>'7"'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  if @QtyCD+@QtyVinyl+@QtyOther>0
   begin
    if not exists(select counter from WebSearchSuggestions where Hint=@Genre4 and SearchType='Genre')
     begin
      insert into WebSearchSuggestions
      (Hint
      ,Word1
      ,Word2
      ,Word3
      ,Word4
      ,Word5
      ,Word6
      ,Word7
      ,Word8
      ,Word9
      ,Word10
      ,Total
      ,CD
      ,Vinyl
      ,Other
      ,SearchType)
      values
      (@Genre4
      ,@Genre4Word1
      ,@Genre4Word2
      ,@Genre4Word3
      ,@Genre4Word4
      ,@Genre4Word5
      ,@Genre4Word6
      ,@Genre4Word7
      ,@Genre4Word8
      ,@Genre4Word9
      ,@Genre4Word10
      ,@QtyCD+@QtyVinyl+@QtyOther
      ,@QtyCD
      ,@QtyVinyl
      ,@QtyOther
      ,'Genre')
     end
    else
     begin
      update WebSearchSuggestions
      set
       Total=@QtyCD+@QtyVinyl+@QtyOther
      ,CD=@QtyCD
      ,Vinyl=@QtyVinyl
      ,Other=@QtyOther
      where Hint=@Genre4 and SearchType='Genre'
     end
    end
  else
   delete WebSearchSuggestions where Hint=@Genre4 and SearchType='Genre'
 end

if @Genre5 <>'---'
 begin
  set @QtyCD=(select count(ID) from Inventory
   inner join WebGenres on Inventory.ID=WebGenres.InventoryID
   where WebGenres.Genre=@Genre5
   and Inventory.Format='CD'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyVinyl=(select count(ID) from Inventory
   inner join WebGenres on Inventory.ID=WebGenres.InventoryID
   where WebGenres.Genre=@Genre5
   and (Inventory.Format='LP' or Inventory.Format='12"' or Inventory.Format='10"' or Inventory.Format='7"')
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyOther=(select count(ID) from Inventory
   inner join WebGenres on Inventory.ID=WebGenres.InventoryID
   where WebGenres.Genre=@Genre5
   and Inventory.Format<>'CD' and Inventory.Format<>'LP' and Inventory.Format<>'12"' and Inventory.Format<>'10"' and Inventory.Format<>'7"'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  if @QtyCD+@QtyVinyl+@QtyOther>0
   begin
    if not exists(select counter from WebSearchSuggestions where Hint=@Genre5 and SearchType='Genre')
     begin
      insert into WebSearchSuggestions
      (Hint
      ,Word1
      ,Word2
      ,Word3
      ,Word4
      ,Word5
      ,Word6
      ,Word7
      ,Word8
      ,Word9
      ,Word10
      ,Total
      ,CD
      ,Vinyl
      ,Other
      ,SearchType)
      values
      (@Genre5
      ,@Genre5Word1
      ,@Genre5Word2
      ,@Genre5Word3
      ,@Genre5Word4
      ,@Genre5Word5
      ,@Genre5Word6
      ,@Genre5Word7
      ,@Genre5Word8
      ,@Genre5Word9
      ,@Genre5Word10
      ,@QtyCD+@QtyVinyl+@QtyOther
      ,@QtyCD
      ,@QtyVinyl
      ,@QtyOther
      ,'Genre')
     end
    else
     begin
      update WebSearchSuggestions
      set
       Total=@QtyCD+@QtyVinyl+@QtyOther
      ,CD=@QtyCD
      ,Vinyl=@QtyVinyl
      ,Other=@QtyOther
      where Hint=@Genre5 and SearchType='Genre'
     end
    end
  else
   delete WebSearchSuggestions where Hint=@Genre5 and SearchType='Genre'
 end

if @Genre6 <>'---'
 begin
  set @QtyCD=(select count(ID) from Inventory
   inner join WebGenres on Inventory.ID=WebGenres.InventoryID
   where WebGenres.Genre=@Genre6
   and Inventory.Format='CD'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyVinyl=(select count(ID) from Inventory
   inner join WebGenres on Inventory.ID=WebGenres.InventoryID
   where WebGenres.Genre=@Genre6
   and (Inventory.Format='LP' or Inventory.Format='12"' or Inventory.Format='10"' or Inventory.Format='7"')
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyOther=(select count(ID) from Inventory
   inner join WebGenres on Inventory.ID=WebGenres.InventoryID
   where WebGenres.Genre=@Genre6
   and Inventory.Format<>'CD' and Inventory.Format<>'LP' and Inventory.Format<>'12"' and Inventory.Format<>'10"' and Inventory.Format<>'7"'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  if @QtyCD+@QtyVinyl+@QtyOther>0
   begin
    if not exists(select counter from WebSearchSuggestions where Hint=@Genre6 and SearchType='Genre')
     begin
      insert into WebSearchSuggestions
      (Hint
      ,Word1
      ,Word2
      ,Word3
      ,Word4
      ,Word5
      ,Word6
      ,Word7
      ,Word8
      ,Word9
      ,Word10
      ,Total
      ,CD
      ,Vinyl
      ,Other
      ,SearchType)
      values
      (@Genre6
      ,@Genre6Word1
      ,@Genre6Word2
      ,@Genre6Word3
      ,@Genre6Word4
      ,@Genre6Word5
      ,@Genre6Word6
      ,@Genre6Word7
      ,@Genre6Word8
      ,@Genre6Word9
      ,@Genre6Word10
      ,@QtyCD+@QtyVinyl+@QtyOther
      ,@QtyCD
      ,@QtyVinyl
      ,@QtyOther
      ,'Genre')
     end
    else
     begin
      update WebSearchSuggestions
      set
       Total=@QtyCD+@QtyVinyl+@QtyOther
      ,CD=@QtyCD
      ,Vinyl=@QtyVinyl
      ,Other=@QtyOther
      where Hint=@Genre6 and SearchType='Genre'
     end
    end
  else
   delete WebSearchSuggestions where Hint=@Genre6 and SearchType='Genre'
 end

if @Genre7 <>'---'
 begin
  set @QtyCD=(select count(ID) from Inventory
   inner join WebGenres on Inventory.ID=WebGenres.InventoryID
   where WebGenres.Genre=@Genre7
   and Inventory.Format='CD'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyVinyl=(select count(ID) from Inventory
   inner join WebGenres on Inventory.ID=WebGenres.InventoryID
   where WebGenres.Genre=@Genre7
   and (Inventory.Format='LP' or Inventory.Format='12"' or Inventory.Format='10"' or Inventory.Format='7"')
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyOther=(select count(ID) from Inventory
   inner join WebGenres on Inventory.ID=WebGenres.InventoryID
   where WebGenres.Genre=@Genre7
   and Inventory.Format<>'CD' and Inventory.Format<>'LP' and Inventory.Format<>'12"' and Inventory.Format<>'10"' and Inventory.Format<>'7"'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  if @QtyCD+@QtyVinyl+@QtyOther>0
   begin
    if not exists(select counter from WebSearchSuggestions where Hint=@Genre7 and SearchType='Genre')
     begin
      insert into WebSearchSuggestions
      (Hint
      ,Word1
      ,Word2
      ,Word3
      ,Word4
      ,Word5
      ,Word6
      ,Word7
      ,Word8
      ,Word9
      ,Word10
      ,Total
      ,CD
      ,Vinyl
      ,Other
      ,SearchType)
      values
      (@Genre7
      ,@Genre7Word1
      ,@Genre7Word2
      ,@Genre7Word3
      ,@Genre7Word4
      ,@Genre7Word5
      ,@Genre7Word6
      ,@Genre7Word7
      ,@Genre7Word8
      ,@Genre7Word9
      ,@Genre7Word10
      ,@QtyCD+@QtyVinyl+@QtyOther
      ,@QtyCD
      ,@QtyVinyl
      ,@QtyOther
      ,'Genre')
     end
    else
     begin
      update WebSearchSuggestions
      set
       Total=@QtyCD+@QtyVinyl+@QtyOther
      ,CD=@QtyCD
      ,Vinyl=@QtyVinyl
      ,Other=@QtyOther
      where Hint=@Genre7 and SearchType='Genre'
     end
    end
  else
   delete WebSearchSuggestions where Hint=@Genre7 and SearchType='Genre'
 end

if @Genre8 <>'---'
 begin
  set @QtyCD=(select count(ID) from Inventory
   inner join WebGenres on Inventory.ID=WebGenres.InventoryID
   where WebGenres.Genre=@Genre8
   and Inventory.Format='CD'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyVinyl=(select count(ID) from Inventory
   inner join WebGenres on Inventory.ID=WebGenres.InventoryID
   where WebGenres.Genre=@Genre8
   and (Inventory.Format='LP' or Inventory.Format='12"' or Inventory.Format='10"' or Inventory.Format='7"')
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyOther=(select count(ID) from Inventory
   inner join WebGenres on Inventory.ID=WebGenres.InventoryID
   where WebGenres.Genre=@Genre8
   and Inventory.Format<>'CD' and Inventory.Format<>'LP' and Inventory.Format<>'12"' and Inventory.Format<>'10"' and Inventory.Format<>'7"'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  if @QtyCD+@QtyVinyl+@QtyOther>0
   begin
    if not exists(select counter from WebSearchSuggestions where Hint=@Genre8 and SearchType='Genre')
     begin
      insert into WebSearchSuggestions
      (Hint
      ,Word1
      ,Word2
      ,Word3
      ,Word4
      ,Word5
      ,Word6
      ,Word7
      ,Word8
      ,Word9
      ,Word10
      ,Total
      ,CD
      ,Vinyl
      ,Other
      ,SearchType)
      values
      (@Genre8
      ,@Genre8Word1
      ,@Genre8Word2
      ,@Genre8Word3
      ,@Genre8Word4
      ,@Genre8Word5
      ,@Genre8Word6
      ,@Genre8Word7
      ,@Genre8Word8
      ,@Genre8Word9
      ,@Genre8Word10
      ,@QtyCD+@QtyVinyl+@QtyOther
      ,@QtyCD
      ,@QtyVinyl
      ,@QtyOther
      ,'Genre')
     end
    else
     begin
      update WebSearchSuggestions
      set
       Total=@QtyCD+@QtyVinyl+@QtyOther
      ,CD=@QtyCD
      ,Vinyl=@QtyVinyl
      ,Other=@QtyOther
      where Hint=@Genre8 and SearchType='Genre'
     end
    end
  else
   delete WebSearchSuggestions where Hint=@Genre8 and SearchType='Genre'
 end

if @Genre9 <>'---'
 begin
  set @QtyCD=(select count(ID) from Inventory
   inner join WebGenres on Inventory.ID=WebGenres.InventoryID
   where WebGenres.Genre=@Genre9
   and Inventory.Format='CD'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyVinyl=(select count(ID) from Inventory
   inner join WebGenres on Inventory.ID=WebGenres.InventoryID
   where WebGenres.Genre=@Genre9
   and (Inventory.Format='LP' or Inventory.Format='12"' or Inventory.Format='10"' or Inventory.Format='7"')
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyOther=(select count(ID) from Inventory
   inner join WebGenres on Inventory.ID=WebGenres.InventoryID
   where WebGenres.Genre=@Genre9
   and Inventory.Format<>'CD' and Inventory.Format<>'LP' and Inventory.Format<>'12"' and Inventory.Format<>'10"' and Inventory.Format<>'7"'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  if @QtyCD+@QtyVinyl+@QtyOther>0
   begin
    if not exists(select counter from WebSearchSuggestions where Hint=@Genre9 and SearchType='Genre')
     begin
      insert into WebSearchSuggestions
      (Hint
      ,Word1
      ,Word2
      ,Word3
      ,Word4
      ,Word5
      ,Word6
      ,Word7
      ,Word8
      ,Word9
      ,Word10
      ,Total
      ,CD
      ,Vinyl
      ,Other
      ,SearchType)
      values
      (@Genre9
      ,@Genre9Word1
      ,@Genre9Word2
      ,@Genre9Word3
      ,@Genre9Word4
      ,@Genre9Word5
      ,@Genre9Word6
      ,@Genre9Word7
      ,@Genre9Word8
      ,@Genre9Word9
      ,@Genre9Word10
      ,@QtyCD+@QtyVinyl+@QtyOther
      ,@QtyCD
      ,@QtyVinyl
      ,@QtyOther
      ,'Genre')
     end
    else
     begin
      update WebSearchSuggestions
      set
       Total=@QtyCD+@QtyVinyl+@QtyOther
      ,CD=@QtyCD
      ,Vinyl=@QtyVinyl
      ,Other=@QtyOther
      where Hint=@Genre9 and SearchType='Genre'
     end
    end
  else
   delete WebSearchSuggestions where Hint=@Genre9 and SearchType='Genre'
 end
