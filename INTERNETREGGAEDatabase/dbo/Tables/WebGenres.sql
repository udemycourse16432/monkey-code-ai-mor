CREATE TABLE [dbo].[WebGenres] (
    [Genre]       NVARCHAR (60) NULL,
    [InventoryID] INT           NULL,
    [Format]      NVARCHAR (50) NULL,
    [InStock]     NVARCHAR (1)  NULL,
    [counter]     INT           IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_WebGenres] PRIMARY KEY CLUSTERED ([counter] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_GenreInventoryID]
    ON [dbo].[WebGenres]([Genre] ASC, [InventoryID] ASC) WITH (ALLOW_PAGE_LOCKS = OFF);

