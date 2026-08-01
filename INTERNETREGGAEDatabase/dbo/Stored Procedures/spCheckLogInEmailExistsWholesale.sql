



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spCheckLogInEmailExistsWholesale]

@LogInEmail nvarchar(100)

AS

select counter from Customers
where [LogInEmail]=@LogInEmail
and PriceGroup<>'RetailPrice'



