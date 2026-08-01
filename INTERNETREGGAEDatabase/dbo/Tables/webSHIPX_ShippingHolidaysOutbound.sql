CREATE TABLE [dbo].[webSHIPX_ShippingHolidaysOutbound] (
    [Date]               DATETIME     NULL,
    [FedexAirHoliday]    NVARCHAR (1) NULL,
    [FedexGroundHoliday] NVARCHAR (1) NULL,
    [USPSHoliday]        NVARCHAR (1) NULL,
    [WorkHoliday]        NVARCHAR (1) NULL,
    [UPSGroundHoliday]   NVARCHAR (1) NULL,
    [counter]            INT          NOT NULL,
    CONSTRAINT [PK_webSHIPX_ShippingHolidaysOutbound] PRIMARY KEY CLUSTERED ([counter] ASC)
);

