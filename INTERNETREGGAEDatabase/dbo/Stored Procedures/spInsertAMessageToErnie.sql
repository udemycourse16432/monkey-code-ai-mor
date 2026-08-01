



CREATE PROCEDURE [dbo].[spInsertAMessageToErnie]
 @MessageNumber int
,@EmailMessage text
,@Email nvarchar(50)
,@WholesaleServerCounter int
,@SessionID nvarchar(50)
,@IPAddress nvarchar(50)

AS

BEGIN
 insert into AMessageFromErnieEmails
 (MessageNumber
 ,EmailMessage
 ,Email
 ,WholesaleServerCounter
 ,SessionID
 ,IPAddress)
 Values
 (@MessageNumber
 ,@EmailMessage
 ,@Email
 ,@WholesaleServerCounter
 ,@SessionID
 ,@IPAddress)
END



