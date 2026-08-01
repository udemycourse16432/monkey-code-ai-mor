-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spGetCustomerDetails]

 @LogInEmail nvarchar(100)
,@Password nvarchar(50)

AS

select * from Customers
where [LogInEmail] = @LogInEmail-- and [Password]=@Password


