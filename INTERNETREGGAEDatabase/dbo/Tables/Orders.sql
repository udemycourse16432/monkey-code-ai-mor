CREATE TABLE [dbo].[Orders] (
    [Status]                               NVARCHAR (20)   NULL,
    [LogInEmail]                           NVARCHAR (100)  NOT NULL,
    [Password]                             NVARCHAR (50)   NOT NULL,
    [Email]                                NVARCHAR (100)  NULL,
    [Phone]                                NVARCHAR (30)   NULL,
    [FullName]                             NVARCHAR (150)  NULL,
    [StreetAddress1]                       NVARCHAR (150)  NULL,
    [StreetAddress2]                       NVARCHAR (150)  NULL,
    [City]                                 NVARCHAR (100)  NULL,
    [StateProvince]                        NVARCHAR (100)  NULL,
    [PostalCode]                           NVARCHAR (25)   NULL,
    [Island]                               NVARCHAR (50)   NULL,
    [Country]                              NVARCHAR (100)  NULL,
    [BillingFullName]                      NVARCHAR (200)  NULL,
    [BillingStreetAddress1]                NVARCHAR (100)  NULL,
    [BillingStreetAddress2]                NVARCHAR (120)  NULL,
    [BillingCity]                          NVARCHAR (100)  NULL,
    [BillingStateProvince]                 NVARCHAR (100)  NULL,
    [BillingPostalCode]                    NVARCHAR (25)   NULL,
    [BillingIsland]                        NVARCHAR (50)   NULL,
    [BillingCountry]                       NVARCHAR (100)  NULL,
    [USPossession]                         NVARCHAR (100)  NULL,
    [DateTime]                             DATETIME        NULL,
    [ShippingMethod]                       NVARCHAR (50)   NULL,
    [CreditCardNumber]                     NVARCHAR (255)  NULL,
    [ExpDate]                              NVARCHAR (6)    NULL,
    [CreditCardAmountPaid]                 NUMERIC (10, 2) NULL,
    [OrderNumber]                          NVARCHAR (15)   NULL,
    [Shipping]                             NUMERIC (7, 2)  NULL,
    [Tax]                                  NUMERIC (7, 2)  NULL,
    [IPAddress]                            NVARCHAR (50)   NULL,
    [Browser]                              NVARCHAR (50)   NULL,
    [BrowserVersion]                       NVARCHAR (50)   NULL,
    [Platform]                             NVARCHAR (50)   NULL,
    [StorePassword]                        NVARCHAR (50)   NULL,
    [OrderNotes]                           NVARCHAR (MAX)  NULL,
    [OrderProcessChoice]                   NVARCHAR (50)   NULL,
    [Fax]                                  NVARCHAR (50)   NULL,
    [Attn]                                 NVARCHAR (50)   NULL,
    [ChangedAddress]                       NVARCHAR (MAX)  NULL,
    [RemHost]                              NVARCHAR (400)  NULL,
    [PONumber]                             NVARCHAR (100)  NULL,
    [counter]                              INT             IDENTITY (1, 1) NOT NULL,
    [PowerUserName]                        NVARCHAR (50)   NULL,
    [CustomerID]                           NVARCHAR (30)   NULL,
    [PowerUserNewCustomer]                 NVARCHAR (10)   NULL,
    [Cost]                                 SMALLMONEY      NULL,
    [HowFoundUs]                           NVARCHAR (50)   NULL,
    [PaypalAmountDue]                      NUMERIC (10, 2) NULL,
    [PaypalTransactionID]                  NVARCHAR (50)   NULL,
    [PaypalPaymentStatus]                  NVARCHAR (50)   NULL,
    [PayPalPendingReason]                  NVARCHAR (50)   NULL,
    [PayPalAmountPaid]                     NUMERIC (10, 2) NULL,
    [PayPalEmail]                          NVARCHAR (100)  NULL,
    [ShippingMethodPullSheetText]          NVARCHAR (50)   NULL,
    [Weight]                               NUMERIC (10, 2) NULL,
    [WesternUnionAmountDue]                NUMERIC (10, 2) CONSTRAINT [DF_Orders_WesternUnionAmountDue] DEFAULT ((0)) NULL,
    [CheckCashorMoneyOrderAmountDue]       NUMERIC (10, 2) CONSTRAINT [DF_Orders_CheckCashorMoneyOrderAmountDue] DEFAULT ((0)) NULL,
    [OrderTotal]                           NUMERIC (10, 2) NULL,
    [SessionID]                            NVARCHAR (50)   NULL,
    [PaymentsProTransactionID]             NVARCHAR (50)   NULL,
    [Phone2]                               NVARCHAR (30)   NULL,
    [Phone3]                               NVARCHAR (30)   NULL,
    [Email2]                               NVARCHAR (100)  NULL,
    [Email3]                               NVARCHAR (100)  NULL,
    [CustomerServerCounter]                INT             NULL,
    [InvoiceNumber]                        INT             NULL,
    [GiftCardAmount]                       NUMERIC (10, 2) CONSTRAINT [DF_Orders_GiftCardAmount] DEFAULT ((0)) NULL,
    [GiftCardNumber]                       NVARCHAR (20)   NULL,
    [GiftCardAccountsServerCounter]        INT             NULL,
    [UserAgent]                            NVARCHAR (MAX)  NULL,
    [NumberOfLineItems]                    INT             NULL,
    [PriceGroup]                           NVARCHAR (20)   NULL,
    [DownloadGroup]                        INT             NULL,
    [EmailedConfirmation]                  NVARCHAR (10)   NULL,
    [TotalQuantity]                        INT             NULL,
    [TotalPrice]                           NUMERIC (8, 2)  NULL,
    [EmailedToInquireIfPayPalOrderProblem] NVARCHAR (1)    NULL,
    [GoogleCheckoutAmountDue]              NUMERIC (18, 2) CONSTRAINT [DF_Orders_GoogleCheckoutAmountDue] DEFAULT ((0)) NULL,
    [GoogleCheckoutAmountPaid]             NUMERIC (18, 2) NULL,
    [PrintedInvoice]                       NVARCHAR (1)    NULL,
    [EmailedOWEB]                          NVARCHAR (10)   NULL,
    CONSTRAINT [IX_Orders_6] UNIQUE NONCLUSTERED ([OrderNumber] ASC)
);


GO
CREATE CLUSTERED INDEX [IX_Orders]
    ON [dbo].[Orders]([CreditCardNumber] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Orders_1]
    ON [dbo].[Orders]([ExpDate] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Orders_10]
    ON [dbo].[Orders]([OrderProcessChoice] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Orders_2]
    ON [dbo].[Orders]([Status] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Orders_3]
    ON [dbo].[Orders]([DownloadGroup] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Orders_4]
    ON [dbo].[Orders]([LogInEmail] ASC, [Password] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Orders_7]
    ON [dbo].[Orders]([DateTime] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Orders_8]
    ON [dbo].[Orders]([StorePassword] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Orders_CustomerID]
    ON [dbo].[Orders]([CustomerID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Orders_CustomerServerCounter]
    ON [dbo].[Orders]([CustomerServerCounter] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Orders_InvoiceNumber]
    ON [dbo].[Orders]([InvoiceNumber] ASC);

