CREATE TABLE [dbo].[WebArtists] (
    [Artist]      NVARCHAR (255) NULL,
    [InventoryID] INT            NULL,
    [Format]      NVARCHAR (50)  NULL,
    [InStock]     NVARCHAR (1)   NULL,
    [counter]     INT            IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_WebArtists] PRIMARY KEY NONCLUSTERED ([counter] ASC)
);


GO
CREATE CLUSTERED INDEX [IX_Artist]
    ON [dbo].[WebArtists]([Artist] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Format]
    ON [dbo].[WebArtists]([Format] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_InStock]
    ON [dbo].[WebArtists]([InStock] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_InventoryID]
    ON [dbo].[WebArtists]([InventoryID] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_ArtistInventoryID]
    ON [dbo].[WebArtists]([Artist] ASC, [InventoryID] ASC) WITH (ALLOW_PAGE_LOCKS = OFF);

