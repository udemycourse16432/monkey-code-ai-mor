

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spMarkOrderPaidByPayPal]

 @PaypalTransactionID nvarchar(50)
,@PayPalAmountPaid numeric(10,2)
,@PayPalEmail nvarchar(100)
,@OrderNumber nvarchar(15)

AS

update orders
set Status='Ordered'
,PaypalPaymentStatus='Completed'
,PaypalTransactionID=@PaypalTransactionID
,PayPalAmountPaid=@PayPalAmountPaid
,PayPalEmail=@PayPalEmail
where OrderNumber=@OrderNumber

update HoldPilesForWeb
set HoldPileStatus='Ordered'
where HoldPileNumber=@OrderNumber
