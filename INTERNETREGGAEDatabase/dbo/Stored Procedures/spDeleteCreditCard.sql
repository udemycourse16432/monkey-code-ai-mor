






-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spDeleteCreditCard]

 @RightFour nvarchar(4)
,@CustomerServerCounter int

AS

BEGIN

update PayFlowRequests
set RightFour='xxxx'
from PayFlowRequests inner join Orders on PayFlowRequests.WebOrderNumber=Orders.OrderNumber
where Orders.CustomerServerCounter=@CustomerServerCounter
and RightFour=@RightFour

update CreditCards
set RightFour='xxxx'
where CustomerServerCounter=@CustomerServerCounter
and RightFour=@RightFour

END







