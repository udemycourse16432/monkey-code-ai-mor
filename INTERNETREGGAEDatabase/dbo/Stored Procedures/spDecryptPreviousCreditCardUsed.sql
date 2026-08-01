







CREATE PROCEDURE [dbo].[spDecryptPreviousCreditCardUsed] 

 @counter int
,@EncryptionKey varchar(25)

AS

select convert(varchar(200),decryptbypassphrase(@EncryptionKey,Account)) as CCNumber
,convert(nvarchar(6),decryptbypassphrase(@EncryptionKey,CVV2)) as CVV2
,ExpirationDate as ExpDate
from CreditCards
where counter=@counter





