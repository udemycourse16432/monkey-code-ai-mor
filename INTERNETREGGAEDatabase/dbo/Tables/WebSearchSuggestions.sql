CREATE TABLE [dbo].[WebSearchSuggestions] (
    [Hint]            NVARCHAR (255) NOT NULL,
    [Total]           INT            NOT NULL,
    [CD]              INT            NOT NULL,
    [Vinyl]           INT            NOT NULL,
    [Other]           INT            NOT NULL,
    [SearchType]      NVARCHAR (50)  NOT NULL,
    [counter]         INT            IDENTITY (1, 1) NOT NULL,
    [Word1]           NVARCHAR (50)  NULL,
    [Word2]           NVARCHAR (50)  NULL,
    [Word3]           NVARCHAR (50)  NULL,
    [Word4]           NVARCHAR (50)  NULL,
    [Word5]           NVARCHAR (50)  NULL,
    [Word6]           NVARCHAR (50)  NULL,
    [Word7]           NVARCHAR (50)  NULL,
    [Word8]           NVARCHAR (50)  NULL,
    [Word9]           NVARCHAR (50)  NULL,
    [Word10]          NVARCHAR (50)  NULL,
    [Word11]          NVARCHAR (50)  NULL,
    [Word12]          NVARCHAR (50)  NULL,
    [Word13]          NVARCHAR (50)  NULL,
    [Word14]          NVARCHAR (50)  NULL,
    [Word15]          NVARCHAR (50)  NULL,
    [Word16]          NVARCHAR (50)  NULL,
    [Word17]          NVARCHAR (50)  NULL,
    [Word18]          NVARCHAR (50)  NULL,
    [Word19]          NVARCHAR (50)  NULL,
    [Word20]          NVARCHAR (50)  NULL,
    [SalesLast30Days] INT            CONSTRAINT [DF_WebSearchSuggestions_SalesLast30Days] DEFAULT ((0)) NULL,
    [ScanPath]        NVARCHAR (50)  NULL,
    [SortOrder]       INT            CONSTRAINT [DF_WebSearchSuggestions_SortOrder] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_WebSearchSuggestions] PRIMARY KEY CLUSTERED ([counter] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_Word1]
    ON [dbo].[WebSearchSuggestions]([Word1] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Word2]
    ON [dbo].[WebSearchSuggestions]([Word2] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Word3]
    ON [dbo].[WebSearchSuggestions]([Word3] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Word4]
    ON [dbo].[WebSearchSuggestions]([Word4] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Word5]
    ON [dbo].[WebSearchSuggestions]([Word5] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Word6]
    ON [dbo].[WebSearchSuggestions]([Word6] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Word7]
    ON [dbo].[WebSearchSuggestions]([Word7] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Word8]
    ON [dbo].[WebSearchSuggestions]([Word8] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Word9]
    ON [dbo].[WebSearchSuggestions]([Word9] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Word10]
    ON [dbo].[WebSearchSuggestions]([Word10] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Word11]
    ON [dbo].[WebSearchSuggestions]([Word11] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Word12]
    ON [dbo].[WebSearchSuggestions]([Word12] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Word13]
    ON [dbo].[WebSearchSuggestions]([Word13] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Word14]
    ON [dbo].[WebSearchSuggestions]([Word14] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Word15]
    ON [dbo].[WebSearchSuggestions]([Word15] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Word16]
    ON [dbo].[WebSearchSuggestions]([Word16] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Word17]
    ON [dbo].[WebSearchSuggestions]([Word17] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Word18]
    ON [dbo].[WebSearchSuggestions]([Word18] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Word19]
    ON [dbo].[WebSearchSuggestions]([Word19] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Word20]
    ON [dbo].[WebSearchSuggestions]([Word20] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_SalesLast30Days]
    ON [dbo].[WebSearchSuggestions]([SalesLast30Days] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Total]
    ON [dbo].[WebSearchSuggestions]([Total] ASC);

