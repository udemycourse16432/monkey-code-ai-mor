CREATE TABLE [dbo].[NewReleaseEmailOptInOrOut] (
    [LogInEmail]    NVARCHAR (100) NULL,
    [Password]      NVARCHAR (50)  NULL,
    [Email]         NVARCHAR (100) NULL,
    [OptIn]         NVARCHAR (4)   NULL,
    [FullName]      NVARCHAR (150) NULL,
    [counter]       INT            IDENTITY (1, 1) NOT NULL,
    [DateTime]      DATETIME       NULL,
    [DownloadGroup] INT            NULL
);

