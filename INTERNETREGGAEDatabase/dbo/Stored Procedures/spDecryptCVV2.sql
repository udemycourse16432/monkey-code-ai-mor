

CREATE PROCEDURE [dbo].[spDecryptCVV2] 

 @WebOrderNumber varchar(15)
,@EncryptionKey varchar(25)

AS

declare @Text varbinary(max)
declare @ReturnValue varchar(200)

set @Text=(select request_CVV2 from PayFlowRequests
where WebOrderNumber = @WebOrderNumber)

if @Text is null
 select null as ReturnValue

else
 begin 
  set @ReturnValue = (convert(nvarchar(200),decryptbypassphrase(@EncryptionKey,@Text)))
  select @ReturnValue as ReturnValue
 end