




CREATE PROCEDURE [dbo].[spDecryptionTest] 

@EncryptionKey varchar(50)
,@counter int

AS

declare @Text varbinary(max)
declare @ReturnValue varchar(200)

set @Text=(select request_ACCT from PayFlowRequests
where counter =@counter)

set @ReturnValue = (convert(varchar(200),decryptbypassphrase(@EncryptionKey,@Text)))

select @ReturnValue as ReturnValue
