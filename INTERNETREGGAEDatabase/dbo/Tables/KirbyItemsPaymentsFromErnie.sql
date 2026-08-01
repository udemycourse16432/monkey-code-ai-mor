CREATE TABLE [dbo].[KirbyItemsPaymentsFromErnie] (
    [counter]                    INT            IDENTITY (1, 1) NOT NULL,
    [DateTime]                   DATETIME       NOT NULL,
    [CheckNumber]                NVARCHAR (50)  NULL,
    [PaymentToKirbyAmount]       NUMERIC (7, 2) NULL,
    [PaymentToKirbyQuantitySold] INT            NULL,
    [PaymentToKirbyYear]         INT            NULL,
    [PaymentToKirbyMonth]        INT            NULL,
    CONSTRAINT [PK_KirbyItemsPaymentsFromErnie] PRIMARY KEY CLUSTERED ([counter] ASC)
);

