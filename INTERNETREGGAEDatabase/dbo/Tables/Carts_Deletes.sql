CREATE TABLE [dbo].[Carts_Deletes] (
    [counter]       INT      IDENTITY (1, 1) NOT NULL,
    [InSync]        CHAR (1) CONSTRAINT [DF_Carts_Deletes_InSync] DEFAULT ('n') NULL,
    [DeleteCounter] INT      NULL
);

