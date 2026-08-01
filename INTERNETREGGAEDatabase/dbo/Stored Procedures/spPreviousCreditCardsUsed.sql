








-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spPreviousCreditCardsUsed]

 @CustomerServerCounter int

AS

BEGIN

select max(counter) as MaxOfCounter
,RightFour
from CreditCards
where CustomerServerCounter=@CustomerServerCounter
and RightFour<>'xxxx'
group by RightFour
order by max(DateTime) desc

END









