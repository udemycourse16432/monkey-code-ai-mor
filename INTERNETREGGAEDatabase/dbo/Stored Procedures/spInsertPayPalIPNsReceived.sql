


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spInsertPayPalIPNsReceived]

 @ReceiverEmail nvarchar(200)
,@Category nvarchar(50)
,@ReceiverID nvarchar(50)
,@Note nvarchar(255)
,@WebOrderNumber nvarchar(50)
,@DateTime DateTime
,@PaymentGross float
,@PaymentStatus nvarchar(50)
,@PayPalEmail nvarchar(150)
,@PendingReason nvarchar(50)
,@ReasonCode nvarchar(50)
,@PaypalTransactionID nvarchar(50)
,@FirstName nvarchar(70)
,@LastName nvarchar(70)
,@BusinessName nvarchar(130)
,@PayPalID nvarchar(20)
,@ParentPaypalTransactionID nvarchar(50)
,@PaymentCurrency nvarchar(50)
,@PaymentType nvarchar(50)
,@PaymentFee float
,@CustomerID int

AS

insert into PaypalIPNsReceived
(ReceiverEmail
,Category
,ReceiverID
,Note
,WebOrderNumber
,[DateTime]
,PaymentGross
,PaymentStatus
,PayPalEmail
,PendingReason
,ReasonCode
,PaypalTransactionID
,FirstName
,LastName
,BusinessName
,PayPalID
,ParentPaypalTransactionID
,PaymentCurrency
,PaymentType
,PaymentFee
,CustomerID)
values
(@ReceiverEmail
,@Category
,@ReceiverID
,@Note
,@WebOrderNumber
,@DateTime
,@PaymentGross
,@PaymentStatus
,@PayPalEmail
,@PendingReason
,@ReasonCode
,@PaypalTransactionID
,@FirstName
,@LastName
,@BusinessName
,@PayPalID
,@ParentPaypalTransactionID
,@PaymentCurrency
,@PaymentType
,@PaymentFee
,@CustomerID)

