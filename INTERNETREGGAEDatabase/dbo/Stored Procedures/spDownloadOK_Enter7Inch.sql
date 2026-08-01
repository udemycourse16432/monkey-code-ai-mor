








create PROCEDURE [dbo].[spDownloadOK_Enter7Inch]

@counter nvarchar(10)

AS

update Enter7Inch set Status='downloaded' where counter=@counter






