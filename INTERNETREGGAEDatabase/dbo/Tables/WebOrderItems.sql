CREATE TABLE [dbo].[WebOrderItems] (
    [InventoryID]                INT            NULL,
    [Price]                      MONEY          NULL,
    [Quantity]                   INT            NULL,
    [OrderNumber]                NVARCHAR (255) NULL,
    [DownLoadGroup]              INT            NULL,
    [counter]                    INT            NULL,
    [Inventory]                  INT            NULL,
    [SearchCriteriaStatisticsID] NVARCHAR (50)  NULL
);

