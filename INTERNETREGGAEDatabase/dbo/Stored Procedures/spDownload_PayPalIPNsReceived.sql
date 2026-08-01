












create PROCEDURE [dbo].[spDownload_PayPalIPNsReceived]

AS

select top 1 * from PayPalIPNsReceived where DownloadGroup is null order by counter










