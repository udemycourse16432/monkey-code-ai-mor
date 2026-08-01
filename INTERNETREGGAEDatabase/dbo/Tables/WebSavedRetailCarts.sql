CREATE TABLE [dbo].[WebSavedRetailCarts] (
    [InventoryID]                INT            NULL,
    [DateTime]                   DATETIME       NULL,
    [Price]                      SMALLMONEY     NULL,
    [Quantity]                   INT            NULL,
    [Email]                      NVARCHAR (100) NULL,
    [CartPassword]               NVARCHAR (50)  NULL,
    [counter]                    INT            IDENTITY (1, 1) NOT NULL,
    [DatePurchased]              DATETIME       NULL,
    [IPAddress]                  NVARCHAR (20)  NULL,
    [SearchCriteriaStatisticsID] NVARCHAR (50)  NULL
);


GO
CREATE CLUSTERED INDEX [IX_WebSavedRetailCarts_2]
    ON [dbo].[WebSavedRetailCarts]([Email] ASC, [CartPassword] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_WebSavedRetailCarts]
    ON [dbo].[WebSavedRetailCarts]([Email] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_WebSavedRetailCarts_1]
    ON [dbo].[WebSavedRetailCarts]([CartPassword] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_WebSavedRetailCarts_3]
    ON [dbo].[WebSavedRetailCarts]([DatePurchased] ASC);

