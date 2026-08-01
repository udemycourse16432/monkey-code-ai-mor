

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spUpdateInvoiceNumberField]

 @OrderNumber nvarchar(15)
,@InvoiceNumber int

AS

update Orders
set InvoiceNumber=@InvoiceNumber
where OrderNumber=@OrderNumber

