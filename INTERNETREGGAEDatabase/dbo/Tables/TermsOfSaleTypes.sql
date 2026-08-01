CREATE TABLE [dbo].[TermsOfSaleTypes] (
    [Type]                       INT            NULL,
    [counter]                    INT            NOT NULL,
    [TextOnInvoice]              NVARCHAR (100) NULL,
    [TextOnWebsitePaymentButton] NVARCHAR (100) NULL,
    [DaysUntilDue]               INT            NULL,
    [RetailUSA]                  CHAR (1)       NULL,
    [RetailInternational]        CHAR (1)       NULL,
    [WholesaleUSA]               CHAR (1)       NULL,
    [WholesaleInternational]     CHAR (1)       NULL,
    [TermsDays]                  INT            NULL
);

