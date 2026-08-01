CREATE PROCEDURE [dbo].[spFigureWebSearchSuggestionsITEMFEATURES] 
  @ItemFeature1 nvarchar(255),
  @ItemFeature2 nvarchar(255),
  @ItemFeature3 nvarchar(255),
  @ItemFeature4 nvarchar(255),
  @ItemFeature5 nvarchar(255),
  @ItemFeature6 nvarchar(255),
  @ItemFeature7 nvarchar(255),
  @ItemFeature8 nvarchar(255),
  @ItemFeature9 nvarchar(255),
  @ItemFeature10 nvarchar(255),
  @ItemFeature11 nvarchar(255),
  @ItemFeature12 nvarchar(255),
  @ItemFeature13 nvarchar(255),
  @ItemFeature14 nvarchar(255),
  @ItemFeature15 nvarchar(255),
  @ItemFeature1Word1 nvarchar(50),
  @ItemFeature1Word2 nvarchar(50),
  @ItemFeature1Word3 nvarchar(50),
  @ItemFeature1Word4 nvarchar(50),
  @ItemFeature1Word5 nvarchar(50),
  @ItemFeature1Word6 nvarchar(50),
  @ItemFeature1Word7 nvarchar(50),
  @ItemFeature1Word8 nvarchar(50),
  @ItemFeature1Word9 nvarchar(50),
  @ItemFeature1Word10 nvarchar(50),
  @ItemFeature2Word1 nvarchar(50),
  @ItemFeature2Word2 nvarchar(50),
  @ItemFeature2Word3 nvarchar(50),
  @ItemFeature2Word4 nvarchar(50),
  @ItemFeature2Word5 nvarchar(50),
  @ItemFeature2Word6 nvarchar(50),
  @ItemFeature2Word7 nvarchar(50),
  @ItemFeature2Word8 nvarchar(50),
  @ItemFeature2Word9 nvarchar(50),
  @ItemFeature2Word10 nvarchar(50),
  @ItemFeature3Word1 nvarchar(50),
  @ItemFeature3Word2 nvarchar(50),
  @ItemFeature3Word3 nvarchar(50),
  @ItemFeature3Word4 nvarchar(50),
  @ItemFeature3Word5 nvarchar(50),
  @ItemFeature3Word6 nvarchar(50),
  @ItemFeature3Word7 nvarchar(50),
  @ItemFeature3Word8 nvarchar(50),
  @ItemFeature3Word9 nvarchar(50),
  @ItemFeature3Word10 nvarchar(50),
  @ItemFeature4Word1 nvarchar(50),
  @ItemFeature4Word2 nvarchar(50),
  @ItemFeature4Word3 nvarchar(50),
  @ItemFeature4Word4 nvarchar(50),
  @ItemFeature4Word5 nvarchar(50),
  @ItemFeature4Word6 nvarchar(50),
  @ItemFeature4Word7 nvarchar(50),
  @ItemFeature4Word8 nvarchar(50),
  @ItemFeature4Word9 nvarchar(50),
  @ItemFeature4Word10 nvarchar(50),
  @ItemFeature5Word1 nvarchar(50),
  @ItemFeature5Word2 nvarchar(50),
  @ItemFeature5Word3 nvarchar(50),
  @ItemFeature5Word4 nvarchar(50),
  @ItemFeature5Word5 nvarchar(50),
  @ItemFeature5Word6 nvarchar(50),
  @ItemFeature5Word7 nvarchar(50),
  @ItemFeature5Word8 nvarchar(50),
  @ItemFeature5Word9 nvarchar(50),
  @ItemFeature5Word10 nvarchar(50),
  @ItemFeature6Word1 nvarchar(50),
  @ItemFeature6Word2 nvarchar(50),
  @ItemFeature6Word3 nvarchar(50),
  @ItemFeature6Word4 nvarchar(50),
  @ItemFeature6Word5 nvarchar(50),
  @ItemFeature6Word6 nvarchar(50),
  @ItemFeature6Word7 nvarchar(50),
  @ItemFeature6Word8 nvarchar(50),
  @ItemFeature6Word9 nvarchar(50),
  @ItemFeature6Word10 nvarchar(50),
  @ItemFeature7Word1 nvarchar(50),
  @ItemFeature7Word2 nvarchar(50),
  @ItemFeature7Word3 nvarchar(50),
  @ItemFeature7Word4 nvarchar(50),
  @ItemFeature7Word5 nvarchar(50),
  @ItemFeature7Word6 nvarchar(50),
  @ItemFeature7Word7 nvarchar(50),
  @ItemFeature7Word8 nvarchar(50),
  @ItemFeature7Word9 nvarchar(50),
  @ItemFeature7Word10 nvarchar(50),
  @ItemFeature8Word1 nvarchar(50),
  @ItemFeature8Word2 nvarchar(50),
  @ItemFeature8Word3 nvarchar(50),
  @ItemFeature8Word4 nvarchar(50),
  @ItemFeature8Word5 nvarchar(50),
  @ItemFeature8Word6 nvarchar(50),
  @ItemFeature8Word7 nvarchar(50),
  @ItemFeature8Word8 nvarchar(50),
  @ItemFeature8Word9 nvarchar(50),
  @ItemFeature8Word10 nvarchar(50),
  @ItemFeature9Word1 nvarchar(50),
  @ItemFeature9Word2 nvarchar(50),
  @ItemFeature9Word3 nvarchar(50),
  @ItemFeature9Word4 nvarchar(50),
  @ItemFeature9Word5 nvarchar(50),
  @ItemFeature9Word6 nvarchar(50),
  @ItemFeature9Word7 nvarchar(50),
  @ItemFeature9Word8 nvarchar(50),
  @ItemFeature9Word9 nvarchar(50),
  @ItemFeature9Word10 nvarchar(50),
  @ItemFeature10Word1 nvarchar(50),
  @ItemFeature10Word2 nvarchar(50),
  @ItemFeature10Word3 nvarchar(50),
  @ItemFeature10Word4 nvarchar(50),
  @ItemFeature10Word5 nvarchar(50),
  @ItemFeature10Word6 nvarchar(50),
  @ItemFeature10Word7 nvarchar(50),
  @ItemFeature10Word8 nvarchar(50),
  @ItemFeature10Word9 nvarchar(50),
  @ItemFeature10Word10 nvarchar(50),
  @ItemFeature11Word1 nvarchar(50),
  @ItemFeature11Word2 nvarchar(50),
  @ItemFeature11Word3 nvarchar(50),
  @ItemFeature11Word4 nvarchar(50),
  @ItemFeature11Word5 nvarchar(50),
  @ItemFeature11Word6 nvarchar(50),
  @ItemFeature11Word7 nvarchar(50),
  @ItemFeature11Word8 nvarchar(50),
  @ItemFeature11Word9 nvarchar(50),
  @ItemFeature11Word10 nvarchar(50),
  @ItemFeature12Word1 nvarchar(50),
  @ItemFeature12Word2 nvarchar(50),
  @ItemFeature12Word3 nvarchar(50),
  @ItemFeature12Word4 nvarchar(50),
  @ItemFeature12Word5 nvarchar(50),
  @ItemFeature12Word6 nvarchar(50),
  @ItemFeature12Word7 nvarchar(50),
  @ItemFeature12Word8 nvarchar(50),
  @ItemFeature12Word9 nvarchar(50),
  @ItemFeature12Word10 nvarchar(50),
  @ItemFeature13Word1 nvarchar(50),
  @ItemFeature13Word2 nvarchar(50),
  @ItemFeature13Word3 nvarchar(50),
  @ItemFeature13Word4 nvarchar(50),
  @ItemFeature13Word5 nvarchar(50),
  @ItemFeature13Word6 nvarchar(50),
  @ItemFeature13Word7 nvarchar(50),
  @ItemFeature13Word8 nvarchar(50),
  @ItemFeature13Word9 nvarchar(50),
  @ItemFeature13Word10 nvarchar(50),
  @ItemFeature14Word1 nvarchar(50),
  @ItemFeature14Word2 nvarchar(50),
  @ItemFeature14Word3 nvarchar(50),
  @ItemFeature14Word4 nvarchar(50),
  @ItemFeature14Word5 nvarchar(50),
  @ItemFeature14Word6 nvarchar(50),
  @ItemFeature14Word7 nvarchar(50),
  @ItemFeature14Word8 nvarchar(50),
  @ItemFeature14Word9 nvarchar(50),
  @ItemFeature14Word10 nvarchar(50),
  @ItemFeature15Word1 nvarchar(50),
  @ItemFeature15Word2 nvarchar(50),
  @ItemFeature15Word3 nvarchar(50),
  @ItemFeature15Word4 nvarchar(50),
  @ItemFeature15Word5 nvarchar(50),
  @ItemFeature15Word6 nvarchar(50),
  @ItemFeature15Word7 nvarchar(50),
  @ItemFeature15Word8 nvarchar(50),
  @ItemFeature15Word9 nvarchar(50),
  @ItemFeature15Word10 nvarchar(50)
