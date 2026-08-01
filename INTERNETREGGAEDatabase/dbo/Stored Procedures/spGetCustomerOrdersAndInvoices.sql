
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spGetCustomerOrdersAndInvoices]

@CustomerID nvarchar(30)
,@LogInEmail nvarchar(100)
,@Password nvarchar(50)

AS

select
HoldPileNumber
,HoldPilesForWeb.[Date] as HoldPileDate
,InvoicesForWeb.[Date] as InvoiceDate
,HoldPileStatus
,WaybillNumber
,ShipViaCompany
,ShipViaService
,PurchaseTotal+CODCharge-Previous-Discount+Tax+Shipping-PromoDiscount-GiftCardDiscount as CODTotal
,NumberOfBoxes
,ScheduledArrivalDate
,CODCharge
,CODCash
,CODCheck
,InvoiceNumber
,ShippingMethod
,PDFInvoiceFileName
 from HoldPilesForWeb
 left join InvoicesForWeb on holdpilesforweb.InvoiceNumber=InvoicesForWeb.invoice
 where HoldPilesForWeb.[Date] >=GetDate()-365 
 and [HoldPileStatus] <>'ChosePayPal'
 and (HoldPilesForWeb.CustomerID=@CustomerID or (LogInEmail=@LogInEmail and Password=@Password))
 order by HoldPilesForWeb.[Date] desc, HoldPilesForWeb.counter desc
