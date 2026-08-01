CREATE TABLE [dbo].[KirbyItemsPurchasedLineItems] (
    [counter]                    INT            IDENTITY (1, 1) NOT NULL,
    [ItemID]                     INT            NOT NULL,
    [Quantity]                   INT            NOT NULL,
    [SupplierPrice]              NUMERIC (6, 2) NOT NULL,
    [Shipping]                   NUMERIC (6, 2) NOT NULL,
    [KirbyCost]                  NUMERIC (6, 2) NOT NULL,
    [SupplierID]                 INT            NOT NULL,
    [DateTime]                   DATETIME       NOT NULL,
    [KirbyItemsPurchasesCounter] INT            NOT NULL,
    CONSTRAINT [PK_KirbyItemsPurchased] PRIMARY KEY CLUSTERED ([counter] ASC)
);

