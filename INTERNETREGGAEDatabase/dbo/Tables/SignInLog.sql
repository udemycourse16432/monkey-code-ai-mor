CREATE TABLE [dbo].[SignInLog] (
    [DateTime]              DATETIME       NULL,
    [IPAddress]             NVARCHAR (50)  NULL,
    [LoggedOnSuccessful]    NVARCHAR (3)   NULL,
    [Password]              NVARCHAR (50)  NULL,
    [StoreName]             NVARCHAR (150) NULL,
    [City]                  NVARCHAR (100) NULL,
    [Counter]               INT            IDENTITY (1, 1) NOT NULL,
    [PriceGroup]            NVARCHAR (20)  NULL,
    [PowerUserName]         NVARCHAR (50)  NULL,
    [CustomerServerCounter] INT            NULL,
    [LogInEmail]            NVARCHAR (100) NULL,
    [CartQuantity]          INT            NULL,
    [InSync]                CHAR (1)       CONSTRAINT [DF_SignInLog_InSync] DEFAULT ('n') NOT NULL,
    CONSTRAINT [PK_StoreLogOnAccessed] PRIMARY KEY CLUSTERED ([Counter] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_WholesaleServerCounter]
    ON [dbo].[SignInLog]([CustomerServerCounter] ASC);

