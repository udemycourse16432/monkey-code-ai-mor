
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].spHTTPUpdates_OrdersTableForWeb

 @CustomerID nvarchar(30)
,@InvoiceNumber int
,@OrderNumber nvarchar(15)

AS

  UPDATE Orders SET
  CustomerID =@CustomerID
  ,InvoiceNumber =@InvoiceNumber
  WHERE OrderNumber=@OrderNumber
