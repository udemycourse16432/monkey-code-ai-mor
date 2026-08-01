-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE spGetCustomerPasswordInfo

@Email nvarchar(100)

AS

select Email,LogInEmail,Password,FullName,counter
,datename(month,DateTime) as sqlMonth
,datename(day,DateTime) as sqlDay
,datename(year,DateTime) as sqlYear
from Customers where Email=@Email