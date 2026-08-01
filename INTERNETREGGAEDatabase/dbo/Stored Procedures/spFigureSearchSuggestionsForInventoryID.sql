



CREATE PROCEDURE [dbo].[spFigureSearchSuggestionsForInventoryID]

@InventoryID int

AS

--Artist Search Suggestions----------------------------------------------------------------

declare @Artist1 nvarchar(255)
declare @Artist2 nvarchar(255)
declare @Artist3 nvarchar(255)
declare @Artist4 nvarchar(255)
declare @Artist5 nvarchar(255)
declare @Artist6 nvarchar(255)
declare @QtyCD int
declare @QtyVinyl int
declare @QtyOther int

set @Artist1=(select top 1 Artist from WebArtists where InventoryID=@InventoryID)
if @Artist1 is null
 goto End1
set @Artist2=(select top 1 Artist from WebArtists where InventoryID=@InventoryID and Artist<>@Artist1)
if @Artist2 is null
 goto End1
set @Artist3=(select top 1 Artist from WebArtists where InventoryID=@InventoryID and Artist<>@Artist1 and Artist<>@Artist2)
if @Artist3 is null
 goto End1
set @Artist4=(select top 1 Artist from WebArtists where InventoryID=@InventoryID and Artist<>@Artist1 and Artist<>@Artist2 and Artist<>@Artist3)
if @Artist4 is null
 goto End1
set @Artist5=(select top 1 Artist from WebArtists where InventoryID=@InventoryID and Artist<>@Artist1 and Artist<>@Artist2 and Artist<>@Artist3 and Artist<>@Artist4)
if @Artist5 is null
 goto End1
set @Artist6=(select top 1 Artist from WebArtists where InventoryID=@InventoryID and Artist<>@Artist1 and Artist<>@Artist2 and Artist<>@Artist3 and Artist<>@Artist4 and Artist<>@Artist5)
End1:

if @Artist1 is not null
 begin
  set @QtyCD=(select count(ID) from Inventory
   inner join WebArtists on Inventory.ID=WebArtists.InventoryID
   where WebArtists.Artist=@Artist1
   and WebArtists.Format='CD'
   and Inventory.Inventory>0)
  set @QtyVinyl=(select count(ID) from Inventory
   inner join WebArtists on Inventory.ID=WebArtists.InventoryID
   where WebArtists.Artist=@Artist1
   and WebArtists.Format='Vinyl'
   and Inventory.Inventory>0)
  set @QtyOther=(select count(ID) from Inventory
   inner join WebArtists on Inventory.ID=WebArtists.InventoryID
   where WebArtists.Artist=@Artist1
   and WebArtists.Format='Other'
   and Inventory.Inventory>0)
  if @QtyCD+@QtyVinyl+@QtyOther>0
   begin
    if not exists(select counter from WebSearchSuggestions where Hint=@Artist1 and SearchType='Artist')
     begin
      insert into WebSearchSuggestions
      (Hint
      ,Total
      ,CD
      ,Vinyl
      ,Other
      ,SearchType)
      values
      (@Artist1
      ,@QtyCD+@QtyVinyl+@QtyOther
      ,@QtyCD
      ,@QtyVinyl
      ,@QtyOther
      ,'Artist')
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

