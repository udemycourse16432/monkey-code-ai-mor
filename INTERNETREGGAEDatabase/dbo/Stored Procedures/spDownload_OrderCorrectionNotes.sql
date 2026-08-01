











CREATE PROCEDURE [dbo].spDownload_OrderCorrectionNotes

AS

select top 1 * from OrderCorrectionNotes where DownloadGroup is null order by counter









