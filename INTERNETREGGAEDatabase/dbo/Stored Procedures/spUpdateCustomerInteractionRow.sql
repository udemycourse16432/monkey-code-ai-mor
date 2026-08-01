

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].spUpdateCustomerInteractionRow

 @Counter int
,@JavascriptRandomNumber int
,@EBRep nvarchar(50)
,@CustomerRep nvarchar(75)
,@Notes text
,@CustomerID int
,@CustomerTableName nvarchar(20)


AS

UPDATE CustomerInteraction
SET DateTime=getdate()
,EBRep=@EBRep
,CustomerRep=@CustomerRep
,Notes=@Notes
,CustomerID=@CustomerID
,CustomerTableName=@CustomerTableName
WHERE counter=@Counter and JavascriptRandomNumber=@JavascriptRandomNumber