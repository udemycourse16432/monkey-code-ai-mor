CREATE TABLE [dbo].[InventoryItemFeatures] (
    [ID]                     INT NOT NULL,
    [InventoryItemFeatureID] INT NOT NULL,
    [ItemID]                 INT NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_ItemID]
    ON [dbo].[InventoryItemFeatures]([ItemID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_InventoryItemFeatureID_ItemID]
    ON [dbo].[InventoryItemFeatures]([InventoryItemFeatureID] ASC)
    INCLUDE([ItemID]);


GO
CREATE TRIGGER [dbo].[InventoryItemFeatures_DeleteTrigger] ON [dbo].[InventoryItemFeatures] for DELETE AS

insert into WebSearchSuggestionsToFigure (
  InventoryID,
  InventoryItemFeatureID,
  DataChangeType,
  TableThatChanged
)

select
  ItemID,
  InventoryItemFeatureID,
  'delete',
  'InventoryItemFeatures'
from deleted

GO
CREATE TRIGGER [dbo].[InventoryItemFeatures_InsertTrigger] ON [dbo].[InventoryItemFeatures] for INSERT AS

insert into WebSearchSuggestionsToFigure (
  InventoryID,
  InventoryItemFeatureID,
  DataChangeType,
  TableThatChanged
)

select
  ItemID,
  InventoryItemFeatureID,
  'insert',
  'InventoryItemFeatures'
from inserted

GO
CREATE TRIGGER [dbo].[InventoryItemFeatures_UpdateTrigger] ON [dbo].[InventoryItemFeatures] for UPDATE AS

insert into WebSearchSuggestionsToFigure (
  InventoryID,
  InventoryItemFeatureID,
  DataChangeType,
  TableThatChanged
)

select
  ItemID,
  InventoryItemFeatureID,
  'update',
  'InventoryItemFeatures'
from inserted
