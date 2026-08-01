





-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spInsertCustomerCartsNotifications]

 
 @CustomerServerCounter int
,@EmailDate datetime

AS

update Customers
set
NumberofCartReminderEmailsSent=isnull(Customers.NumberofCartReminderEmailsSent,0)+1,
DateOfLastCartReminderEmailSent=@EmailDate
where counter=@CustomerServerCounter


