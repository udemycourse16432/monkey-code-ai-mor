
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].spHTTPUpdates_HoldPiles

 @HoldPileNumber nvarchar(20)
,@QuasiHold nvarchar(3)
,@HoldPileStatus nvarchar(30)
,@InvoiceNumber int
,@CustomerID nvarchar(30)
,@CreditCardNumberAttempted nvarchar(30)
,@CreditCardAmountAttempted numeric(18, 2)
,@CreditCardExpirationDateAttempted nvarchar(6)
,@CreditCardDateAttempted datetime
,@StatusNotes nvarchar(255)
,@date datetime
,@PONumber nvarchar(100)
,@WebOrderNumber nvarchar(20)
,@DownloadGroup int
,@TagShippingMethod nvarchar(20)
,@NonWebOrderNumber nvarchar(20)

AS

IF EXISTS (Select HoldPileNumber from HoldPilesForWeb WHERE HoldPileNumber=@HoldPileNumber)

 BEGIN
  UPDATE HoldPilesForWeb SET
     QuasiHold=@QuasiHold
    ,HoldPileStatus=@HoldPileStatus
    ,InvoiceNumber=@InvoiceNumber
    ,CustomerID=@CustomerID
    ,CreditCardNumberAttempted=@CreditCardNumberAttempted
    ,CreditCardAmountAttempted=@CreditCardAmountAttempted
    ,CreditCardExpirationDateAttempted=@CreditCardExpirationDateAttempted
    ,CreditCardDateAttempted=@CreditCardDateAttempted
    ,StatusNotes=@StatusNotes
    WHERE HoldPileNumber=@HoldPileNumber
 END

ELSE

 BEGIN
  INSERT INTO HoldPilesForWeb
   (CustomerID
   ,[Date]
   ,PONumber
   ,WebOrderNumber
   ,DownloadGroup
   ,QuasiHold
   ,TagShippingMethod
   ,HoldPileNumber
   ,NonWebOrderNumber
   ,HoldPileStatus
   ,InvoiceNumber
   ,CreditCardNumberAttempted
   ,CreditCardAmountAttempted
   ,CreditCardExpirationDateAttempted
   ,CreditCardDateAttempted
   ,StatusNotes)
  VALUES
   (@CustomerID
   ,@Date
   ,@PONumber
   ,@WebOrderNumber
   ,@DownloadGroup
   ,@QuasiHold
   ,@TagShippingMethod
   ,@HoldPileNumber
   ,@NonWebOrderNumber
   ,@HoldPileStatus
   ,@InvoiceNumber
   ,@CreditCardNumberAttempted
   ,@CreditCardAmountAttempted
   ,@CreditCardExpirationDateAttempted
   ,@CreditCardDateAttempted
   ,@StatusNotes)
 END
