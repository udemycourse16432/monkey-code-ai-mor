CREATE TABLE [dbo].[KirbyItemsStockHistory] (
    [counter]   INT      IDENTITY (1, 1) NOT NULL,
    [ItemID]    INT      NOT NULL,
    [Inventory] INT      NOT NULL,
    [DateTime]  DATETIME CONSTRAINT [DF_KirbyItemsStockHistory_DateTime] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_KirbyItemsStockHistory] PRIMARY KEY CLUSTERED ([counter] ASC)
);

