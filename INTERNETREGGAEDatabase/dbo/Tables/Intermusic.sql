CREATE TABLE [dbo].[Intermusic] (
    [Supplier1Price]  NUMERIC (6, 2) NULL,
    [Cost]            NUMERIC (6, 2) NULL,
    [Quantity]        INT            NULL,
    [FullDescription] NVARCHAR (255) NULL,
    [ItemID]          INT            NULL,
    [UPC]             NVARCHAR (255) NULL,
    [WholesalePrice]  NUMERIC (6, 2) NULL,
    [counter]         INT            IDENTITY (1, 1) NOT NULL
);

