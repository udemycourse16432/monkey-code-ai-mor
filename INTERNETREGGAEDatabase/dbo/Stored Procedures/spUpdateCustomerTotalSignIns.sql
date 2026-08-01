

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spUpdateCustomerTotalSignIns]

 @counter int

AS

update Customers
set TotalSignIns=TotalSignIns+1
where counter=@counter

