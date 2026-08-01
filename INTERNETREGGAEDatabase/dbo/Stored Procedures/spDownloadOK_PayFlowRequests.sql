






create PROCEDURE [dbo].[spDownloadOK_PayFlowRequests]

@counter nvarchar(10)

AS

update PayFlowRequests set InSync='y' where counter=@counter





