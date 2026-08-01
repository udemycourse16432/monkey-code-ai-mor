CREATE TABLE [dbo].[Inventory] (
    [ID]                            INT            NOT NULL,
    [ArtistTitle]                   NVARCHAR (350) NOT NULL,
    [Label]                         NVARCHAR (120) NOT NULL,
    [RetailPrice]                   SMALLMONEY     NOT NULL,
    [Inventory]                     INT            NOT NULL,
    [Format]                        NVARCHAR (7)   NOT NULL,
    [InStockDate]                   DATETIME       NOT NULL,
    [RhythmName]                    NVARCHAR (400) NULL,
    [YearFrom]                      NVARCHAR (30)  NULL,
    [YearTo]                        NVARCHAR (30)  NULL,
    [StorePrice]                    SMALLMONEY     NOT NULL,
    [BackInStockDate]               DATETIME       NOT NULL,
    [ProduceGroup]                  NVARCHAR (MAX) NULL,
    [MusicianGroup]                 NVARCHAR (MAX) NULL,
    [TracksGroup]                   NVARCHAR (MAX) NULL,
    [Catalog]                       NVARCHAR (50)  NULL,
    [SalesLast30Days]               INT            NULL,
    [FormatOrder]                   INT            NOT NULL,
    [ExportPrice]                   SMALLMONEY     NULL,
    [WebEssential]                  NVARCHAR (1)   NULL,
    [WebReviewHTML]                 NVARCHAR (MAX) NULL,
    [Cutout]                        NVARCHAR (1)   NULL,
    [WeightInGrams]                 DECIMAL (18)   NOT NULL,
    [NumberOfTracks]                INT            NULL,
    [Deleted]                       NVARCHAR (1)   NULL,
    [Cost]                          SMALLMONEY     NOT NULL,
    [MP3FileCompleted]              NVARCHAR (1)   NULL,
    [UsedItem]                      NVARCHAR (1)   NULL,
    [ConditionJacket]               NVARCHAR (3)   NULL,
    [ConditionVinylOrCD]            NVARCHAR (3)   NULL,
    [MP3SoundGroup]                 INT            NULL,
    [DateAdded]                     DATETIME       NULL,
    [Genre1]                        NVARCHAR (30)  NULL,
    [Genre2]                        NVARCHAR (30)  NULL,
    [Genre3]                        NVARCHAR (30)  NULL,
    [Genre4]                        NVARCHAR (30)  NULL,
    [Genre5]                        NVARCHAR (30)  NULL,
    [Genre6]                        NVARCHAR (30)  NULL,
    [Genre7]                        NVARCHAR (30)  NULL,
    [Genre8]                        NVARCHAR (30)  NULL,
    [Genre9]                        NVARCHAR (30)  NULL,
    [UPC]                           NVARCHAR (50)  NULL,
    [ItemDetailsWeb]                NVARCHAR (100) NULL,
    [ItemDetailsWebProductDetails]  NVARCHAR (255) NULL,
    [Sale_RetailPrice]              NUMERIC (5, 2) NULL,
    [Sale_RetailEndDate]            DATETIME       NULL,
    [Sale_RetailFootnoteText]       NVARCHAR (255) NULL,
    [Sale_RetailItemDetailsText]    NVARCHAR (255) NULL,
    [Sale_WholesalePrice]           NUMERIC (5, 2) NULL,
    [Sale_WholesaleEndDate]         DATETIME       NULL,
    [Sale_WholesaleFootnoteText]    NVARCHAR (255) NULL,
    [Sale_WholesaleItemDetailsText] NVARCHAR (255) NULL,
    [ItemFootnoteText]              NVARCHAR (255) NULL,
    [SupplierID]                    INT            NOT NULL,
    [StreetDate]                    DATETIME       NULL,
    [ShowOnWebsite]                 NVARCHAR (1)   NULL,
    [ConditionNotes]                NVARCHAR (MAX) NULL,
    [ConditionText]                 NVARCHAR (MAX) NULL,
    [ItemFeatures1]                 NVARCHAR (MAX) NULL,
    [ItemFeatures2]                 NVARCHAR (MAX) NULL,
    [ItemFeatures3]                 NVARCHAR (MAX) NULL,
    [ItemFeatures4]                 NVARCHAR (MAX) NULL,
    [ItemFeatures5]                 NVARCHAR (MAX) NULL,
    [ItemFeatures6]                 NVARCHAR (MAX) NULL,
    [ItemFeatures7]                 NVARCHAR (MAX) NULL,
    [ItemFeatures8]                 NVARCHAR (MAX) NULL,
    [ItemFeatures9]                 NVARCHAR (MAX) NULL,
    [ItemFeatures10]                NVARCHAR (MAX) NULL,
    [KirbysCut]                     NUMERIC (6, 2) NOT NULL,
    [KirbyItem]                     NVARCHAR (1)   NOT NULL,
    [KirbyCost]                     NUMERIC (6, 2) NOT NULL,
    CONSTRAINT [CK_Inventory_KirbyCost] CHECK ([KirbyItem]='y' AND [KirbyCost]>(0) OR [KirbyItem]='n' AND [KirbyCost]>=(0)),
    CONSTRAINT [CK_KirbyItem] CHECK ([KirbyItem]='y' OR [KirbyItem]='n')
);


