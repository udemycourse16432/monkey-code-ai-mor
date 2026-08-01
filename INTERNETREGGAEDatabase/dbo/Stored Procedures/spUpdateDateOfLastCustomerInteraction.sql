

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].spUpdateDateOfLastCustomerInteraction

@CustomerServerCounter int


AS

Update Customers set DateOfLastCustomerInteraction=getdate()
where counter=@CustomerServerCounter