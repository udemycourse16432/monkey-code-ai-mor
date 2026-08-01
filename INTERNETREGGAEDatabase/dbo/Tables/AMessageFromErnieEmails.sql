CREATE TABLE [dbo].[AMessageFromErnieEmails] (
    [MessageNumber]          INT           NULL,
    [EmailMessage]           TEXT          NULL,
    [Email]                  NVARCHAR (50) NULL,
    [WholesaleServerCounter] INT           NULL,
    [SessionID]              NVARCHAR (50) NULL,
    [IPAddress]              NVARCHAR (50) NULL,
    [counter]                INT           IDENTITY (1, 1) NOT NULL,
    [DateTime]               DATETIME      CONSTRAINT [DF_AMessageFromErnieEmails_DateTime] DEFAULT (getdate()) NULL
);

