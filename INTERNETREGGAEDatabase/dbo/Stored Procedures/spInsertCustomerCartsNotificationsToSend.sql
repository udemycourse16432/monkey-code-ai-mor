






-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spInsertCustomerCartsNotificationsToSend]

 
 @CustomerServerCounter int

AS

insert CustomerCartsNotificationsToSend
(CustomerServerCounter)
values
(@CustomerServerCounter)




