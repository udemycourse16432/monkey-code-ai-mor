-- =============================================
-- Description: Persist PayPal capture/payment details on an Orders row.
-- Called after a successful PayPal capture. spRecordPurchase does not write
-- the PayPal transaction fields, so this keeps the Orders row in sync with
-- the gateway (transaction id, payment status, payer email, amounts).
-- =============================================
CREATE PROCEDURE [dbo].[spUpdatePayPalPaymentInfo]

 @OrderNumber nvarchar(15)
,@PaypalTransactionID nvarchar(50)
,@PayPalPaymentStatus nvarchar(50)
,@PayPalEmail nvarchar(100)
,@PayPalAmountPaid numeric(10,2)
,@PaypalAmountDue numeric(10,2)
,@PayPalPendingReason nvarchar(50)

AS

UPDATE Orders
SET PaypalTransactionID = @PaypalTransactionID
   ,PaypalPaymentStatus = @PayPalPaymentStatus
   ,PayPalEmail = @PayPalEmail
   ,PayPalAmountPaid = @PayPalAmountPaid
   ,PaypalAmountDue = @PaypalAmountDue
   ,PayPalPendingReason = @PayPalPendingReason
WHERE OrderNumber = @OrderNumber
