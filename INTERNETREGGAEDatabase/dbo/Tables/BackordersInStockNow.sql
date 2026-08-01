CREATE TABLE [dbo].[BackordersInStockNow] (
    [counter]              INT           NULL,
    [CustomerID]           INT           NULL,
    [BackorderInventoryID] INT           NULL,
    [BackorderQuantity]    INT           NULL,
    [DateOrdered]          SMALLDATETIME NULL,
    [PONumber]             NVARCHAR (50) NULL
);

