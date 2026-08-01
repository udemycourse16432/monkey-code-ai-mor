CREATE TABLE [dbo].[SoldItems] (
    [ID]           INT            NOT NULL,
    [InvoiceDate]  DATETIME       NOT NULL,
    [ItemID]       INT            NOT NULL,
    [Quantity]     SMALLINT       NOT NULL,
    [SalesChannel] NVARCHAR (15)  NOT NULL,
    [KirbyItem]    NVARCHAR (1)   NOT NULL,
    [KirbysCut]    NUMERIC (6, 2) NOT NULL,
    [SupplierID]   INT            NOT NULL,
    [Cost]         SMALLMONEY     NOT NULL,
    [FalseSale]    SMALLINT       NOT NULL,
    [KirbyCost]    NUMERIC (6, 2) NOT NULL,
    CONSTRAINT [PK_SoldItems] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [CK_SoldItems_KirbyCost] CHECK ([KirbyCost]>=(0)),
    CONSTRAINT [CK_SoldItems_SupplierID] CHECK ([SupplierID]>(0) AND [Kirbyitem]='y' OR [SupplierID]>=(0) AND [KirbyItem]='n')
);

