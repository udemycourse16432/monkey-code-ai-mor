CREATE TABLE [dbo].[CreditCards] (
    [Account]               VARBINARY (MAX) NOT NULL,
    [ExpirationDate]        NVARCHAR (6)    NOT NULL,
    [CVV2]                  VARBINARY (MAX) NULL,
    [WebOrderNumber]        NVARCHAR (20)   NULL,
    [DateTime]              DATETIME        CONSTRAINT [DF_CreditCards_DateTime] DEFAULT (getdate()) NOT NULL,
    [RightFour]             NVARCHAR (4)    NOT NULL,
    [CustomerServerCounter] INT             NOT NULL,
    [counter]               INT             IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_CreditCards] PRIMARY KEY CLUSTERED ([counter] ASC)
);

