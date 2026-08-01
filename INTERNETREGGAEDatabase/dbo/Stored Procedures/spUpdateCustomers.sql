





-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spUpdateCustomers]

 @Email nvarchar(100)
,@Phone nvarchar(30)
,@ResidentialDelivery nvarchar(1)
,@BlockedFromCheckout nvarchar(1)
,@ChargeSalesTax nvarchar(1)
,@PriceGroup nvarchar(50)
,@FullName nvarchar(120)
,@StreetAddress1 nvarchar(100)
,@StreetAddress2 nvarchar(100)
,@City nvarchar(100)
,@StateProvince nvarchar(100)
,@PostalCode nvarchar(25)
,@Island nvarchar(50)
,@Country nvarchar(50)
,@BillingFullName nvarchar(120)
,@BillingStreetAddress1 nvarchar(100)
,@BillingStreetAddress2 nvarchar(100)
,@BillingCity nvarchar(100)
,@BillingStateProvince nvarchar(100)
,@BillingPostalCode nvarchar(25)
,@BillingIsland nvarchar(50)
,@BillingCountry nvarchar(50)
,@LogInEmail nvarchar(100)
,@Password nvarchar(50)
,@Counter int


AS

UPDATE Customers
SET
 Email=@Email
,Phone=@Phone
,ResidentialDelivery=@ResidentialDelivery
,BlockedFromCheckout=@BlockedFromCheckout
,ChargeSalesTax=@ChargeSalesTax
,PriceGroup=@PriceGroup
,FullName=@FullName
,StreetAddress1=@StreetAddress1
,StreetAddress2=@StreetAddress2
,City=@City
,StateProvince=@StateProvince
,PostalCode=@PostalCode
,Island=@Island
,Country=@Country
,BillingFullName=@BillingFullName
,BillingStreetAddress1=@BillingStreetAddress1
,BillingStreetAddress2=@BillingStreetAddress2
,BillingCity=@BillingCity
,BillingStateProvince=@BillingStateProvince
,BillingPostalCode=@BillingPostalCode
,BillingIsland=@BillingIsland
,BillingCountry=@BillingCountry
,LogInEmail=@LogInEmail
,Password=@Password
WHERE counter=@Counter


