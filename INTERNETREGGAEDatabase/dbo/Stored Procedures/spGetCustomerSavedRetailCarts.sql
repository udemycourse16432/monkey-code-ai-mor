

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spGetCustomerSavedRetailCarts]

 @Email nvarchar(100)


AS

select Email, CartPassword, sum(Quantity) as SumOfQuantity, max(DateTime) as MaxOfDateTime from WebSavedRetailCarts
where email =@Email
group by Email, CartPassword
order by max(DateTime) desc
