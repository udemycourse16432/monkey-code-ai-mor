CREATE TABLE [dbo].[InventoryMissingImages] (
    [ItemID]     INT          NOT NULL,
    [ItemSuffix] NVARCHAR (1) NOT NULL,
    [Size595]    NVARCHAR (1) NOT NULL,
    [Size320]    NVARCHAR (1) NOT NULL,
    [Size180]    NVARCHAR (1) NOT NULL,
    [Size54]     NVARCHAR (1) NOT NULL,
    [counter]    INT          IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_InventoryMissingImages] PRIMARY KEY CLUSTERED ([counter] ASC)
);

