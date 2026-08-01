CREATE TABLE [dbo].[MP3Check_MissingMP3Files] (
    [InventoryID] INT NOT NULL,
    [TrackNumber] INT NOT NULL,
    [counter]     INT IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_MissingMP3Files] PRIMARY KEY CLUSTERED ([counter] ASC)
);

