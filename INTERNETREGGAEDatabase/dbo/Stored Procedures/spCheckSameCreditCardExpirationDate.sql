


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].spCheckSameCreditCardExpirationDate

@CustomerServerCounter int

AS

select * from Orders where CustomerServerCounter=@CustomerServerCounter
and len(ExpDate)=4
order by datetime desc

