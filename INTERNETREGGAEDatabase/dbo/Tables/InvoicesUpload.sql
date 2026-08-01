CREATE TABLE [dbo].[InvoicesUpload] (
    [CustID]                INT            NOT NULL,
    [InvoiceDate]           DATETIME       NOT NULL,
    [InvoiceNumber]         INT            NOT NULL,
    [ShipDate]              DATETIME       NOT NULL,
    [TrackingNumber]        NVARCHAR (MAX) NOT NULL,
    [ShippingCompany]       NVARCHAR (40)  NOT NULL,
    [ShippingServiceName]   NVARCHAR (50)  NOT NULL,
    [InvoiceTotal]          DECIMAL (8, 2) NOT NULL,
    [WebOrderNumbers]       NVARCHAR (MAX) NULL,
    [CustomerServerCounter] INT            NOT NULL,
    [PDFFileName]           NVARCHAR (55)  NULL,
    [counter]               INT            NOT NULL
);

