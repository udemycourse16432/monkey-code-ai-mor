



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spCheckIfLogInEmailExists]

 @LogInEmail nvarchar(100)
,@Counter int

AS

select counter from Customers
where LogInEmail=@LogInEmail
and counter<>@Counter



