





create PROCEDURE [dbo].[spDownloadOK_Orders]

@counter nvarchar(10)

AS

update Orders set DownloadGroup=100000 where counter=@counter




