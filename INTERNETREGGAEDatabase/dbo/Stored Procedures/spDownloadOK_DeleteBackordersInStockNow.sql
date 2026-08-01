





create PROCEDURE [dbo].[spDownloadOK_DeleteBackordersInStockNow]

@counter nvarchar(10)

AS

update DeleteBackordersInStockNow set DownloadGroup=100000 where counter=@counter




