




create PROCEDURE [dbo].spDownloadOK_OrderCorrectionNotes

@counter nvarchar(10)

AS

update OrderCorrectionNotes set DownloadGroup=100000 where counter=@counter



