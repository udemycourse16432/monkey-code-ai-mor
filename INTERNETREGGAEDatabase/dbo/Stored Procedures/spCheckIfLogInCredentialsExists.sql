



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spCheckIfLogInCredentialsExists]

 @LogInEmail nvarchar(100)
,@Password nvarchar(50)
,@Counter int

AS

select counter from Customers
where Password=@Password
and LogInEmail=@LogInEmail
and counter<>@Counter



