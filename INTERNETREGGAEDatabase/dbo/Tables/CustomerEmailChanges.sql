CREATE TABLE [dbo].[CustomerEmailChanges] (
    [DateTime]              DATETIME       CONSTRAINT [DF_CustomerEmailChanges_DateTime] DEFAULT (getdate()) NOT NULL,
    [CustomerID]            INT            NOT NULL,
    [CustomerServerCounter] INT            NOT NULL,
    [OldEmail]              NVARCHAR (100) NOT NULL,
    [NewEmail]              NVARCHAR (100) NOT NULL,
    [DownloadGroup]         INT            NULL,
    [counter]               INT            IDENTITY (1, 1) NOT NULL
);

