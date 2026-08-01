


create PROCEDURE [dbo].[spGetCustomerOrders]
 @CustomerServerCounter int

AS

select * from Orders
where CustomerServerCounter=@CustomerServerCounter
and Status='ordered'
order by DateTime desc