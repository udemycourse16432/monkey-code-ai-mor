
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spUpdateCustomerDateOfLastLogin]

 @counter int

AS

update Customers
set DateOfLastLogin=getdate()
where counter=@counter
