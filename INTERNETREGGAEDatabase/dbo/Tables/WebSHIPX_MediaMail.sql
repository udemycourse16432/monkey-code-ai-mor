CREATE TABLE [dbo].[WebSHIPX_MediaMail] (
    [counter]        INT      NOT NULL,
    [WeightInPounds] SMALLINT NULL,
    [Zone1]          MONEY    NULL,
    [Zone2]          MONEY    NULL,
    [Zone3]          MONEY    NULL,
    [Zone4]          MONEY    NULL,
    [Zone5]          MONEY    NULL,
    [Zone6]          MONEY    NULL,
    [Zone7]          MONEY    NULL,
    [Zone8]          MONEY    NULL,
    CONSTRAINT [PK_WebSHIPX_MediaMail] PRIMARY KEY CLUSTERED ([counter] ASC)
);

