
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spCheckForCCFraudDeclines] 

@IPAddress nvarchar(25)

AS

select count(*) as Declines from PayFlowRequests
where Request_CUSTIP=@IPAddress
and datediff(s,[datetime],getdate())<=600
and Response_RESULT<>0
and Response_RESULT is not null
