




-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spCheckForCustomerCartNotificationsToSend]


AS

select top 1 * from CustomerCartNotificationsToSend
where DateTimeSent is null
order by counter




