



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spChangeLogInCrdentials]

 @LogInEmail nvarchar(100)
,@Password nvarchar(50)
,@Counter int

AS

update Customers
set LogInEmail=@LogInEmail
,Password=@Password
where counter=@Counter



