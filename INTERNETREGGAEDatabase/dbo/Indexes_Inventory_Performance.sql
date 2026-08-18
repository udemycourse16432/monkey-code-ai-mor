-- Indexes_Inventory_Performance.sql
-- ---------------------------------------------------------------------------
-- Fixes "Execution Timeout Expired" errors raised by the home page (and other
-- "top N" Inventory queries that ORDER BY SalesLast30Days / InStockDate /
-- BackInStockDate with a WHERE on Format / ShowOnWebsite / Deleted / Inventory).
--
-- The pre-existing IX_OPT1 / IX_OPT2 indexes key on (Format, UsedItem,
-- ShowOnWebsite, ID, Inventory) and therefore do not help the ORDER BY clauses:
-- SQL Server had to sort the entire matching format partition (hundreds of
-- thousands of rows on a multi-million-row table) for each of the 13 home page
-- sections, which exceeded the 30s command timeout.
--
-- These covering indexes place the sort columns as trailing key columns, so SQL
-- Server can scan the index in the requested order and stop after TOP N without
-- sorting. UsedItem and Inventory are available in the index (key or INCLUDE) so
-- the remaining predicates can be evaluated without row lookups.
--
-- How to apply (run against the INTERNETREGGAE database):
--   sqlcmd -S <server> -d INTERNETREGGAE -i Indexes_Inventory_Performance.sql
--
-- The script is idempotent and safe to re-run. After creating the new indexes
-- you may also drop the redundant IX_OPT1 / IX_OPT2 indexes to reclaim space:
--   DROP INDEX [IX_OPT1] ON [dbo].[Inventory];
--   DROP INDEX [IX_OPT2] ON [dbo].[Inventory];
-- ---------------------------------------------------------------------------

SET NOCOUNT ON;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Inventory]') AND name = N'IX_OPT_BestSellers')
BEGIN
    CREATE NONCLUSTERED INDEX [IX_OPT_BestSellers]
        ON [dbo].[Inventory]([Format] ASC, [ShowOnWebsite] ASC, [Deleted] ASC, [SalesLast30Days] DESC, [Inventory] DESC, [ID] DESC)
        INCLUDE([UsedItem]);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Inventory]') AND name = N'IX_OPT_NewReleases')
BEGIN
    CREATE NONCLUSTERED INDEX [IX_OPT_NewReleases]
        ON [dbo].[Inventory]([Format] ASC, [ShowOnWebsite] ASC, [Deleted] ASC, [InStockDate] DESC, [ID] DESC)
        INCLUDE([UsedItem], [Inventory]);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Inventory]') AND name = N'IX_OPT_BackInStock')
BEGIN
    CREATE NONCLUSTERED INDEX [IX_OPT_BackInStock]
        ON [dbo].[Inventory]([Format] ASC, [ShowOnWebsite] ASC, [Deleted] ASC, [BackInStockDate] DESC, [ID] DESC)
        INCLUDE([UsedItem], [Inventory]);
END
GO