GO
CREATE NONCLUSTERED INDEX [ix_InStockDate]
    ON [dbo].[Inventory]([InStockDate] ASC) WITH (ALLOW_PAGE_LOCKS = OFF);


GO
CREATE NONCLUSTERED INDEX [ix_BackInStockDate]
    ON [dbo].[Inventory]([BackInStockDate] ASC) WITH (ALLOW_PAGE_LOCKS = OFF);


GO
CREATE NONCLUSTERED INDEX [ix_SalesLast30Days]
    ON [dbo].[Inventory]([SalesLast30Days] ASC);


GO
CREATE NONCLUSTERED INDEX [ix_FormatOrder]
    ON [dbo].[Inventory]([FormatOrder] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_ID]
    ON [dbo].[Inventory]([ID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ArtistTitle]
    ON [dbo].[Inventory]([ArtistTitle] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Genre1]
    ON [dbo].[Inventory]([Genre1] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Genre2]
    ON [dbo].[Inventory]([Genre2] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Genre3]
    ON [dbo].[Inventory]([Genre3] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Genre4]
    ON [dbo].[Inventory]([Genre4] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Genre5]
    ON [dbo].[Inventory]([Genre5] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Genre6]
    ON [dbo].[Inventory]([Genre6] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Genre7]
    ON [dbo].[Inventory]([Genre7] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Genre8]
    ON [dbo].[Inventory]([Genre8] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Genre9]
    ON [dbo].[Inventory]([Genre9] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_RhythmName]
    ON [dbo].[Inventory]([RhythmName] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_YearFrom]
    ON [dbo].[Inventory]([YearFrom] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_YearTo]
    ON [dbo].[Inventory]([YearTo] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Inventory]
    ON [dbo].[Inventory]([Inventory] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_OPT1]
    ON [dbo].[Inventory]([Format] ASC, [UsedItem] ASC, [ShowOnWebsite] ASC, [ID] ASC, [Inventory] ASC)
    INCLUDE([ArtistTitle], [SalesLast30Days]);


GO
CREATE NONCLUSTERED INDEX [IX_OPT2]
    ON [dbo].[Inventory]([Format] ASC, [UsedItem] ASC, [ShowOnWebsite] ASC, [ID] ASC, [Inventory] ASC)
    INCLUDE([RhythmName], [YearFrom], [YearTo], [SalesLast30Days], [Genre1], [Genre2], [Genre3], [Genre4], [Genre5], [Genre6], [Genre7], [Genre8], [Genre9]);


GO
CREATE TRIGGER [dbo].[Inventory_InsertTrigger] ON [dbo].[Inventory] for INSERT AS

insert into WebSearchSuggestionsToFigure (
  InventoryID,
  DataChangeType,
  TableThatChanged,
  ArtistTitle,
  [Label],
  Rhythm,
  [Format],
  Genre1,
  Genre2,
  Genre3,
  Genre4,
  Genre5,
  Genre6,
  Genre7,
  Genre8,
  Genre9
)

select
  ID,
  'insert',
  'Inventory',
  ArtistTitle,
  [Label],
  RhythmName,
  [Format],
  Genre1,
  Genre2,
  Genre3,
  Genre4,
  Genre5,
  Genre6,
  Genre7,
  Genre8,
  Genre9
from inserted

GO
CREATE TRIGGER [dbo].[Inventory_DeleteTrigger] ON [dbo].[Inventory] for DELETE AS

insert into WebSearchSuggestionsToFigure (
  InventoryID,
  DataChangeType,
  TableThatChanged,
  ArtistTitle,
  [Label],
  Rhythm,
  [Format],
  Genre1,
  Genre2,
  Genre3,
  Genre4,
  Genre5,
  Genre6,
  Genre7,
  Genre8,
  Genre9
)

select
  ID,
  'delete',
  'Inventory',
  ArtistTitle,
  [Label],
  RhythmName,
  [Format],
  Genre1,
  Genre2,
  Genre3,
  Genre4,
  Genre5,
  Genre6,
  Genre7,
  Genre8,
  Genre9
from deleted

GO
CREATE TRIGGER [dbo].[Inventory_UpdateTrigger] ON [dbo].[Inventory] for UPDATE AS

insert into WebSearchSuggestionsToFigure (
  InventoryID,
  DataChangeType,
  TableThatChanged,
  ArtistTitle,
  [Label],
  Rhythm,
  [Format],
  Genre1,
  Genre2,
  Genre3,
  Genre4,
  Genre5,
  Genre6,
  Genre7,
  Genre8,
  Genre9
)

select
  ID,
  'update',
  'Inventory',
  ArtistTitle,
  [Label],
  RhythmName,
  [Format],
  Genre1,
  Genre2,
  Genre3,
  Genre4,
  Genre5,
  Genre6,
  Genre7,
  Genre8,
  Genre9
from inserted
