





CREATE PROCEDURE [dbo].[spDownloadOK_Carts_Deletes]

@counter nvarchar(10)

AS

update Carts_Deletes set InSync='y' where counter=@counter



