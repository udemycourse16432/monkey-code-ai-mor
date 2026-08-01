CREATE TABLE [dbo].[SignInCartTotalsTableKirby] (
    [CustomerServerCounter] INT            NOT NULL,
    [TotalPrice]            NUMERIC (8, 2) NOT NULL,
    [TotalQuantity]         INT            NOT NULL,
    [LastCartAdjustment]    DATETIME       NULL,
    [FullName]              NVARCHAR (120) NULL,
    [City]                  NVARCHAR (100) NULL,
    [CustomerID]            NVARCHAR (50)  NULL,
    [LastSearchDone]        DATETIME       NULL,
    [TotalEmailsSent]       INT            NULL,
    [LastEmailDate]         DATETIME       NULL,
    [counter]               INT            IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_SignInCartTotalsTables] PRIMARY KEY CLUSTERED ([counter] ASC)
);

