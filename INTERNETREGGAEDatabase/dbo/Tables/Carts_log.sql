CREATE TABLE [dbo].[Carts_log] (
    [log_id]         INT           IDENTITY (1, 1) NOT NULL,
    [ts]             DATETIME      NULL,
    [event_name]     VARCHAR (32)  NULL,
    [cart_name]      NVARCHAR (60) NULL,
    [delete_cnt]     INT           NULL,
    [carts_affected] INT           NULL,
    [total_cnt]      INT           NULL,
    CONSTRAINT [PK__Carts_lo__9E2397E0EDCF0C1F] PRIMARY KEY CLUSTERED ([log_id] ASC)
);