if @Artist2 is not null
 begin
  set @QtyCD=(select count(ID) from Inventory
   inner join WebArtists on Inventory.ID=WebArtists.InventoryID
   where WebArtists.Artist=@Artist2
   and WebArtists.Format='CD'
   and Inventory.Inventory>0)
  set @QtyVinyl=(select count(ID) from Inventory
   inner join WebArtists on Inventory.ID=WebArtists.InventoryID
   where WebArtists.Artist=@Artist2
   and WebArtists.Format='Vinyl'
   and Inventory.Inventory>0)
  set @QtyOther=(select count(ID) from Inventory
   inner join WebArtists on Inventory.ID=WebArtists.InventoryID
   where WebArtists.Artist=@Artist2
   and WebArtists.Format='Other'
   and Inventory.Inventory>0)
  if @QtyCD+@QtyVinyl+@QtyOther>0
   begin
    if not exists(select counter from WebSearchSuggestions where Hint=@Artist2 and SearchType='Artist')
     begin
      insert into WebSearchSuggestions
      (Hint
      ,Total
      ,CD
      ,Vinyl
      ,Other
      ,SearchType)
      values
      (@Artist2
      ,@QtyCD+@QtyVinyl+@QtyOther
      ,@QtyCD
      ,@QtyVinyl
      ,@QtyOther
      ,'Artist')
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

if @Artist3 is not null
 begin
  set @QtyCD=(select count(ID) from Inventory
   inner join WebArtists on Inventory.ID=WebArtists.InventoryID
   where WebArtists.Artist=@Artist3
   and WebArtists.Format='CD'
   and Inventory.Inventory>0)
  set @QtyVinyl=(select count(ID) from Inventory
   inner join WebArtists on Inventory.ID=WebArtists.InventoryID
   where WebArtists.Artist=@Artist3
   and WebArtists.Format='Vinyl'
   and Inventory.Inventory>0)
  set @QtyOther=(select count(ID) from Inventory
   inner join WebArtists on Inventory.ID=WebArtists.InventoryID
   where WebArtists.Artist=@Artist3
   and WebArtists.Format='Other'
   and Inventory.Inventory>0)
  if @QtyCD+@QtyVinyl+@QtyOther>0
   begin
    if not exists(select counter from WebSearchSuggestions where Hint=@Artist3 and SearchType='Artist')
     begin
      insert into WebSearchSuggestions
      (Hint
      ,Total
      ,CD
      ,Vinyl
      ,Other
      ,SearchType)
      values
      (@Artist3
      ,@QtyCD+@QtyVinyl+@QtyOther
      ,@QtyCD
      ,@QtyVinyl
      ,@QtyOther
      ,'Artist')
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

if @Artist4 is not null
 begin
  set @QtyCD=(select count(ID) from Inventory
   inner join WebArtists on Inventory.ID=WebArtists.InventoryID
   where WebArtists.Artist=@Artist4
   and WebArtists.Format='CD'
   and Inventory.Inventory>0)
  set @QtyVinyl=(select count(ID) from Inventory
   inner join WebArtists on Inventory.ID=WebArtists.InventoryID
   where WebArtists.Artist=@Artist4
   and WebArtists.Format='Vinyl'
   and Inventory.Inventory>0)
  set @QtyOther=(select count(ID) from Inventory
   inner join WebArtists on Inventory.ID=WebArtists.InventoryID
   where WebArtists.Artist=@Artist4
   and WebArtists.Format='Other'
   and Inventory.Inventory>0)
  if @QtyCD+@QtyVinyl+@QtyOther>0
   begin
    if not exists(select counter from WebSearchSuggestions where Hint=@Artist4 and SearchType='Artist')
     begin
      insert into WebSearchSuggestions
      (Hint
      ,Total
      ,CD
      ,Vinyl
      ,Other
      ,SearchType)
      values
      (@Artist4
      ,@QtyCD+@QtyVinyl+@QtyOther
      ,@QtyCD
      ,@QtyVinyl
      ,@QtyOther
      ,'Artist')
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

