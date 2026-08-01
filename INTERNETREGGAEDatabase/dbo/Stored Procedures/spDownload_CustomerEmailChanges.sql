












create PROCEDURE [dbo].[spDownload_CustomerEmailChanges]

AS

select top 1 * from CustomerEmailChanges where DownloadGroup is null order by counter










