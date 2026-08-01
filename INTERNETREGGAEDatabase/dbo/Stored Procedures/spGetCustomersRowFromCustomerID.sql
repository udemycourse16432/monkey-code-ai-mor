

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].spGetCustomersRowFromCustomerID

@CustomerID nvarchar(50)

AS

select * from Customers
where CustomerID=@CustomerID

