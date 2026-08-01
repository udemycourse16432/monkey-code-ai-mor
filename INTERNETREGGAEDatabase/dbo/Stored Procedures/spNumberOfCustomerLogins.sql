

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spNumberOfCustomerLogins]

 @CustomerServerCounter int


AS

select count(counter) as Total from SignInLog
where CustomerServerCounter=@CustomerServerCounter
and PowerUserName is null
and LoggedOnSuccessful='yes'

