CREATE PROCEDURE [dbo].[spFigureWebSearchSuggestionsITEMFEATURESupdStats]
  @InventoryItemFeatureID int
AS

declare @hint nvarchar(255)
set @hint=(select Hint from InventoryItemFeatureIndex where InventoryItemFeatureID=@InventoryItemFeatureID)

declare @QtyCD int
declare @QtyVinyl int
declare @QtyOther int

  set @QtyCD=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@hint
   and Inventory.Format='CD'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyVinyl=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@hint
   and (Inventory.Format='LP' or Inventory.Format='12"' or Inventory.Format='10"' or Inventory.Format='7"')
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')
  set @QtyOther=(select count(Inventory.ID) from Inventory
   inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID
   inner join dbo.InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
   where InventoryItemFeatureIndex.Hint=@hint
   and Inventory.Format<>'CD' and Inventory.Format<>'LP' and Inventory.Format<>'12"' and Inventory.Format<>'10"' and Inventory.Format<>'7"'
   and Inventory.Inventory>0 and ShowOnWebsite='y' and Deleted='n')

if @QtyCD+@QtyVinyl+@QtyOther>0 begin
  update WebSearchSuggestions set
    Total=@QtyCD+@QtyVinyl+@QtyOther,
    CD=@QtyCD,
    Vinyl=@QtyVinyl,
    Other=@QtyOther
    where Hint=@hint and SearchType='Item Feature'
end else
  delete WebSearchSuggestions where Hint=@hint and SearchType='Item Feature'
