CREATE TABLE [dbo].[AMessageFromErnie] (
    [ID]       INT           NOT NULL,
    [Message]  TEXT          NULL,
    [DateTime] DATETIME      CONSTRAINT [DF_AMessageFromErnieNew_DateTime] DEFAULT (getdate()) NULL,
    [Title]    NVARCHAR (42) NULL
);

