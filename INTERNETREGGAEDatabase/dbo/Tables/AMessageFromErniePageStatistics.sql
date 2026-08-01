CREATE TABLE [dbo].[AMessageFromErniePageStatistics] (
    [DateTime]               DATETIME      CONSTRAINT [DF_AMessageFromErniePageStatistics_DateTime] DEFAULT (getdate()) NULL,
    [counter]                INT           IDENTITY (1, 1) NOT NULL,
    [SessionID]              NVARCHAR (50) NULL,
    [IPAddress]              NVARCHAR (50) NULL,
    [WholesaleServerCounter] NVARCHAR (50) NULL
);

