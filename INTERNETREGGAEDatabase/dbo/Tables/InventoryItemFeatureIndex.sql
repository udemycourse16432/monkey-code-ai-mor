CREATE TABLE [dbo].[InventoryItemFeatureIndex] (
    [InventoryItemFeatureID]                              INT            NOT NULL,
    [DescriptionForInternalUse]                           NVARCHAR (255) NULL,
    [FormatText]                                          NVARCHAR (25)  NULL,
    [FormatForInternalUse]                                NVARCHAR (10)  NULL,
    [ItemFeatureWebGalleryText]                           NVARCHAR (100) NULL,
    [ItemFeatureWebGalleryTextDisplaySequence]            INT            NULL,
    [ItemFeatureHoverOverText]                            NVARCHAR (255) NULL,
    [ItemFeatureWebProductDetailsPageText]                NVARCHAR (255) NULL,
    [ItemFeatureWebProductDetailsPageTextDisplaySequence] INT            NULL,
    [ItemFeatureWebProductDetailsPageHyperlinkText]       NVARCHAR (MAX) NULL,
    [ItemFeaturesOrderAndInvoicePagesText]                NVARCHAR (255) NULL,
    [ItemFeaturesOrderAndInvoicePagesTextDisplaySequence] INT            NULL,
    [ItemFeatureExcelFileText]                            NVARCHAR (255) NULL,
    [ItemFeatureExcelFileTextDisplaySequence]             INT            NULL,
    [EBrecordsInventoryItemFeatureID]                     INT            NULL,
    [counter]                                             INT            NULL,
    [Hint]                                                NVARCHAR (255) NULL,
    CONSTRAINT [PK_InventoryItemFeatureIndex] PRIMARY KEY CLUSTERED ([InventoryItemFeatureID] ASC)
);


GO
CREATE TRIGGER [dbo].[InventoryItemFeatureIndex_DeleteTrigger] ON [dbo].[InventoryItemFeatureIndex] for DELETE AS

insert into WebSearchSuggestionsToFigure (
  InventoryID,
  InventoryItemFeatureID,
  DataChangeType,
  TableThatChanged,
  Hint
)

select
  0,
  InventoryItemFeatureID,
  'delete',
  'InventoryItemFeatureIndex',
  Hint
from deleted

GO
CREATE TRIGGER [dbo].[InventoryItemFeatureIndex_InsertTrigger] ON [dbo].[InventoryItemFeatureIndex] for INSERT AS

insert into WebSearchSuggestionsToFigure (
  InventoryID,
  InventoryItemFeatureID,
  DataChangeType,
  TableThatChanged,
  Hint
)

select
  0,
  InventoryItemFeatureID,
  'insert',
  'InventoryItemFeatureIndex',
  Hint
from inserted

GO
CREATE TRIGGER [dbo].[InventoryItemFeatureIndex_UpdateTrigger] ON [dbo].[InventoryItemFeatureIndex] for UPDATE AS

insert into WebSearchSuggestionsToFigure (
  InventoryID,
  InventoryItemFeatureID,
  DataChangeType,
  TableThatChanged,
  Hint
)

select
  0,
  InventoryItemFeatureID,
  'update',
  'InventoryItemFeatureIndex',
  Hint
from inserted
