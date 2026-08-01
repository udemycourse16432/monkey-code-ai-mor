

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].spInsertCustomerInteraction

 @JavascriptRandomNumber int
,@EBRep nvarchar(50)
,@CustomerRep nvarchar(75)
,@Notes text
,@CustomerID int
,@CustomerTableName nvarchar(20)
,@CustomerServerCounter int


AS

if not exists (select counter from CustomerInteraction
where JavascriptRandomNumber=@JavascriptRandomNumber)

BEGIN
INSERT into CustomerInteraction
(JavascriptRandomNumber
,[DateTime]
,EBRep
,CustomerRep
,Notes
,CustomerID
,CustomerTableName
,CustomerServerCounter)

VALUES

(@JavascriptRandomNumber
,getdate()
,@EBRep
,@CustomerRep
,@Notes
,@CustomerID
,@CustomerTableName
,@CustomerServerCounter)
END