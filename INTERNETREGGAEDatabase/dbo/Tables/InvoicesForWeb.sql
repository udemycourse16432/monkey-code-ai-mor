CREATE TABLE [dbo].[InvoicesForWeb] (
    [Invoice]                       INT            NULL,
    [ShippingMethod]                NVARCHAR (30)  NULL,
    [Date]                          DATETIME       NULL,
    [WR]                            NVARCHAR (15)  NULL,
    [Terms]                         NVARCHAR (255) NULL,
    [CustomerName]                  NVARCHAR (100) NULL,
    [CustomerID]                    INT            NULL,
    [Letter]                        NVARCHAR (MAX) NULL,
    [PercentDiscount]               INT            NULL,
    [Discount]                      NUMERIC (9, 2) NULL,
    [PromoDiscount]                 NUMERIC (9, 2) NULL,
    [Received]                      NUMERIC (9, 2) NULL,
    [Previous]                      NUMERIC (9, 2) NULL,
    [Tax]                           NUMERIC (9, 2) NULL,
    [Shipping]                      NUMERIC (9, 2) NULL,
    [CreditCardPayment]             NUMERIC (9, 2) NULL,
    [CreditCard]                    NVARCHAR (25)  NULL,
    [CreditCardNumber]              NVARCHAR (25)  NULL,
    [Address1]                      NVARCHAR (100) NULL,
    [Address2]                      NVARCHAR (100) NULL,
    [Address3]                      NVARCHAR (100) NULL,
    [Address4]                      NVARCHAR (100) NULL,
    [ShipToName]                    NVARCHAR (100) NULL,
    [ShipToAddress1]                NVARCHAR (100) NULL,
    [ShipToAddress2]                NVARCHAR (100) NULL,
    [ShipToAddress3]                NVARCHAR (100) NULL,
    [ShipToAddress4]                NVARCHAR (100) NULL,
    [Phone1]                        NVARCHAR (25)  NULL,
    [Phone1Notes]                   NVARCHAR (25)  NULL,
    [Phone2]                        NVARCHAR (25)  NULL,
    [Phone2Notes]                   NVARCHAR (25)  NULL,
    [Fax]                           NVARCHAR (25)  NULL,
    [FaxNotes]                      NVARCHAR (25)  NULL,
    [Zone]                          NVARCHAR (10)  NULL,
    [WaybillNumber]                 NVARCHAR (200) NULL,
    [DeliveryDate]                  DATETIME       NULL,
    [NumberOfBoxes]                 INT            NULL,
    [Weight]                        INT            NULL,
    [ShipmentNotes]                 NVARCHAR (MAX) NULL,
    [ShipDate]                      DATETIME       NULL,
    [CODCharge]                     NUMERIC (9, 2) NULL,
    [WebOrderNumber]                NVARCHAR (250) NULL,
    [Email]                         NVARCHAR (255) NULL,
    [PayPalPayment]                 NUMERIC (9, 2) NULL,
    [PO]                            NVARCHAR (100) NULL,
    [ShipToCountry]                 NVARCHAR (70)  NULL,
    [ShipViaService]                NVARCHAR (60)  NULL,
    [Address5]                      NVARCHAR (100) NULL,
    [ShipToAddress5]                NVARCHAR (100) NULL,
    [ShipViaCompany]                NVARCHAR (50)  NULL,
    [RecipientFedexAccountNumber]   NVARCHAR (20)  NULL,
    [Time]                          DATETIME       NULL,
    [GoogleCheckoutPayment]         NUMERIC (9, 2) NULL,
    [CODCash]                       NVARCHAR (1)   NULL,
    [EditShippingConfirmationEmail] NVARCHAR (1)   NULL,
    [EmailedShippingConfirmation]   NVARCHAR (1)   NULL,
    [CODCheck]                      NVARCHAR (1)   NULL,
    [ScheduledArrivalDate]          NVARCHAR (60)  NULL,
    [PDFInvoiceFileName]            NVARCHAR (40)  NULL,
    [NeedsPDFRedo]                  NVARCHAR (1)   NULL,
    [Phone3]                        NVARCHAR (20)  NULL,
    [Phone3Notes]                   NVARCHAR (30)  NULL,
    [PurchaseTotal]                 NUMERIC (9, 2) NULL,
    [GiftCardDiscount]              NUMERIC (9, 2) NULL,
    [NumberOfLineItems]             INT            CONSTRAINT [DF_InvoicesForWeb_NumberOfLineItems] DEFAULT ((0)) NULL,
    [EstimatedShipping]             NUMERIC (7, 2) NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_CustomerID]
    ON [dbo].[InvoicesForWeb]([CustomerID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Date]
    ON [dbo].[InvoicesForWeb]([Date] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Invoice]
    ON [dbo].[InvoicesForWeb]([Invoice] ASC);

