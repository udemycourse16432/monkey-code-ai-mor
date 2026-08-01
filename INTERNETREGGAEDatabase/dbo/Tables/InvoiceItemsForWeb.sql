CREATE TABLE [dbo].[InvoiceItemsForWeb] (
    [Inv]                      INT            NULL,
    [Catalog]                  NVARCHAR (20)  NULL,
    [ItemID]                   INT            NULL,
    [Format]                   NVARCHAR (5)   NULL,
    [UnitPrice]                NUMERIC (9, 2) NULL,
    [Quantity]                 INT            NULL,
    [Description]              NVARCHAR (350) NULL,
    [Label]                    NVARCHAR (60)  NULL,
    [InvoiceItemsTablecounter] INT            NULL,
    [WallCatalogNumber]        INT            NULL,
    [WallCatalogLetter]        NVARCHAR (4)   NULL,
    [UnitCost]                 SMALLMONEY     NULL,
    [ConsignmentSupplierID]    INT            NULL,
    [IsItConsignment]          NVARCHAR (1)   NULL,
    [ConsignmentPrice]         NUMERIC (5, 2) NULL,
    [SupplierID]               INT            NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_Inv]
    ON [dbo].[InvoiceItemsForWeb]([Inv] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_InvoiceItemsTableCounter]
    ON [dbo].[InvoiceItemsForWeb]([InvoiceItemsTablecounter] ASC) WITH (ALLOW_PAGE_LOCKS = OFF);