if @Artist5 is not null
 begin
  set @QtyCD=(select count(ID) from Inventory
   inner join WebArtists on Inventory.ID=WebArtists.InventoryID
   where WebArtists.Artist=@Artist5
   and WebArtists.Format='CD'
   and Inventory.Inventory>0)
  set @QtyVinyl=(select count(ID) from Inventory
   inner join WebArtists on Inventory.ID=WebArtists.InventoryID
   where WebArtists.Artist=@Artist5
   and WebArtists.Format='Vinyl'
   and Inventory.Inventory>0)
  set @QtyOther=(select count(ID) from Inventory
   inner join WebArtists on Inventory.ID=WebArtists.InventoryID
   where WebArtists.Artist=@Artist5
   and WebArtists.Format='Other'
   and Inventory.Inventory>0)
  if @QtyCD+@QtyVinyl+@QtyOther>0
   begin
    if not exists(select counter from WebSearchSuggestions where Hint=@Artist5 and SearchType='Artist')
     begin
      insert into WebSearchSuggestions
      (Hint
      ,Total
      ,CD
      ,Vinyl
      ,Other
      ,SearchType)
      values
      (@Artist5
      ,@QtyCD+@QtyVinyl+@QtyOther
      ,@QtyCD
      ,@QtyVinyl
      ,@QtyOther
      ,'Artist')
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

if @Artist6 is not null
 begin
  set @QtyCD=(select count(ID) from Inventory
   inner join WebArtists on Inventory.ID=WebArtists.InventoryID
   where WebArtists.Artist=@Artist6
   and WebArtists.Format='CD'
   and Inventory.Inventory>0)
  set @QtyVinyl=(select count(ID) from Inventory
   inner join WebArtists on Inventory.ID=WebArtists.InventoryID
   where WebArtists.Artist=@Artist6
   and WebArtists.Format='Vinyl'
   and Inventory.Inventory>0)
  set @QtyOther=(select count(ID) from Inventory
   inner join WebArtists on Inventory.ID=WebArtists.InventoryID
   where WebArtists.Artist=@Artist6
   and WebArtists.Format='Other'
   and Inventory.Inventory>0)
  if @QtyCD+@QtyVinyl+@QtyOther>0
   begin
    if not exists(select counter from WebSearchSuggestions where Hint=@Artist6 and SearchType='Artist')
     begin
      insert into WebSearchSuggestions
      (Hint
      ,Total
      ,CD
      ,Vinyl
      ,Other
      ,SearchType)
      values
      (@Artist6
      ,@QtyCD+@QtyVinyl+@QtyOther
      ,@QtyCD
      ,@QtyVinyl
      ,@QtyOther
      ,'Artist')
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

--Genre Search Suggestions----------------------------------------------------------------

declare @Genre1 nvarchar(30)
declare @Genre2 nvarchar(30)
declare @Genre3 nvarchar(30)
declare @Genre4 nvarchar(30)
declare @Genre5 nvarchar(30)
declare @Genre6 nvarchar(30)
declare @Genre7 nvarchar(30)
declare @Genre8 nvarchar(30)
declare @Genre9 nvarchar(30)

set @Genre1=(select Genre1 from Inventory where ID=@InventoryID)
if @Genre1 is null
 goto End2
set @Genre2=(select Genre2 from Inventory where ID=@InventoryID)
if @Genre2 is null
 goto End2
set @Genre3=(select Genre3 from Inventory where ID=@InventoryID)
if @Genre3 is null
 goto End2
set @Genre4=(select Genre4 from Inventory where ID=@InventoryID)
if @Genre4 is null
 goto End2
set @Genre5=(select Genre5 from Inventory where ID=@InventoryID)
if @Genre5 is null
 goto End2
set @Genre6=(select Genre6 from Inventory where ID=@InventoryID)
if @Genre6 is null
 goto End2
set @Genre7=(select Genre7 from Inventory where ID=@InventoryID)
if @Genre7 is null
 goto End2
set @Genre8=(select Genre8 from Inventory where ID=@InventoryID)
if @Genre8 is null
 goto End2
set @Genre9=(select Genre9 from Inventory where ID=@InventoryID)
End2:

