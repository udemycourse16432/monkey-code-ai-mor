CREATE TABLE [dbo].[Carts_log_lines] (
    [log_id]                     INT           NULL,
    [CartName]                   NVARCHAR (60) NOT NULL,
    [DateTime]                   DATETIME      NOT NULL,
    [ItemID]                     INT           NOT NULL,
    [Quantity]                   INT           NOT NULL,
    [Price]                      SMALLMONEY    NOT NULL,
    [counter]                    INT           NOT NULL,
    [IPAddress]                  NVARCHAR (20) NULL,
    [SearchCriteriaStatisticsID] NVARCHAR (50) NULL,
    [OrderNumber]                NVARCHAR (15) NULL,
    [SubtractedInventory]        NVARCHAR (1)  NULL,
    [SaveForLater]               NVARCHAR (1)  NULL,
    [InSync]                     CHAR (1)      NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_log_id_CartName]
    ON [dbo].[Carts_log_lines]([log_id] ASC, [CartName] ASC);

