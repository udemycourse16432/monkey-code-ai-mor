





create PROCEDURE [dbo].[spDownloadOK_PayPalIPNsReceived]

@counter nvarchar(10)

AS

update PayPalIPNsReceived set DownloadGroup=100000 where counter=@counter




