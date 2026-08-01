CREATE TABLE [dbo].[Customers] (
    [UserName]                        NVARCHAR (50)  NULL,
    [Password]                        NVARCHAR (50)  NULL,
    [Email]                           NVARCHAR (100) NULL,
    [Phone]                           NVARCHAR (30)  NULL,
    [FullName]                        NVARCHAR (120) NULL,
    [StreetAddress1]                  NVARCHAR (100) NULL,
    [StreetAddress2]                  NVARCHAR (100) NULL,
    [City]                            NVARCHAR (100) NULL,
    [StateProvince]                   NVARCHAR (100) NULL,
    [PostalCode]                      NVARCHAR (25)  NULL,
    [Island]                          NVARCHAR (50)  NULL,
    [Country]                         NVARCHAR (50)  NULL,
    [BillingFullName]                 NVARCHAR (120) NULL,
    [BillingStreetAddress1]           NVARCHAR (100) NULL,
    [BillingStreetAddress2]           NVARCHAR (100) NULL,
    [BillingCity]                     NVARCHAR (100) NULL,
    [BillingStateProvince]            NVARCHAR (100) NULL,
    [BillingPostalCode]               NVARCHAR (25)  NULL,
    [BillingIsland]                   NVARCHAR (50)  NULL,
    [BillingCountry]                  NVARCHAR (50)  NULL,
    [Address1]                        NVARCHAR (300) NULL,
    [Address2]                        NVARCHAR (300) NULL,
    [Address3]                        NVARCHAR (300) NULL,
    [Address4]                        NVARCHAR (300) NULL,
    [USPossession]                    NVARCHAR (100) NULL,
    [DateTime]                        CHAR (50)      NULL,
    [CaTax]                           NVARCHAR (10)  NULL,
    [CreditApprovalCode]              NVARCHAR (30)  NULL,
    [counter]                         INT            IDENTITY (1, 1) NOT NULL,
    [HowFoundUs]                      NVARCHAR (50)  NULL,
    [CustomerID]                      NVARCHAR (50)  CONSTRAINT [DF_Customers_CustomerID] DEFAULT ('-') NULL,
    [Phone2]                          NVARCHAR (30)  NULL,
    [Phone3]                          NVARCHAR (30)  NULL,
    [Email2]                          NVARCHAR (100) NULL,
    [Email3]                          NVARCHAR (100) NULL,
    [Fax]                             NVARCHAR (30)  NULL,
    [DateOfLastOrder]                 DATETIME       NULL,
    [DateOfLastLogin]                 DATETIME       NULL,
    [DateOfLastCustomerInteraction]   DATETIME       NULL,
    [DateOfLastCartAdjustment]        DATETIME       NULL,
    [LogInEmail]                      NVARCHAR (100) NULL,
    [PriceGroup]                      NVARCHAR (50)  CONSTRAINT [DF_Customers_PriceGroup] DEFAULT ('StorePrice') NULL,
    [Attn]                            NVARCHAR (50)  NULL,
    [MinimumOrder]                    SMALLMONEY     NULL,
    [PowerUserName]                   NVARCHAR (20)  NULL,
    [SuperPowerUserName]              NVARCHAR (50)  NULL,
    [ResidentialDelivery]             NVARCHAR (1)   NULL,
    [ChargeSalesTax]                  NVARCHAR (1)   NULL,
    [IPAddress]                       NVARCHAR (50)  NULL,
    [counterOLD]                      INT            NULL,
    [CartQuantity]                    INT            NULL,
    [InSync]                          CHAR (1)       CONSTRAINT [DF_Customers_InSync] DEFAULT ('n') NULL,
    [TotalSignIns]                    INT            CONSTRAINT [DF_Customers_TotalSignIns] DEFAULT ((0)) NOT NULL,
    [CurrentCartTotalPrice]           NUMERIC (8, 2) CONSTRAINT [DF_Customers_CurrentCartTotalPrice] DEFAULT ((0)) NOT NULL,
    [NumberOfCartReminderEmailsSent]  INT            NULL,
    [DateOfLastCartReminderEmailSent] DATETIME       NULL,
    [DateOfLastSearch]                DATETIME       NULL,
    [BlockedFromCheckout]             NVARCHAR (1)   CONSTRAINT [DF_Customers_BlockedFromCheckout] DEFAULT ('n') NULL,
    [EmailedNWEB]                     NVARCHAR (10)  NULL,
    CONSTRAINT [CK_ChargeSalesTax] CHECK ([ChargeSalesTax] IS NULL OR [ChargeSalesTax]='n'),
    CONSTRAINT [CK_PriceGroup] CHECK (([PriceGroup]='RetailPrice' OR [PriceGroup]='StorePrice' OR [PriceGroup]='ExportPrice') AND [PriceGroup] IS NOT NULL),
    CONSTRAINT [CK_ResidentialDelivery] CHECK (([ResidentialDelivery]='y' OR [ResidentialDelivery]='n') AND [ResidentialDelivery] IS NOT NULL)
);


GO
CREATE CLUSTERED INDEX [IX_FullName]
    ON [dbo].[Customers]([FullName] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_SuperPowerUserName]
    ON [dbo].[Customers]([SuperPowerUserName] ASC) WITH (ALLOW_PAGE_LOCKS = OFF);


GO
CREATE NONCLUSTERED INDEX [IX_CustomerID]
    ON [dbo].[Customers]([CustomerID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_DateOfLastLogin]
    ON [dbo].[Customers]([DateOfLastLogin] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_DateOfLastOrder]
    ON [dbo].[Customers]([DateOfLastOrder] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_LogInEmail]
    ON [dbo].[Customers]([LogInEmail] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_PowerUserName]
    ON [dbo].[Customers]([PowerUserName] ASC) WITH (ALLOW_PAGE_LOCKS = OFF);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_LogInEmailPassword]
    ON [dbo].[Customers]([LogInEmail] ASC, [Password] ASC) WITH (ALLOW_PAGE_LOCKS = OFF);


GO
CREATE NONCLUSTERED INDEX [IX_counter]
    ON [dbo].[Customers]([counter] ASC) WITH (ALLOW_PAGE_LOCKS = OFF);


GO
CREATE NONCLUSTERED INDEX [IX_CartQuantity]
    ON [dbo].[Customers]([CartQuantity] ASC) WITH (ALLOW_PAGE_LOCKS = OFF);


GO
CREATE NONCLUSTERED INDEX [IX_DateOfLastCartAdjustment]
    ON [dbo].[Customers]([DateOfLastCartAdjustment] ASC) WITH (ALLOW_PAGE_LOCKS = OFF);


GO
create TRIGGER [dbo].[Customers_UpdateTrigger]
   ON  [dbo].[Customers] 
   for UPDATE
AS 
 Update Customers
  set InSync='n'
 where counter in (select deleted.counter from deleted
  where InSync='y')
