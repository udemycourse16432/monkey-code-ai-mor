

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spGetCustomerDetailsByServerCounter]

 @counter int

AS

select * from Customers
where counter = @counter
and PowerUserName is null and SuperPowerUserName is null




