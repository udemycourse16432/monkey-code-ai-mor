



create PROCEDURE [dbo].[spGetPendingCustomerOrders]
 @CustomerServerCounter int

AS

select * from Orders
where CustomerServerCounter=@CustomerServerCounter
and Status='ordered'
and InvoiceNumber is null
order by DateTime desc
