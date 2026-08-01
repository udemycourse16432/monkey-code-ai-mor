





create PROCEDURE [dbo].[spDownloadOK_CustomerEmailChanges]

@counter nvarchar(10)

AS

update CustomerEmailChanges set DownloadGroup=100000 where counter=@counter




