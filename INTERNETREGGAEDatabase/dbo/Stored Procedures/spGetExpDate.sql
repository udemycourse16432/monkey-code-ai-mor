



CREATE PROCEDURE [dbo].[spGetExpDate] 

 @WebOrderNumber varchar(15)

AS


select Request_EXPDATE,Request_BILLTOFIRSTNAME, Request_BILLTOLASTNAME from PayFlowRequests
where WebOrderNumber = @WebOrderNumber


