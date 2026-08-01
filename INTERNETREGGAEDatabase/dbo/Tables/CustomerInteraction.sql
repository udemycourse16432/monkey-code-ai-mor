CREATE TABLE [dbo].[CustomerInteraction] (
    [counter]                INT           IDENTITY (1, 1) NOT NULL,
    [CustomerID]             INT           NULL,
    [CustomerTableName]      NVARCHAR (20) NULL,
    [CustomerServerCounter]  INT           NULL,
    [DateTime]               DATETIME      NULL,
    [EBRep]                  NVARCHAR (50) NULL,
    [CustomerRep]            NVARCHAR (75) NULL,
    [Notes]                  TEXT          NULL,
    [JavascriptRandomNumber] INT           NULL
);

