CREATE TABLE [dbo].[HoldPileItemsForWeb] (
    [InventoryID]      INT           NULL,
    [Quantity]         INT           NULL,
    [HoldPrice]        MONEY         NULL,
    [OverflowQuantity] INT           NULL,
    [HoldPileNumber]   NVARCHAR (20) NULL,
    [DownloadGroup]    INT           NULL,
    [ItemStatus]       NVARCHAR (20) CONSTRAINT [DF_HoldPileItems_ItemStatus] DEFAULT ('Ordered') NULL,
    [CustID]           NVARCHAR (30) NULL,
    [TagCodeSuffix]    INT           NULL,
    [counter]          INT           IDENTITY (1, 1) NOT NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_HoldpileNumber_InventoryID]
    ON [dbo].[HoldPileItemsForWeb]([InventoryID] ASC, [HoldPileNumber] ASC);

