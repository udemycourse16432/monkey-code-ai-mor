














CREATE PROCEDURE [dbo].[spDownload_Orders]

AS

select top 1 * from Orders where DownloadGroup is null and Status='ordered'
order by counter












