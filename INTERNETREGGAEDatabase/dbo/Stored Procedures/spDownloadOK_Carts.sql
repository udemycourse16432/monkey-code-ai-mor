





CREATE PROCEDURE [dbo].[spDownloadOK_Carts]

@counter nvarchar(10)

AS

update Carts set InSync='y' where counter=@counter



