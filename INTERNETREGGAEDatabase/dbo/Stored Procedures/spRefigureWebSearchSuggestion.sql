







-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spRefigureWebSearchSuggestion] 

@Hint nvarchar(255)

AS

declare @QtyCD int
declare @QtyVinyl int
declare @QtyOther int

  set @QtyCD=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@Hint
   and Inventory.Format='CD'
   and Inventory.Inventory>0)
  set @QtyVinyl=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@Hint
   and (Inventory.Format='LP' or Inventory.Format='12"' or Inventory.Format='10"' or Inventory.Format='7"')
   and Inventory.Inventory>0)
  set @QtyOther=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@Hint
   and Inventory.Format<>'CD' and Inventory.Format<>'LP' and Inventory.Format<>'12"' and Inventory.Format<>'10"' and Inventory.Format<>'7"'
   and Inventory.Inventory>0)
  if @QtyCD+@QtyVinyl+@QtyOther>0
   begin
    if not exists(select counter from WebSearchSuggestions where Hint=@Hint and SearchType='Item Feature')
     begin
      insert into WebSearchSuggestions
      (Hint
      ,Total
      ,CD
      ,Vinyl
      ,Other
      ,SearchType)
      values
      (@Hint
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
      where Hint=@Hint and SearchType='Item Feature'
     end
    end
  else
   delete WebSearchSuggestions where Hint=@Hint and SearchType='Item Feature'








