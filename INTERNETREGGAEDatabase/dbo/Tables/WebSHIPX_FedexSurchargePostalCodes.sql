CREATE TABLE [dbo].[WebSHIPX_FedexSurchargePostalCodes] (
    [PostalCode] NVARCHAR (5) NOT NULL,
    [counter]    INT          IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_WebSHIPX_FedexSurchargePostalCodes] PRIMARY KEY CLUSTERED ([counter] ASC)
);

