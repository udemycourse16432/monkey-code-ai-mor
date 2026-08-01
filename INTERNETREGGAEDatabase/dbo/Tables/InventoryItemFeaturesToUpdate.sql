CREATE TABLE [dbo].[InventoryItemFeaturesToUpdate] (
    [InventoryID] INT NOT NULL,
    [counter]     INT IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_InventoryItemDetailsToUpdate] PRIMARY KEY CLUSTERED ([counter] ASC)
);

