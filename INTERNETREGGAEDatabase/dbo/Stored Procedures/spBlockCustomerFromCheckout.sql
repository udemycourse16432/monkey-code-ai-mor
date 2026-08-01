
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spBlockCustomerFromCheckout] 

@CustomerServerCounter int

AS

update Customers
set BlockedFromCheckout='y'
where counter=@CustomerServerCounter
