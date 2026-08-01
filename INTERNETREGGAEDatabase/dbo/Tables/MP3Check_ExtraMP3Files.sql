CREATE TABLE [dbo].[MP3Check_ExtraMP3Files] (
    [InventoryID] INT NOT NULL,
    [counter]     INT IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_MP3Check_ExtraMP3Files] PRIMARY KEY CLUSTERED ([counter] ASC)
);

