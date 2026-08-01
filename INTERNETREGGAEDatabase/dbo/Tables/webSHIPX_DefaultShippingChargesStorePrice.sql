CREATE TABLE [dbo].[webSHIPX_DefaultShippingChargesStorePrice] (
    [ShippingMethod]                  NVARCHAR (50) NULL,
    [AmountPerPoundSurcharge]         MONEY         NULL,
    [PercentOfPurchaseValueSurcharge] FLOAT (53)    NULL,
    [FlatAmountSurcharge]             MONEY         NULL,
    [ShippingCostSurcharge]           FLOAT (53)    NULL,
    [counter]                         INT           NOT NULL,
    CONSTRAINT [PK_webSHIPX_DefaultShippingChargesStorePrice] PRIMARY KEY CLUSTERED ([counter] ASC)
);

