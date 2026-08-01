





-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spCheckForNWEBEmailsToSend]


AS

select top 1 * from customers 
where EmailedNWEB is null
order by counter desc