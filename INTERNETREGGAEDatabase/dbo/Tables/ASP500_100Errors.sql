CREATE TABLE [dbo].[ASP500_100Errors] (
    [counter]             INT             IDENTITY (1, 1) NOT NULL,
    [DateTime]            DATETIME        CONSTRAINT [DF_500-100Errors_DateTime] DEFAULT (getdate()) NOT NULL,
    [IPAddress]           NVARCHAR (50)   NULL,
    [ASPCode]             NVARCHAR (16)   NULL,
    [ASPDescription]      NVARCHAR (512)  NULL,
    [Category]            NVARCHAR (255)  NULL,
    [Description]         NVARCHAR (512)  NULL,
    [PageName]            NVARCHAR (80)   NULL,
    [LineNumber]          INT             NULL,
    [URL]                 NVARCHAR (2000) NULL,
    [UserAgent]           NVARCHAR (1024) NULL,
    [CustomerName]        NVARCHAR (100)  NULL,
    [WholesaleCustomerID] NVARCHAR (25)   NULL,
    [RetailCustomerID]    NVARCHAR (25)   NULL,
    [PostRequestValues]   NVARCHAR (2000) NULL,
    [ID]                  NVARCHAR (20)   NULL,
    [PowerUserName]       NVARCHAR (50)   NULL
);

