


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spInsertStoreLogOnAccessedSuccessful]

 @DateTime datetime
,@IPAddress nvarchar(50)
,@LoggedOnSuccessful nvarchar(3)
,@Password nvarchar(50)
,@LogInEmail nvarchar(100)
,@PowerUserName nvarchar(10)
,@CartQuantity int
,@Storename nvarchar(100)
,@PriceGroup nvarchar(50)
,@City nvarchar(100)
,@CustomerServerCounter int

AS

insert SignInlog
(DateTime
,IPAddress
,LoggedOnSuccessful
,Password
,LogInEmail
,PowerUserName
,CartQuantity
,Storename 
,PriceGroup 
,City
,CustomerServerCounter)

values

(@DateTime
,@IPAddress
,@LoggedOnSuccessful
,@Password
,@LogInEmail
,@PowerUserName
,@CartQuantity
,@Storename 
,@PriceGroup 
,@City
,@CustomerServerCounter)


