







create PROCEDURE [dbo].[spDownloadOK_SignInLog]

 @Counter nvarchar(10)

AS

update SignInLog set
 Insync='y'
where counter=@counter







