CREATE TABLE [dbo].[OrderCorrectionNotes] (
    [counter]               INT            IDENTITY (1, 1) NOT NULL,
    [OrderNumber]           NVARCHAR (50)  NULL,
    [Email]                 NVARCHAR (150) NULL,
    [PrintGroup]            INT            NULL,
    [CustomerName]          NVARCHAR (300) NULL,
    [LogInEmail]            NVARCHAR (100) NULL,
    [Password]              NVARCHAR (50)  NULL,
    [CorrectionNote]        VARCHAR (5000) NULL,
    [DateTimeNote]          DATETIME       CONSTRAINT [DF_OrderCorrectionNotes_DateTimeNote] DEFAULT (getdate()) NULL,
    [CustomerID]            NVARCHAR (50)  NULL,
    [DateTimeOrdered]       DATETIME       NULL,
    [DownloadGroup]         INT            NULL,
    [CustomerServerCounter] INT            NULL,
    CONSTRAINT [PK_OrderCorrectionNotes] PRIMARY KEY CLUSTERED ([counter] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_DownloadGroup]
    ON [dbo].[OrderCorrectionNotes]([DownloadGroup] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_OrderCorrectionNotes]
    ON [dbo].[OrderCorrectionNotes]([OrderNumber] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_OrderCorrectionNotes_1]
    ON [dbo].[OrderCorrectionNotes]([PrintGroup] ASC);