AS

declare @QtyCD int
declare @QtyVinyl int
declare @QtyOther int

if @ItemFeature1 <>'---'
 begin
  set @QtyCD=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@ItemFeature1
   and Inventory.Format='CD'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyVinyl=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@ItemFeature1
   and (Inventory.Format='LP' or Inventory.Format='12"' or Inventory.Format='10"' or Inventory.Format='7"')
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyOther=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@ItemFeature1
   and Inventory.Format<>'CD' and Inventory.Format<>'LP' and Inventory.Format<>'12"' and Inventory.Format<>'10"' and Inventory.Format<>'7"'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  if @QtyCD+@QtyVinyl+@QtyOther>0
   begin
    if not exists(select counter from WebSearchSuggestions where Hint=@ItemFeature1 and SearchType='Item Feature')
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
      (@ItemFeature1
      ,@ItemFeature1Word1
      ,@ItemFeature1Word2
      ,@ItemFeature1Word3
      ,@ItemFeature1Word4
      ,@ItemFeature1Word5
      ,@ItemFeature1Word6
      ,@ItemFeature1Word7
      ,@ItemFeature1Word8
      ,@ItemFeature1Word9
      ,@ItemFeature1Word10
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
      where Hint=@ItemFeature1 and SearchType='Item Feature'
     end
    end
  else
   delete WebSearchSuggestions where Hint=@ItemFeature1 and SearchType='Item Feature'
 end

if @ItemFeature2 <>'---'
 begin
  set @QtyCD=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@ItemFeature2
   and Inventory.Format='CD'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyVinyl=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@ItemFeature2
   and (Inventory.Format='LP' or Inventory.Format='12"' or Inventory.Format='10"' or Inventory.Format='7"')
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyOther=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@ItemFeature2
   and Inventory.Format<>'CD' and Inventory.Format<>'LP' and Inventory.Format<>'12"' and Inventory.Format<>'10"' and Inventory.Format<>'7"'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  if @QtyCD+@QtyVinyl+@QtyOther>0
   begin
    if not exists(select counter from WebSearchSuggestions where Hint=@ItemFeature2 and SearchType='Item Feature')
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
      (@ItemFeature2
      ,@ItemFeature2Word1
      ,@ItemFeature2Word2
      ,@ItemFeature2Word3
      ,@ItemFeature2Word4
      ,@ItemFeature2Word5
      ,@ItemFeature2Word6
      ,@ItemFeature2Word7
      ,@ItemFeature2Word8
      ,@ItemFeature2Word9
      ,@ItemFeature2Word10
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
      where Hint=@ItemFeature2 and SearchType='Item Feature'
     end
    end
  else
   delete WebSearchSuggestions where Hint=@ItemFeature2 and SearchType='Item Feature'
 end

if @ItemFeature3 <>'---'
 begin
  set @QtyCD=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@ItemFeature3
   and Inventory.Format='CD'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyVinyl=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@ItemFeature3
   and (Inventory.Format='LP' or Inventory.Format='12"' or Inventory.Format='10"' or Inventory.Format='7"')
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyOther=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@ItemFeature3
   and Inventory.Format<>'CD' and Inventory.Format<>'LP' and Inventory.Format<>'12"' and Inventory.Format<>'10"' and Inventory.Format<>'7"'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  if @QtyCD+@QtyVinyl+@QtyOther>0
   begin
    if not exists(select counter from WebSearchSuggestions where Hint=@ItemFeature3 and SearchType='Item Feature')
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
      (@ItemFeature3
      ,@ItemFeature3Word1
      ,@ItemFeature3Word2
      ,@ItemFeature3Word3
      ,@ItemFeature3Word4
      ,@ItemFeature3Word5
      ,@ItemFeature3Word6
      ,@ItemFeature3Word7
      ,@ItemFeature3Word8
      ,@ItemFeature3Word9
      ,@ItemFeature3Word10
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
      where Hint=@ItemFeature3 and SearchType='Item Feature'
     end
    end
  else
   delete WebSearchSuggestions where Hint=@ItemFeature3 and SearchType='Item Feature'
 end

if @ItemFeature4 <>'---'
 begin
  set @QtyCD=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@ItemFeature4
   and Inventory.Format='CD'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyVinyl=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@ItemFeature4
   and (Inventory.Format='LP' or Inventory.Format='12"' or Inventory.Format='10"' or Inventory.Format='7"')
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyOther=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@ItemFeature4
   and Inventory.Format<>'CD' and Inventory.Format<>'LP' and Inventory.Format<>'12"' and Inventory.Format<>'10"' and Inventory.Format<>'7"'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  if @QtyCD+@QtyVinyl+@QtyOther>0
   begin
    if not exists(select counter from WebSearchSuggestions where Hint=@ItemFeature4 and SearchType='Item Feature')
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
      (@ItemFeature4
      ,@ItemFeature4Word1
      ,@ItemFeature4Word2
      ,@ItemFeature4Word3
      ,@ItemFeature4Word4
      ,@ItemFeature4Word5
      ,@ItemFeature4Word6
      ,@ItemFeature4Word7
      ,@ItemFeature4Word8
      ,@ItemFeature4Word9
      ,@ItemFeature4Word10
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
      where Hint=@ItemFeature4 and SearchType='Item Feature'
     end
    end
  else
   delete WebSearchSuggestions where Hint=@ItemFeature4 and SearchType='Item Feature'
 end

if @ItemFeature5 <>'---'
 begin
  set @QtyCD=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@ItemFeature5
   and Inventory.Format='CD'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyVinyl=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@ItemFeature5
   and (Inventory.Format='LP' or Inventory.Format='12"' or Inventory.Format='10"' or Inventory.Format='7"')
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyOther=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@ItemFeature5
   and Inventory.Format<>'CD' and Inventory.Format<>'LP' and Inventory.Format<>'12"' and Inventory.Format<>'10"' and Inventory.Format<>'7"'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  if @QtyCD+@QtyVinyl+@QtyOther>0
   begin
    if not exists(select counter from WebSearchSuggestions where Hint=@ItemFeature5 and SearchType='Item Feature')
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
      (@ItemFeature5
      ,@ItemFeature5Word1
      ,@ItemFeature5Word2
      ,@ItemFeature5Word3
      ,@ItemFeature5Word4
      ,@ItemFeature5Word5
      ,@ItemFeature5Word6
      ,@ItemFeature5Word7
      ,@ItemFeature5Word8
      ,@ItemFeature5Word9
      ,@ItemFeature5Word10
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
      where Hint=@ItemFeature5 and SearchType='Item Feature'
     end
    end
  else
   delete WebSearchSuggestions where Hint=@ItemFeature5 and SearchType='Item Feature'
 end

if @ItemFeature6 <>'---'
 begin
  set @QtyCD=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@ItemFeature6
   and Inventory.Format='CD'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyVinyl=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@ItemFeature6
   and (Inventory.Format='LP' or Inventory.Format='12"' or Inventory.Format='10"' or Inventory.Format='7"')
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyOther=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@ItemFeature6
   and Inventory.Format<>'CD' and Inventory.Format<>'LP' and Inventory.Format<>'12"' and Inventory.Format<>'10"' and Inventory.Format<>'7"'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  if @QtyCD+@QtyVinyl+@QtyOther>0
   begin
    if not exists(select counter from WebSearchSuggestions where Hint=@ItemFeature6 and SearchType='Item Feature')
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
      (@ItemFeature6
      ,@ItemFeature6Word1
      ,@ItemFeature6Word2
      ,@ItemFeature6Word3
      ,@ItemFeature6Word4
      ,@ItemFeature6Word5
      ,@ItemFeature6Word6
      ,@ItemFeature6Word7
      ,@ItemFeature6Word8
      ,@ItemFeature6Word9
      ,@ItemFeature6Word10
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
      where Hint=@ItemFeature6 and SearchType='Item Feature'
     end
    end
  else
   delete WebSearchSuggestions where Hint=@ItemFeature6 and SearchType='Item Feature'
 end

if @ItemFeature7 <>'---'
 begin
  set @QtyCD=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@ItemFeature7
   and Inventory.Format='CD'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyVinyl=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@ItemFeature7
   and (Inventory.Format='LP' or Inventory.Format='12"' or Inventory.Format='10"' or Inventory.Format='7"')
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyOther=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@ItemFeature7
   and Inventory.Format<>'CD' and Inventory.Format<>'LP' and Inventory.Format<>'12"' and Inventory.Format<>'10"' and Inventory.Format<>'7"'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  if @QtyCD+@QtyVinyl+@QtyOther>0
   begin
    if not exists(select counter from WebSearchSuggestions where Hint=@ItemFeature7 and SearchType='Item Feature')
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
      (@ItemFeature7
      ,@ItemFeature7Word1
      ,@ItemFeature7Word2
      ,@ItemFeature7Word3
      ,@ItemFeature7Word4
      ,@ItemFeature7Word5
      ,@ItemFeature7Word6
      ,@ItemFeature7Word7
      ,@ItemFeature7Word8
      ,@ItemFeature7Word9
      ,@ItemFeature7Word10
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
      where Hint=@ItemFeature7 and SearchType='Item Feature'
     end
    end
  else
   delete WebSearchSuggestions where Hint=@ItemFeature7 and SearchType='Item Feature'
 end

if @ItemFeature8 <>'---'
 begin
  set @QtyCD=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@ItemFeature8
   and Inventory.Format='CD'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyVinyl=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@ItemFeature8
   and (Inventory.Format='LP' or Inventory.Format='12"' or Inventory.Format='10"' or Inventory.Format='7"')
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyOther=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@ItemFeature8
   and Inventory.Format<>'CD' and Inventory.Format<>'LP' and Inventory.Format<>'12"' and Inventory.Format<>'10"' and Inventory.Format<>'7"'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  if @QtyCD+@QtyVinyl+@QtyOther>0
   begin
    if not exists(select counter from WebSearchSuggestions where Hint=@ItemFeature8 and SearchType='Item Feature')
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
      (@ItemFeature8
      ,@ItemFeature8Word1
      ,@ItemFeature8Word2
      ,@ItemFeature8Word3
      ,@ItemFeature8Word4
      ,@ItemFeature8Word5
      ,@ItemFeature8Word6
      ,@ItemFeature8Word7
      ,@ItemFeature8Word8
      ,@ItemFeature8Word9
      ,@ItemFeature8Word10
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
      where Hint=@ItemFeature8 and SearchType='Item Feature'
     end
    end
  else
   delete WebSearchSuggestions where Hint=@ItemFeature8 and SearchType='Item Feature'
 end

if @ItemFeature9 <>'---'
 begin
  set @QtyCD=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@ItemFeature9
   and Inventory.Format='CD'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyVinyl=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@ItemFeature9
   and (Inventory.Format='LP' or Inventory.Format='12"' or Inventory.Format='10"' or Inventory.Format='7"')
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyOther=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@ItemFeature9
   and Inventory.Format<>'CD' and Inventory.Format<>'LP' and Inventory.Format<>'12"' and Inventory.Format<>'10"' and Inventory.Format<>'7"'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  if @QtyCD+@QtyVinyl+@QtyOther>0
   begin
    if not exists(select counter from WebSearchSuggestions where Hint=@ItemFeature9 and SearchType='Item Feature')
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
      (@ItemFeature9
      ,@ItemFeature9Word1
      ,@ItemFeature9Word2
      ,@ItemFeature9Word3
      ,@ItemFeature9Word4
      ,@ItemFeature9Word5
      ,@ItemFeature9Word6
      ,@ItemFeature9Word7
      ,@ItemFeature9Word8
      ,@ItemFeature9Word9
      ,@ItemFeature9Word10
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
      where Hint=@ItemFeature9 and SearchType='Item Feature'
     end
    end
  else
   delete WebSearchSuggestions where Hint=@ItemFeature9 and SearchType='Item Feature'
 end

if @ItemFeature10 <>'---'
 begin
  set @QtyCD=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@ItemFeature10
   and Inventory.Format='CD'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyVinyl=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@ItemFeature10
   and (Inventory.Format='LP' or Inventory.Format='12"' or Inventory.Format='10"' or Inventory.Format='7"')
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyOther=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@ItemFeature10
   and Inventory.Format<>'CD' and Inventory.Format<>'LP' and Inventory.Format<>'12"' and Inventory.Format<>'10"' and Inventory.Format<>'7"'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  if @QtyCD+@QtyVinyl+@QtyOther>0
   begin
    if not exists(select counter from WebSearchSuggestions where Hint=@ItemFeature10 and SearchType='Item Feature')
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
      (@ItemFeature10
      ,@ItemFeature10Word1
      ,@ItemFeature10Word2
      ,@ItemFeature10Word3
      ,@ItemFeature10Word4
      ,@ItemFeature10Word5
      ,@ItemFeature10Word6
      ,@ItemFeature10Word7
      ,@ItemFeature10Word8
      ,@ItemFeature10Word9
      ,@ItemFeature10Word10
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
      where Hint=@ItemFeature10 and SearchType='Item Feature'
     end
    end
  else
   delete WebSearchSuggestions where Hint=@ItemFeature10 and SearchType='Item Feature'
 end

if @ItemFeature11 <>'---'
 begin
  set @QtyCD=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@ItemFeature11
   and Inventory.Format='CD'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyVinyl=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@ItemFeature11
   and (Inventory.Format='LP' or Inventory.Format='12"' or Inventory.Format='10"' or Inventory.Format='7"')
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyOther=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@ItemFeature11
   and Inventory.Format<>'CD' and Inventory.Format<>'LP' and Inventory.Format<>'12"' and Inventory.Format<>'10"' and Inventory.Format<>'7"'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  if @QtyCD+@QtyVinyl+@QtyOther>0
   begin
    if not exists(select counter from WebSearchSuggestions where Hint=@ItemFeature11 and SearchType='Item Feature')
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
      (@ItemFeature11
      ,@ItemFeature11Word1
      ,@ItemFeature11Word2
      ,@ItemFeature11Word3
      ,@ItemFeature11Word4
      ,@ItemFeature11Word5
      ,@ItemFeature11Word6
      ,@ItemFeature11Word7
      ,@ItemFeature11Word8
      ,@ItemFeature11Word9
      ,@ItemFeature11Word10
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
      where Hint=@ItemFeature11 and SearchType='Item Feature'
     end
    end
  else
   delete WebSearchSuggestions where Hint=@ItemFeature11 and SearchType='Item Feature'
 end

if @ItemFeature12 <>'---'
 begin
  set @QtyCD=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@ItemFeature12
   and Inventory.Format='CD'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyVinyl=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@ItemFeature12
   and (Inventory.Format='LP' or Inventory.Format='12"' or Inventory.Format='10"' or Inventory.Format='7"')
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyOther=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@ItemFeature12
   and Inventory.Format<>'CD' and Inventory.Format<>'LP' and Inventory.Format<>'12"' and Inventory.Format<>'10"' and Inventory.Format<>'7"'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  if @QtyCD+@QtyVinyl+@QtyOther>0
   begin
    if not exists(select counter from WebSearchSuggestions where Hint=@ItemFeature12 and SearchType='Item Feature')
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
      (@ItemFeature12
      ,@ItemFeature12Word1
      ,@ItemFeature12Word2
      ,@ItemFeature12Word3
      ,@ItemFeature12Word4
      ,@ItemFeature12Word5
      ,@ItemFeature12Word6
      ,@ItemFeature12Word7
      ,@ItemFeature12Word8
      ,@ItemFeature12Word9
      ,@ItemFeature12Word10
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
      where Hint=@ItemFeature12 and SearchType='Item Feature'
     end
    end
  else
   delete WebSearchSuggestions where Hint=@ItemFeature12 and SearchType='Item Feature'
 end

if @ItemFeature13 <>'---'
 begin
  set @QtyCD=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@ItemFeature13
   and Inventory.Format='CD'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyVinyl=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@ItemFeature13
   and (Inventory.Format='LP' or Inventory.Format='12"' or Inventory.Format='10"' or Inventory.Format='7"')
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyOther=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@ItemFeature13
   and Inventory.Format<>'CD' and Inventory.Format<>'LP' and Inventory.Format<>'12"' and Inventory.Format<>'10"' and Inventory.Format<>'7"'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  if @QtyCD+@QtyVinyl+@QtyOther>0
   begin
    if not exists(select counter from WebSearchSuggestions where Hint=@ItemFeature13 and SearchType='Item Feature')
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
      (@ItemFeature13
      ,@ItemFeature13Word1
      ,@ItemFeature13Word2
      ,@ItemFeature13Word3
      ,@ItemFeature13Word4
      ,@ItemFeature13Word5
      ,@ItemFeature13Word6
      ,@ItemFeature13Word7
      ,@ItemFeature13Word8
      ,@ItemFeature13Word9
      ,@ItemFeature13Word10
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
      where Hint=@ItemFeature13 and SearchType='Item Feature'
     end
    end
  else
   delete WebSearchSuggestions where Hint=@ItemFeature13 and SearchType='Item Feature'
 end

if @ItemFeature14 <>'---'
 begin
  set @QtyCD=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@ItemFeature14
   and Inventory.Format='CD'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyVinyl=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@ItemFeature14
   and (Inventory.Format='LP' or Inventory.Format='12"' or Inventory.Format='10"' or Inventory.Format='7"')
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyOther=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@ItemFeature14
   and Inventory.Format<>'CD' and Inventory.Format<>'LP' and Inventory.Format<>'12"' and Inventory.Format<>'10"' and Inventory.Format<>'7"'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  if @QtyCD+@QtyVinyl+@QtyOther>0
   begin
    if not exists(select counter from WebSearchSuggestions where Hint=@ItemFeature14 and SearchType='Item Feature')
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
      (@ItemFeature14
      ,@ItemFeature14Word1
      ,@ItemFeature14Word2
      ,@ItemFeature14Word3
      ,@ItemFeature14Word4
      ,@ItemFeature14Word5
      ,@ItemFeature14Word6
      ,@ItemFeature14Word7
      ,@ItemFeature14Word8
      ,@ItemFeature14Word9
      ,@ItemFeature14Word10
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
      where Hint=@ItemFeature14 and SearchType='Item Feature'
     end
    end
  else
   delete WebSearchSuggestions where Hint=@ItemFeature14 and SearchType='Item Feature'
 end

if @ItemFeature15 <>'---'
 begin
  set @QtyCD=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@ItemFeature15
   and Inventory.Format='CD'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyVinyl=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@ItemFeature15
   and (Inventory.Format='LP' or Inventory.Format='12"' or Inventory.Format='10"' or Inventory.Format='7"')
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyOther=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@ItemFeature15
   and Inventory.Format<>'CD' and Inventory.Format<>'LP' and Inventory.Format<>'12"' and Inventory.Format<>'10"' and Inventory.Format<>'7"'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  if @QtyCD+@QtyVinyl+@QtyOther>0
   begin
    if not exists(select counter from WebSearchSuggestions where Hint=@ItemFeature15 and SearchType='Item Feature')
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
      (@ItemFeature15
      ,@ItemFeature15Word1
      ,@ItemFeature15Word2
      ,@ItemFeature15Word3
      ,@ItemFeature15Word4
      ,@ItemFeature15Word5
      ,@ItemFeature15Word6
      ,@ItemFeature15Word7
      ,@ItemFeature15Word8
      ,@ItemFeature15Word9
      ,@ItemFeature15Word10
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
      where Hint=@ItemFeature15 and SearchType='Item Feature'
     end
    end
  else
   delete WebSearchSuggestions where Hint=@ItemFeature15 and SearchType='Item Feature'
 end
