





-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spCheckForOWEBEmailsToSend]


AS

select top 1 * from orders 
where status='ordered' and (EmailedOWEB is null or EmailedConfirmation='no') 
order by counter desc




