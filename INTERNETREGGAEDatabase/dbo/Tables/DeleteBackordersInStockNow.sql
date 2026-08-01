CREATE TABLE [dbo].[DeleteBackordersInStockNow] (
    [CustomerID]                 INT          NULL,
    [DeleteBackorderInventoryID] INT          NULL,
    [DownloadGroup]              INT          NULL,
    [counter]                    INT          IDENTITY (1, 1) NOT NULL,
    [AddedToCart]                NVARCHAR (1) NULL,
    [DateTime]                   DATETIME     CONSTRAINT [DF_DeleteBackordersInStockNow_DateTime] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_DeleteBackordersInStockNow] PRIMARY KEY CLUSTERED ([counter] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_DeleteBackordersInStockNow]
    ON [dbo].[DeleteBackordersInStockNow]([CustomerID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_DeleteBackordersInStockNow_1]
    ON [dbo].[DeleteBackordersInStockNow]([DeleteBackorderInventoryID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_DeleteBackordersInStockNow_2]
    ON [dbo].[DeleteBackordersInStockNow]([DownloadGroup] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_DeleteBackordersInStockNow_3]
    ON [dbo].[DeleteBackordersInStockNow]([DateTime] ASC);

