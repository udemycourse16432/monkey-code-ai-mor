


CREATE PROCEDURE spCheckForPendingPaypalIPNTransaction

 @PaypalTransactionID nvarchar(50)

AS

select * from PaypalIPNsReceived" _
 & " where PaypalTransactionID =@PaypalTransactionID and upper(PaymentStatus)='PENDING'

