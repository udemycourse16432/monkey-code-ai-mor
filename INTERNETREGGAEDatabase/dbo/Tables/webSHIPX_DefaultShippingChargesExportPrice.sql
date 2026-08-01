CREATE TABLE [dbo].[webSHIPX_DefaultShippingChargesExportPrice] (
    [ShippingMethod]                  NVARCHAR (50) NULL,
    [AmountPerPoundSurcharge]         MONEY         NULL,
    [PercentOfPurchaseValueSurcharge] FLOAT (53)    NULL,
    [FlatAmountSurcharge]             MONEY         NULL,
    [ShippingCostSurcharge]           FLOAT (53)    NULL,
    [counter]                         INT           NOT NULL
);