if @Genre1 is not null
 begin
  set @QtyCD=(select count(ID) from Inventory
   where (Genre1=@Genre1 or Genre2=@Genre1 or Genre3=@Genre1 or Genre4=@Genre1 or Genre5=@Genre1 or Genre6=@Genre1 or Genre7=@Genre1 or Genre8=@Genre1 or Genre9=@Genre1)
   and Format='CD'
   and Inventory>0)
  set @QtyVinyl=(select count(ID) from Inventory
   where (Genre1=@Genre1 or Genre2=@Genre1 or Genre3=@Genre1 or Genre4=@Genre1 or Genre5=@Genre1 or Genre6=@Genre1 or Genre7=@Genre1 or Genre8=@Genre1 or Genre9=@Genre1)
   and (Format='LP' or Format='12"' or Format='10"' or Format='7"')
   and Inventory>0)
  set @QtyOther=(select count(ID) from Inventory
   where (Genre1=@Genre1 or Genre2=@Genre1 or Genre3=@Genre1 or Genre4=@Genre1 or Genre5=@Genre1 or Genre6=@Genre1 or Genre7=@Genre1 or Genre8=@Genre1 or Genre9=@Genre1)
   and Format<>'CD' and Format<>'LP' and Format<>'12"' and Format<>'10"' and Format<>'7"'
   and Inventory>0)
  if @QtyCD+@QtyVinyl+@QtyOther>0
   begin
    if not exists(select counter from WebSearchSuggestions where Hint=@Genre1 and SearchType='Genre')
     begin
      insert into WebSearchSuggestions
      (Hint
      ,Total
      ,CD
      ,Vinyl
      ,Other
      ,SearchType)
      values
      (@Genre1
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

if @Genre2 is not null
 begin
  set @QtyCD=(select count(ID) from Inventory
   where (Genre1=@Genre2 or Genre2=@Genre2 or Genre3=@Genre2 or Genre4=@Genre2 or Genre5=@Genre2 or Genre6=@Genre2 or Genre7=@Genre2 or Genre8=@Genre2 or Genre9=@Genre2)
   and Format='CD'
   and Inventory>0)
  set @QtyVinyl=(select count(ID) from Inventory
   where (Genre1=@Genre2 or Genre2=@Genre2 or Genre3=@Genre2 or Genre4=@Genre2 or Genre5=@Genre2 or Genre6=@Genre2 or Genre7=@Genre2 or Genre8=@Genre2 or Genre9=@Genre2)
   and (Format='LP' or Format='12"' or Format='10"' or Format='7"')
   and Inventory>0)
  set @QtyOther=(select count(ID) from Inventory
   where (Genre1=@Genre2 or Genre2=@Genre2 or Genre3=@Genre2 or Genre4=@Genre2 or Genre5=@Genre2 or Genre6=@Genre2 or Genre7=@Genre2 or Genre8=@Genre2 or Genre9=@Genre2)
   and Format<>'CD' and Format<>'LP' and Format<>'12"' and Format<>'10"' and Format<>'7"'
   and Inventory>0)
  if @QtyCD+@QtyVinyl+@QtyOther>0
   begin
    if not exists(select counter from WebSearchSuggestions where Hint=@Genre2 and SearchType='Genre')
     begin
      insert into WebSearchSuggestions
      (Hint
      ,Total
      ,CD
      ,Vinyl
      ,Other
      ,SearchType)
      values
      (@Genre2
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

if @Genre3 is not null
 begin
  set @QtyCD=(select count(ID) from Inventory
   where (Genre1=@Genre3 or Genre2=@Genre3 or Genre3=@Genre3 or Genre4=@Genre3 or Genre5=@Genre3 or Genre6=@Genre3 or Genre7=@Genre3 or Genre8=@Genre3 or Genre9=@Genre3)
   and Format='CD'
   and Inventory>0)
  set @QtyVinyl=(select count(ID) from Inventory
   where (Genre1=@Genre3 or Genre2=@Genre3 or Genre3=@Genre3 or Genre4=@Genre3 or Genre5=@Genre3 or Genre6=@Genre3 or Genre7=@Genre3 or Genre8=@Genre3 or Genre9=@Genre3)
   and (Format='LP' or Format='12"' or Format='10"' or Format='7"')
   and Inventory>0)
  set @QtyOther=(select count(ID) from Inventory
   where (Genre1=@Genre3 or Genre2=@Genre3 or Genre3=@Genre3 or Genre4=@Genre3 or Genre5=@Genre3 or Genre6=@Genre3 or Genre7=@Genre3 or Genre8=@Genre3 or Genre9=@Genre3)
   and Format<>'CD' and Format<>'LP' and Format<>'12"' and Format<>'10"' and Format<>'7"'
   and Inventory>0)
  if @QtyCD+@QtyVinyl+@QtyOther>0
   begin
    if not exists(select counter from WebSearchSuggestions where Hint=@Genre3 and SearchType='Genre')
     begin
      insert into WebSearchSuggestions
      (Hint
      ,Total
      ,CD
      ,Vinyl
      ,Other
      ,SearchType)
      values
      (@Genre3
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

if @Genre4 is not null
 begin
  set @QtyCD=(select count(ID) from Inventory
   where (Genre1=@Genre4 or Genre2=@Genre4 or Genre3=@Genre4 or Genre4=@Genre4 or Genre5=@Genre4 or Genre6=@Genre4 or Genre7=@Genre4 or Genre8=@Genre4 or Genre9=@Genre4)
   and Format='CD'
   and Inventory>0)
  set @QtyVinyl=(select count(ID) from Inventory
   where (Genre1=@Genre4 or Genre2=@Genre4 or Genre3=@Genre4 or Genre4=@Genre4 or Genre5=@Genre4 or Genre6=@Genre4 or Genre7=@Genre4 or Genre8=@Genre4 or Genre9=@Genre4)
   and (Format='LP' or Format='12"' or Format='10"' or Format='7"')
   and Inventory>0)
  set @QtyOther=(select count(ID) from Inventory
   where (Genre1=@Genre4 or Genre2=@Genre4 or Genre3=@Genre4 or Genre4=@Genre4 or Genre5=@Genre4 or Genre6=@Genre4 or Genre7=@Genre4 or Genre8=@Genre4 or Genre9=@Genre4)
   and Format<>'CD' and Format<>'LP' and Format<>'12"' and Format<>'10"' and Format<>'7"'
   and Inventory>0)
  if @QtyCD+@QtyVinyl+@QtyOther>0
   begin
    if not exists(select counter from WebSearchSuggestions where Hint=@Genre4 and SearchType='Genre')
     begin
      insert into WebSearchSuggestions
      (Hint
      ,Total
      ,CD
      ,Vinyl
      ,Other
      ,SearchType)
      values
      (@Genre4
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

if @Genre5 is not null
 begin
  set @QtyCD=(select count(ID) from Inventory
   where (Genre1=@Genre5 or Genre2=@Genre5 or Genre3=@Genre5 or Genre4=@Genre5 or Genre5=@Genre5 or Genre6=@Genre5 or Genre7=@Genre5 or Genre8=@Genre5 or Genre9=@Genre5)
   and Format='CD'
   and Inventory>0)
  set @QtyVinyl=(select count(ID) from Inventory
   where (Genre1=@Genre5 or Genre2=@Genre5 or Genre3=@Genre5 or Genre4=@Genre5 or Genre5=@Genre5 or Genre6=@Genre5 or Genre7=@Genre5 or Genre8=@Genre5 or Genre9=@Genre5)
   and (Format='LP' or Format='12"' or Format='10"' or Format='7"')
   and Inventory>0)
  set @QtyOther=(select count(ID) from Inventory
   where (Genre1=@Genre5 or Genre2=@Genre5 or Genre3=@Genre5 or Genre4=@Genre5 or Genre5=@Genre5 or Genre6=@Genre5 or Genre7=@Genre5 or Genre8=@Genre5 or Genre9=@Genre5)
   and Format<>'CD' and Format<>'LP' and Format<>'12"' and Format<>'10"' and Format<>'7"'
   and Inventory>0)
  if @QtyCD+@QtyVinyl+@QtyOther>0
   begin
    if not exists(select counter from WebSearchSuggestions where Hint=@Genre5 and SearchType='Genre')
     begin
      insert into WebSearchSuggestions
      (Hint
      ,Total
      ,CD
      ,Vinyl
      ,Other
      ,SearchType)
      values
      (@Genre5
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

if @Genre6 is not null
 begin
  set @QtyCD=(select count(ID) from Inventory
   where (Genre1=@Genre6 or Genre2=@Genre6 or Genre3=@Genre6 or Genre4=@Genre6 or Genre5=@Genre6 or Genre6=@Genre6 or Genre7=@Genre6 or Genre8=@Genre6 or Genre9=@Genre6)
   and Format='CD'
   and Inventory>0)
  set @QtyVinyl=(select count(ID) from Inventory
   where (Genre1=@Genre6 or Genre2=@Genre6 or Genre3=@Genre6 or Genre4=@Genre6 or Genre5=@Genre6 or Genre6=@Genre6 or Genre7=@Genre6 or Genre8=@Genre6 or Genre9=@Genre6)
   and (Format='LP' or Format='12"' or Format='10"' or Format='7"')
   and Inventory>0)
  set @QtyOther=(select count(ID) from Inventory
   where (Genre1=@Genre6 or Genre2=@Genre6 or Genre3=@Genre6 or Genre4=@Genre6 or Genre5=@Genre6 or Genre6=@Genre6 or Genre7=@Genre6 or Genre8=@Genre6 or Genre9=@Genre6)
   and Format<>'CD' and Format<>'LP' and Format<>'12"' and Format<>'10"' and Format<>'7"'
   and Inventory>0)
  if @QtyCD+@QtyVinyl+@QtyOther>0
   begin
    if not exists(select counter from WebSearchSuggestions where Hint=@Genre6 and SearchType='Genre')
     begin
      insert into WebSearchSuggestions
      (Hint
      ,Total
      ,CD
      ,Vinyl
      ,Other
      ,SearchType)
      values
      (@Genre6
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

if @Genre7 is not null
 begin
  set @QtyCD=(select count(ID) from Inventory
   where (Genre1=@Genre7 or Genre2=@Genre7 or Genre3=@Genre7 or Genre4=@Genre7 or Genre5=@Genre7 or Genre6=@Genre7 or Genre7=@Genre7 or Genre8=@Genre7 or Genre9=@Genre7)
   and Format='CD'
   and Inventory>0)
  set @QtyVinyl=(select count(ID) from Inventory
   where (Genre1=@Genre7 or Genre2=@Genre7 or Genre3=@Genre7 or Genre4=@Genre7 or Genre5=@Genre7 or Genre6=@Genre7 or Genre7=@Genre7 or Genre8=@Genre7 or Genre9=@Genre7)
   and (Format='LP' or Format='12"' or Format='10"' or Format='7"')
   and Inventory>0)
  set @QtyOther=(select count(ID) from Inventory
   where (Genre1=@Genre7 or Genre2=@Genre7 or Genre3=@Genre7 or Genre4=@Genre7 or Genre5=@Genre7 or Genre6=@Genre7 or Genre7=@Genre7 or Genre8=@Genre7 or Genre9=@Genre7)
   and Format<>'CD' and Format<>'LP' and Format<>'12"' and Format<>'10"' and Format<>'7"'
   and Inventory>0)
  if @QtyCD+@QtyVinyl+@QtyOther>0
   begin
    if not exists(select counter from WebSearchSuggestions where Hint=@Genre7 and SearchType='Genre')
     begin
      insert into WebSearchSuggestions
      (Hint
      ,Total
      ,CD
      ,Vinyl
      ,Other
      ,SearchType)
      values
      (@Genre7
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

if @Genre8 is not null
 begin
  set @QtyCD=(select count(ID) from Inventory
   where (Genre1=@Genre8 or Genre2=@Genre8 or Genre3=@Genre8 or Genre4=@Genre8 or Genre5=@Genre8 or Genre6=@Genre8 or Genre7=@Genre8 or Genre8=@Genre8 or Genre9=@Genre8)
   and Format='CD'
   and Inventory>0)
  set @QtyVinyl=(select count(ID) from Inventory
   where (Genre1=@Genre8 or Genre2=@Genre8 or Genre3=@Genre8 or Genre4=@Genre8 or Genre5=@Genre8 or Genre6=@Genre8 or Genre7=@Genre8 or Genre8=@Genre8 or Genre9=@Genre8)
   and (Format='LP' or Format='12"' or Format='10"' or Format='7"')
   and Inventory>0)
  set @QtyOther=(select count(ID) from Inventory
   where (Genre1=@Genre8 or Genre2=@Genre8 or Genre3=@Genre8 or Genre4=@Genre8 or Genre5=@Genre8 or Genre6=@Genre8 or Genre7=@Genre8 or Genre8=@Genre8 or Genre9=@Genre8)
   and Format<>'CD' and Format<>'LP' and Format<>'12"' and Format<>'10"' and Format<>'7"'
   and Inventory>0)
  if @QtyCD+@QtyVinyl+@QtyOther>0
   begin
    if not exists(select counter from WebSearchSuggestions where Hint=@Genre8 and SearchType='Genre')
     begin
      insert into WebSearchSuggestions
      (Hint
      ,Total
      ,CD
      ,Vinyl
      ,Other
      ,SearchType)
      values
      (@Genre8
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

if @Genre9 is not null
 begin
  set @QtyCD=(select count(ID) from Inventory
   where (Genre1=@Genre9 or Genre2=@Genre9 or Genre3=@Genre9 or Genre4=@Genre9 or Genre5=@Genre9 or Genre6=@Genre9 or Genre7=@Genre9 or Genre8=@Genre9 or Genre9=@Genre9)
   and Format='CD'
   and Inventory>0)
  set @QtyVinyl=(select count(ID) from Inventory
   where (Genre1=@Genre9 or Genre2=@Genre9 or Genre3=@Genre9 or Genre4=@Genre9 or Genre5=@Genre9 or Genre6=@Genre9 or Genre7=@Genre9 or Genre8=@Genre9 or Genre9=@Genre9)
   and (Format='LP' or Format='12"' or Format='10"' or Format='7"')
   and Inventory>0)
  set @QtyOther=(select count(ID) from Inventory
   where (Genre1=@Genre9 or Genre2=@Genre9 or Genre3=@Genre9 or Genre4=@Genre9 or Genre5=@Genre9 or Genre6=@Genre9 or Genre7=@Genre9 or Genre8=@Genre9 or Genre9=@Genre9)
   and Format<>'CD' and Format<>'LP' and Format<>'12"' and Format<>'10"' and Format<>'7"'
   and Inventory>0)
  if @QtyCD+@QtyVinyl+@QtyOther>0
   begin
    if not exists(select counter from WebSearchSuggestions where Hint=@Genre9 and SearchType='Genre')
     begin
      insert into WebSearchSuggestions
      (Hint
      ,Total
      ,CD
      ,Vinyl
      ,Other
      ,SearchType)
      values
      (@Genre9
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

--Label Search Suggestions----------------------------------------------------------------

declare @Label nvarchar(120)

set @Label=(select [Label] from Inventory where ID=@InventoryID)

if @Label is not null
 begin
  set @QtyCD=(select count(ID) from Inventory
   where Label=@Label
   and Format='CD'
   and Inventory>0)
  set @QtyVinyl=(select count(ID) from Inventory
   where Label=@Label
   and (Format='LP' or Format='12"' or Format='10"' or Format='7"')
   and Inventory>0)
  set @QtyOther=(select count(ID) from Inventory
   where Label=@Label
   and Format<>'CD' and Format<>'LP' and Format<>'12"' and Format<>'10"' and Format<>'7"'
   and Inventory>0)
  if @QtyCD+@QtyVinyl+@QtyOther>0
   begin
    if not exists(select counter from WebSearchSuggestions where Hint=@Label and SearchType='Label')
     begin
      insert into WebSearchSuggestions
      (Hint
      ,Total
      ,CD
      ,Vinyl
      ,Other
      ,SearchType)
      values
      (@Label
      ,@QtyCD+@QtyVinyl+@QtyOther
      ,@QtyCD
      ,@QtyVinyl
      ,@QtyOther
      ,'Label')
     end
    else
     begin
      update WebSearchSuggestions
      set
       Total=@QtyCD+@QtyVinyl+@QtyOther
      ,CD=@QtyCD
      ,Vinyl=@QtyVinyl
      ,Other=@QtyOther
      where Hint=@Label and SearchType='Label'
     end
    end
  else
   delete WebSearchSuggestions where Hint=@Label and SearchType='Label'
 end

--Item Features Search Suggestions----------------------------------------------------------------

Declare @ItemFeatureID int
declare @ItemFeatureHint nvarchar(255)

declare cursor_Features cursor
for select InventoryItemFeatureID from InventoryItemFeatures
inner join Inventory on InventoryItemFeatures.ItemID=Inventory.ID
where InventoryItemFeatures.ItemID=@InventoryID

open cursor_Features
fetch next from cursor_Features into @ItemFeatureID
while @@Fetch_Status=0
 begin
  set @ItemFeatureHint=(select Hint from InventoryItemFeatureIndex where InventoryItemFeatureID=@ItemFeatureID)
  set @QtyCD=(select count(Inventory.ID)from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatures.InventoryItemFeatureID=@ItemFeatureID
   and InventoryItemFeatureIndex.Hint is not null
   and Format='CD'
   and Inventory>0)
  set @QtyVinyl=(select count(Inventory.ID)from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatures.InventoryItemFeatureID=@ItemFeatureID
   and InventoryItemFeatureIndex.Hint is not null
   and (Format='LP' or Format='12"' or Format='10"' or Format='7"')
   and Inventory>0)
  set @QtyOther=(select count(Inventory.ID)from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatures.InventoryItemFeatureID=@ItemFeatureID
   and InventoryItemFeatureIndex.Hint is not null
   and Format<>'CD' and Format<>'LP' and Format<>'12"' and Format<>'10"' and Format<>'7"'
   and Inventory>0)
  if @QtyCD+@QtyVinyl+@QtyOther>0
   begin
    if not exists(select counter from WebSearchSuggestions where Hint=@ItemFeatureHint and SearchType='Item Feature')
     begin
      insert into WebSearchSuggestions
      (Hint
      ,Total
      ,CD
      ,Vinyl
      ,Other
      ,SearchType)
      values
      (@ItemFeatureHint
      ,@QtyCD+@QtyVinyl+@QtyOther
      ,@QtyCD
      ,@QtyVinyl
      ,@QtyOther
      ,'Item Feature')
     end
    else
     begin
      update WebSearchSuggestions
      set
       Total=@QtyCD+@QtyVinyl+@QtyOther
      ,CD=@QtyCD
      ,Vinyl=@QtyVinyl
      ,Other=@QtyOther
      where Hint=@ItemFeatureHint and SearchType='Item Feature'
     end
    end
  else
   delete WebSearchSuggestions where Hint=@ItemFeatureHint and SearchType='Item Feature'

  fetch next from cursor_Features into @ItemFeatureID
 end
close cursor_Features
deallocate cursor_Features
