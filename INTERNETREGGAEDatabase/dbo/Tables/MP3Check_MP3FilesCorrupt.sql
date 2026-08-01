CREATE TABLE [dbo].[MP3Check_MP3FilesCorrupt] (
    [InventoryID] INT NOT NULL,
    [TrackNumber] INT NOT NULL,
    [FileSize]    INT NOT NULL,
    [counter]     INT IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_MP3Check_MP3FilesCorrupt] PRIMARY KEY CLUSTERED ([counter] ASC)
);

