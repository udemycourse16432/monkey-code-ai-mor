




-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spCheckCustomerCartNotificationsSentLately]

AS

select count(*) as Qty from CustomerCartNotificationsToSend
where datediff(minute,DateTimeSent,GetDate())<60




