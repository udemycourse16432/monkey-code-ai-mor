
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spGetCustomerInteractionForCustomer]

@CustomerServerCounter int

AS

select * from CustomerInteraction
where CustomerServerCounter = @CustomerServerCounter
order by DateTime desc
