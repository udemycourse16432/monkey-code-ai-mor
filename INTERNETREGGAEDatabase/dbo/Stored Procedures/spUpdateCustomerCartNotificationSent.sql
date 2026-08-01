


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spUpdateCustomerCartNotificationSent]

 @counter int

AS

update CustomerCartNotificationsToSend
set DateTimeSent=getdate()
where counter = @counter





