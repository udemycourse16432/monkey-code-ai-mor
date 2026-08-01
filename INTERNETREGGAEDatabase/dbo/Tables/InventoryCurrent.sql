CREATE TABLE [dbo].[InventoryCurrent] (
    [UPC]             NVARCHAR (50)  NULL,
    [ArtistTitle]     NVARCHAR (250) NOT NULL,
    [Inventory]       INT            NOT NULL,
    [Millions_ItemID] INT            NOT NULL,
    [Format]          NVARCHAR (20)  NULL,
    [counter]         INT            IDENTITY (1, 1) NOT NULL,
    [SupplierID]      INT            NULL,
    [RetailPrice]     SMALLMONEY     NULL
);

