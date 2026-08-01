







create PROCEDURE [dbo].[spDownloadOK_EnterStock]

@counter nvarchar(10)

AS

update EnterStock set Status='downloaded' where counter=@counter






