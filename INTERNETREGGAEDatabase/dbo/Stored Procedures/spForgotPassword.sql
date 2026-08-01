

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spForgotPassword] 
@LogInEmail nvarchar(100)

AS
BEGIN
select Fullname,Email,LogInEmail,Password,counter from Customers
where LogInEmail=@LogInEmail

END


