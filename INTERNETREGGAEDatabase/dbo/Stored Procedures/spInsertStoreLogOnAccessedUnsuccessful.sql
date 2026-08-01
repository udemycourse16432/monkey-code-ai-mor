

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spInsertStoreLogOnAccessedUnsuccessful]

 @DateTime datetime
,@IPAddress nvarchar(50)
,@LoggedOnSuccessful nvarchar(3)
,@Password nvarchar(50)
,@LogInEmail nvarchar(100)
,@PowerUserName nvarchar(50)

AS

insert SignInlog
(DateTime
,IPAddress
,LoggedOnSuccessful
,Password
,LogInEmail
,PowerUserName)

values

(@DateTime
,@IPAddress
,@LoggedOnSuccessful
,@Password
,@LogInEmail
,@PowerUserName)


