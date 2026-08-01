



create PROCEDURE [dbo].[spGetCustomerInvoices]
 @CustomerServerCounter int

AS

select * from InvoicesUpload
where CustomerServerCounter=@CustomerServerCounter
order by InvoiceDate desc
