
CREATE PROCEDURE [dbo].[MostRecentDateBoughtItem]
 @CustomerID int,
 @ItemID int
AS
BEGIN
 select max(Date)
 from InvoiceItemsForWeb
 inner join invoicesforweb on InvoiceItemsForWeb.inv=invoicesforweb.invoice
 where itemid=@ItemID
 and CustomerID=@CustomerID
END
