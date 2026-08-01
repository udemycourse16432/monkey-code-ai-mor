CREATE TABLE [dbo].[webSHIPX_AirSmallPacket] (
    [WeightInPounds] FLOAT (53) NULL,
    [Zone1]          MONEY      NULL,
    [Zone2]          MONEY      NULL,
    [Zone3]          MONEY      NULL,
    [Zone4]          MONEY      NULL,
    [Zone5]          MONEY      NULL,
    [Zone6]          MONEY      NULL,
    [Zone7]          MONEY      NULL,
    [Zone8]          MONEY      NULL,
    [Zone9]          MONEY      NULL,
    [counter]        INT        NOT NULL,
    CONSTRAINT [PK_webSHIPX_AirSmallPacket] PRIMARY KEY CLUSTERED ([counter] ASC)
);

