CREATE TABLE [dbo].[OrderItems] (
    [OrderNumber]                NVARCHAR (15)  NULL,
    [InventoryID]                INT            NULL,
    [Price]                      SMALLMONEY     NULL,
    [Quantity]                   INT            NULL,
    [Inventory]                  INT            NULL,
    [SearchCriteriaStatisticsID] NVARCHAR (50)  NULL,
    [Label]                      NVARCHAR (200) NULL,
    [Format]                     NVARCHAR (10)  NULL,
    [Catalog]                    NVARCHAR (30)  NULL,
    [counter]                    INT            IDENTITY (1, 1) NOT NULL,
    [Description]                NVARCHAR (350) NULL,
    [DownloadGroup]              INT            NULL,
    [OrderItemsDateTime]         SMALLDATETIME  CONSTRAINT [DF_OrderItems_DateTime] DEFAULT (getdate()) NULL,
    [KirbysCut]                  NUMERIC (6, 2) NULL,
    [KirbyItem]                  NVARCHAR (1)   NULL,
    [SupplierID]                 INT            NULL,
    [Cost]                       SMALLMONEY     NULL,
    [KirbyCost]                  NUMERIC (6, 2) NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_OrderItems]
    ON [dbo].[OrderItems]([OrderNumber] ASC);

