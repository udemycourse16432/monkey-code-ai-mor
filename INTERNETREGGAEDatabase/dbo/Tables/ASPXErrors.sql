CREATE TABLE [dbo].[ASPXErrors] (
    [counter]         INT             IDENTITY (1, 1) NOT NULL,
    [DateTime]        DATETIME        NOT NULL,
    [CartName]        NVARCHAR (60)   NULL,
    [UserAgent]       NVARCHAR (300)  NULL,
    [IPAddress]       NVARCHAR (50)   NULL,
    [PowerUserName]   NVARCHAR (50)   NULL,
    [ErrorMessage]    NVARCHAR (500)  NULL,
    [QueryString]     NVARCHAR (1000) NULL,
    [FormValues]      NVARCHAR (2000) NULL,
    [ErrorStackTrace] NVARCHAR (2000) NULL,
    [ErrorLevel]      NVARCHAR (50)   NULL,
    [InSync]          CHAR (1)        NULL,
    CONSTRAINT [PK_ASPErrors] PRIMARY KEY CLUSTERED ([counter] ASC)
);

