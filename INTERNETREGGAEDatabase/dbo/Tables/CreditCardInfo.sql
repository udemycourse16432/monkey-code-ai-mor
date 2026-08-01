CREATE TABLE [dbo].[CreditCardInfo] (
    [counter]               INT            IDENTITY (1, 1) NOT NULL,
    [LogInEmail]            NVARCHAR (100) NULL,
    [Password]              NVARCHAR (100) NULL,
    [PriceGroup]            NVARCHAR (30)  NULL,
    [DateTime]              DATETIME       NULL,
    [FullName]              NVARCHAR (150) NULL,
    [StreetAddress1]        NVARCHAR (150) NULL,
    [CreditCardNumber]      NVARCHAR (128) NULL,
    [ExpDate]               NVARCHAR (10)  NULL,
    [CustomerID]            NVARCHAR (50)  NULL,
    [DownloadGroup]         INT            NULL,
    [SpecialNote]           VARCHAR (2000) NULL,
    [CustomerServerCounter] INT            NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_DownloadGroup]
    ON [dbo].[CreditCardInfo]([DownloadGroup] ASC);

