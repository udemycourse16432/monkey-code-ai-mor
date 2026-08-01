CREATE TABLE [dbo].[Item-Features-Uploaded] (
    [ID]                     INT          NOT NULL,
    [InventoryItemFeatureID] INT          NOT NULL,
    [ItemID]                 INT          NOT NULL,
    [InSync]                 NVARCHAR (1) NOT NULL,
    [MORCounter]             INT          NULL
);

