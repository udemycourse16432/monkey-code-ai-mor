






-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spSync_InvoicesUpload]

 @counter int
,@CustID int
,@InvoiceDate datetime
,@InvoiceNumber int
,@ShipDate datetime
,@TrackingNumber nvarchar(max)
,@ShippingCompany nvarchar(40)
,@ShippingServiceName nvarchar(50)
,@InvoiceTotal decimal(8,2)
,@WebOrderNumbers nvarchar(max)
,@CustomerServerCounter int
,@PDFFileName nvarchar(55)

AS

if exists (select counter from InvoicesUpload where counter=@counter)
 begin
  update InvoicesUpload set
    CustID=@CustID
   ,InvoiceDate=@InvoiceDate
   ,InvoiceNumber=@InvoiceNumber
   ,ShipDate=@ShipDate
   ,TrackingNumber=@TrackingNumber
   ,ShippingCompany=@ShippingCompany
   ,ShippingServiceName=@ShippingServiceName
   ,InvoiceTotal=@InvoiceTotal
   ,WebOrderNumbers=@WebOrderNumbers
   ,CustomerServerCounter=@CustomerServerCounter
   ,PDFFileName=@PDFFileName
  where counter=@counter
 end
else
 begin
  insert into InvoicesUpload
   (CustID
   ,InvoiceDate
   ,InvoiceNumber
   ,ShipDate
   ,TrackingNumber
   ,ShippingCompany
   ,ShippingServiceName
   ,InvoiceTotal
   ,WebOrderNumbers
   ,CustomerServerCounter
   ,PDFFileName
   ,counter)
  values
   (@CustID
   ,@InvoiceDate
   ,@InvoiceNumber
   ,@ShipDate
   ,@TrackingNumber
   ,@ShippingCompany
   ,@ShippingServiceName
   ,@InvoiceTotal
   ,@WebOrderNumbers
   ,@CustomerServerCounter
   ,@PDFFileName
   ,@counter)
 end







