CREATE TABLE [dbo].[WebSearchSuggestionsToFigure] (
    [InventoryID]            INT            NOT NULL,
    [DataChangeType]         NVARCHAR (10)  NOT NULL,
    [TableThatChanged]       NVARCHAR (50)  NULL,
    [InventoryItemFeatureID] INT            CONSTRAINT [DF_WebSearchSuggestionsToFigure_InventoryItemFeatureID_1] DEFAULT ((0)) NOT NULL,
    [Hint]                   NVARCHAR (255) NULL,
    [ArtistTitle]            NVARCHAR (350) NULL,
    [Label]                  NVARCHAR (120) NULL,
    [Rhythm]                 NVARCHAR (400) NULL,
    [Format]                 NVARCHAR (7)   NULL,
    [Genre1]                 NVARCHAR (30)  NULL,
    [Genre2]                 NVARCHAR (30)  NULL,
    [Genre3]                 NVARCHAR (30)  NULL,
    [Genre4]                 NVARCHAR (30)  NULL,
    [Genre5]                 NVARCHAR (30)  NULL,
    [Genre6]                 NVARCHAR (30)  NULL,
    [Genre7]                 NVARCHAR (30)  NULL,
    [Genre8]                 NVARCHAR (30)  NULL,
    [Genre9]                 NVARCHAR (30)  NULL,
    [TriedDateTime]          DATETIME       NULL,
    [counter]                INT            IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_WebSearchSuggestionsToFigure_1] PRIMARY KEY CLUSTERED ([counter] ASC)
);

