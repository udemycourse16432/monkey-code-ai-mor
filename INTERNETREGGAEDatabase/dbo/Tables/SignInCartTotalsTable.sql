CREATE TABLE [dbo].[SignInCartTotalsTable] (
    [CustomerServerCounter] INT            NOT NULL,
    [TotalPrice]            NUMERIC (8, 2) NOT NULL,
    [TotalQuantity]         INT            NOT NULL,
    [LastCartAdjustment]    DATETIME       NULL,
    [FullName]              NVARCHAR (120) NULL,
    [City]                  NVARCHAR (100) NULL,
    [CustomerID]            NVARCHAR (50)  NULL,
    [counter]               INT            IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_SignInCartTotalsTable] PRIMARY KEY CLUSTERED ([counter] ASC)
);

