
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spGetOrdersByCustomerServerCounter]

 @counter int

AS

select top 1 * from Orders
where CustomerServerCounter=@counter
order by counter desc
