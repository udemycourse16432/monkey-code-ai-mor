















CREATE PROCEDURE [dbo].[spFedexSurchargePostalCode]
@PostalCode nvarchar(5)
AS

 select PostalCode
 from WebSHIPX_FedexSurchargePostalCodes where PostalCode=@PostalCode













