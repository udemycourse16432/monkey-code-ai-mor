












create PROCEDURE [dbo].[spDownload_DeleteBackordersInStockNow]

AS

select top 1 * from DeleteBackordersInStockNow where DownloadGroup is null order by counter










