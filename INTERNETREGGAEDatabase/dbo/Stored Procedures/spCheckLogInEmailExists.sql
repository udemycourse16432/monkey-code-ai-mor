



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spCheckLogInEmailExists]

@LogInEmail nvarchar(100)

AS

select counter,PriceGroup,Password,FullName from Customers
where [LogInEmail]=@LogInEmail



