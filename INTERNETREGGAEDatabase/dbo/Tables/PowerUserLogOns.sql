CREATE TABLE [dbo].[PowerUserLogOns] (
    [DateTime]      DATETIME      NULL,
    [IPAddress]     NVARCHAR (50) NULL,
    [Password]      NVARCHAR (50) NULL,
    [PowerUserName] NVARCHAR (50) NULL,
    [counter]       INT           IDENTITY (1, 1) NOT NULL
);

