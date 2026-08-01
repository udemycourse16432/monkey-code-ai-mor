CREATE TABLE [dbo].[KirbySixPercenPaymentsFromErnie] (
    [counter]          INT            IDENTITY (1, 1) NOT NULL,
    [DateTime]         DATETIME       NOT NULL,
    [CheckNumber]      NVARCHAR (50)  NULL,
    [Amount]           NUMERIC (7, 2) NULL,
    [ConsignmentYear]  INT            NULL,
    [ConsignmentMonth] INT            NULL,
    CONSTRAINT [PK_KirbySixPercenPaymentsFromErnie] PRIMARY KEY CLUSTERED ([counter] ASC)
);

