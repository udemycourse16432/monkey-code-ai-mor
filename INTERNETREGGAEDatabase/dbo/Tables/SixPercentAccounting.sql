CREATE TABLE [dbo].[SixPercentAccounting] (
    [counter]       INT            IDENTITY (1, 1) NOT NULL,
    [Year]          INT            NOT NULL,
    [Month]         INT            NOT NULL,
    [PaymentDate]   DATETIME       NOT NULL,
    [PaymentAmount] NUMERIC (7, 2) NOT NULL,
    [CheckNumber]   INT            NULL,
    CONSTRAINT [PK_SixPercentAccounting] PRIMARY KEY CLUSTERED ([counter] ASC)
);

