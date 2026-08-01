







-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spInsertCustomer]

 @PriceGroup nvarchar(50)
,@CustomerID nvarchar(50)
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
,@BillingStreetAddress2 nvarchar(50)
,@BillingCity nvarchar(100)
,@BillingStateProvince nvarchar(100)
,@BillingPostalCode nvarchar(25)
,@BillingIsland nvarchar(50)
,@BillingCountry nvarchar(50)
,@Phone nvarchar(30)
,@Phone2 nvarchar(30)
,@Phone3 nvarchar(30)
,@Email nvarchar(100)
,@Email2 nvarchar(100)
,@Email3 nvarchar(100)
,@LogInEmail nvarchar(100)
,@Password nvarchar(50)
,@HowFoundUs nvarchar(50)
,@IPAddress nvarchar(50)
,@ResidentialDelivery nvarchar(1)
,@ChargeSalesTax nvarchar(1)
,@IDOUTPUT int OUTPUT

AS

insert customers
(PriceGroup
,CustomerID
,FullName
,StreetAddress1
,StreetAddress2
,City
,StateProvince
,PostalCode
,Island
,Country
,BillingFullName
,BillingStreetAddress1
,BillingStreetAddress2
,BillingCity
,BillingStateProvince
,BillingPostalCode
,BillingIsland
,BillingCountry
,Phone
,Phone2
,Phone3
,Email
,Email2
,Email3
,LogInEmail
,Password
,HowFoundUs
,IPAddress
,ResidentialDelivery
,ChargeSalesTax
,[DateTime])

values

(@PriceGroup
,@CustomerID
,@FullName
,@StreetAddress1
,@StreetAddress2
,@City
,@StateProvince
,@PostalCode
,@Island
,@Country
,@BillingFullName
,@BillingStreetAddress1
,@BillingStreetAddress2
,@BillingCity
,@BillingStateProvince
,@BillingPostalCode
,@BillingIsland
,@BillingCountry
,@Phone
,@Phone2
,@Phone3
,@Email
,@Email2
,@Email3
,@LogInEmail
,@Password
,@HowFoundUs
,@IPAddress
,@ResidentialDelivery
,@ChargeSalesTax
,getdate())

select @IDOUTPUT = SCOPE_IDENTITY()
select @IDOUTPUT as counter




