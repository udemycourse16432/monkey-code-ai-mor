


CREATE PROCEDURE spCheckForUniquePaypalIPNTransaction

 @PaypalTransactionID nvarchar(50)
,@PaymentStatus nvarchar(50)

AS

select * from PaypalIPNsReceived" _
 & " where PaypalTransactionID =@PaypalTransactionID and PaymentStatus=@PaymentStatus

