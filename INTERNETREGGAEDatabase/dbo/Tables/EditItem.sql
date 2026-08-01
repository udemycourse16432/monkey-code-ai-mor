CREATE TABLE [dbo].[EditItem] (
    [ItemID]        INT            NULL,
    [FieldName]     NVARCHAR (100) NULL,
    [NewValue]      VARCHAR (4000) NULL,
    [counter]       INT            IDENTITY (1, 1) NOT NULL,
    [TableName]     NVARCHAR (100) NULL,
    [DownloadGroup] INT            NULL
);

