


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].spCheckReturnCreditCardCustomer

@CustomerServerCounter int

AS

select * from orders
where (OrderProcessChoice='shipcreditcard' or OrderProcessChoice='201')
and [CustomerServerCounter]=@CustomerServerCounter

