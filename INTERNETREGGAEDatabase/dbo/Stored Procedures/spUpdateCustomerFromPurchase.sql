

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spUpdateCustomerFromPurchase]

 @Email nvarchar(100)
,@Phone nvarchar(30)
,@FullName nvarchar(300)
,@StreetAddress1 nvarchar(300)
,@StreetAddress2 nvarchar(300)
,@City nvarchar(100)
,@Island nvarchar(50)
,@StateProvince nvarchar(100)
,@PostalCode nvarchar(25)
,@Country nvarchar(100)
,@BillingFullName nvarchar(200)
,@BillingStreetAddress1 nvarchar(100)
,@BillingStreetAddress2 nvarchar(120)
,@BillingCity nvarchar(100)
,@BillingIsland nvarchar(50)
,@BillingStateProvince nvarchar(100)
,@BillingPostalCode nvarchar(25)
,@BillingCountry nvarchar(100)
,@counter int

AS

Update Customers set

 Email=@Email
,Phone=@Phone
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

where counter=@counter


