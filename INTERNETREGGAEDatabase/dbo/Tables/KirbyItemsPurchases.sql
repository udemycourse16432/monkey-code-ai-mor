CREATE TABLE [dbo].[KirbyItemsPurchases] (
    [counter]        INT            IDENTITY (1, 1) NOT NULL,
    [DateTime]       DATETIME       NOT NULL,
    [PurchaseAmount] NUMERIC (7, 2) NULL,
    [PONumber]       NVARCHAR (50)  NULL,
    [CheckNumber]    NVARCHAR (50)  NULL,
    [NumberOfitems]  INT            NULL,
    [CostOfGoods]    NUMERIC (7, 2) NULL,
    [Shipping]       INT            NULL,
    CONSTRAINT [PK_KirbyItemsPurchases] PRIMARY KEY CLUSTERED ([counter] ASC)
);

