CREATE TABLE [dbo].[Carts] (
    [CartName]                   NVARCHAR (60) NOT NULL,
    [DateTime]                   DATETIME      CONSTRAINT [DF_Carts_DateTime] DEFAULT (getdate()) NOT NULL,
    [ItemID]                     INT           NOT NULL,
    [Quantity]                   INT           NOT NULL,
    [Price]                      SMALLMONEY    NOT NULL,
    [counter]                    INT           IDENTITY (1, 1) NOT NULL,
    [IPAddress]                  NVARCHAR (20) NULL,
    [SearchCriteriaStatisticsID] NVARCHAR (50) NULL,
    [OrderNumber]                NVARCHAR (15) NULL,
    [SubtractedInventory]        NVARCHAR (1)  NULL,
    [SaveForLater]               NVARCHAR (1)  NULL,
    [InSync]                     CHAR (1)      CONSTRAINT [DF_Carts_InSync] DEFAULT ('n') NULL,
    CONSTRAINT [PK_Carts] PRIMARY KEY NONCLUSTERED ([counter] ASC),
    CONSTRAINT [CK_SaveForLater] CHECK ([SaveForLater] IS NULL OR [SaveForLater]='y'),
    CONSTRAINT [IX_CartNameItemID] UNIQUE NONCLUSTERED ([CartName] ASC, [ItemID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_CartName]
    ON [dbo].[Carts]([CartName] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_SaveForLater]
    ON [dbo].[Carts]([SaveForLater] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_SubtractedInventory]
    ON [dbo].[Carts]([SubtractedInventory] ASC);


GO

create TRIGGER [dbo].[Carts_UpdateTrigger]
   ON  [dbo].[Carts] 
   for UPDATE
AS 
 Update Carts
  set InSync='n'
 where counter in (select deleted.counter from deleted
  where InSync='y')

GO
CREATE TRIGGER [dbo].[Carts_DeleteTrigger] ON [dbo].[Carts] for DELETE
AS

insert into Carts_Deletes (DeleteCounter)
select counter from deleted where counter in (select deleted.counter from deleted);

IF (select count(*) from deleted)>0
BEGIN

insert into Carts_log (ts, event_name, cart_name, delete_cnt, carts_affected, total_cnt) values (
  CURRENT_TIMESTAMP,
  'del_trigger',
  case
    when (select count(distinct CartName) from deleted)>1 then ''
    else (select top 1 CartName from deleted)
  end,
  (select count(*) from deleted),
  (select count(distinct CartName) from deleted),
  (select count(*) from Carts)
);

insert into Carts_log_lines select SCOPE_IDENTITY(), * from deleted;

END