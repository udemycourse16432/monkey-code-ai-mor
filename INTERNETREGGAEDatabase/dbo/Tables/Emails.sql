CREATE TABLE [dbo].[Emails] (
    [counter]               INT            IDENTITY (1, 1) NOT NULL,
    [Email]                 NVARCHAR (150) NULL,
    [LogInEmail]            NVARCHAR (150) NULL,
    [CustomerServerCounter] INT            NULL,
    [CustomerID]            NVARCHAR (50)  NULL
);

