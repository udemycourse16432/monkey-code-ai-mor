CREATE TABLE [dbo].[HoldPilesForWeb] (
    [CustomerID]                        NVARCHAR (30)   NULL,
    [Date]                              DATETIME        NULL,
    [POnumber]                          NVARCHAR (100)  NULL,
    [WebOrderNumber]                    NVARCHAR (20)   NULL,
    [DownloadGroup]                     INT             NULL,
    [QuasiHold]                         NVARCHAR (3)    NULL,
    [TagShippingMethod]                 NVARCHAR (20)   NULL,
    [HoldPileNumber]                    NVARCHAR (20)   NULL,
    [NonWebOrderNumber]                 NVARCHAR (20)   NULL,
    [HoldPileStatus]                    NVARCHAR (30)   CONSTRAINT [DF_HoldPiles_HoldPileStatus] DEFAULT ('Ordered') NULL,
    [LogInEmail]                        NVARCHAR (100)  NULL,
    [Password]                          NVARCHAR (50)   NULL,
    [StorePassword]                     NVARCHAR (50)   NULL,
    [CustomerServerCounter]             INT             NULL,
    [InvoiceNumber]                     INT             NULL,
    [counter]                           INT             IDENTITY (1, 1) NOT NULL,
    [CreditCardNumberAttempted]         NVARCHAR (30)   NULL,
    [CreditCardAmountAttempted]         NUMERIC (18, 2) NULL,
    [CreditCardExpirationDateAttempted] NVARCHAR (6)    NULL,
    [CreditCardDateAttempted]           DATETIME        NULL,
    [StatusNotes]                       NVARCHAR (255)  NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_CustomerID]
    ON [dbo].[HoldPilesForWeb]([CustomerID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_CustomerServerCounter]
    ON [dbo].[HoldPilesForWeb]([CustomerServerCounter] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_HoldPileNumber]
    ON [dbo].[HoldPilesForWeb]([HoldPileNumber] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_HoldPileStatus]
    ON [dbo].[HoldPilesForWeb]([HoldPileStatus] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Password]
    ON [dbo].[HoldPilesForWeb]([Password] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_StorePassword]
    ON [dbo].[HoldPilesForWeb]([StorePassword] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_UserName]
    ON [dbo].[HoldPilesForWeb]([LogInEmail] ASC);

