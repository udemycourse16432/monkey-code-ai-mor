

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].spGetPowerUserRow

 @PowerUserName nvarchar(10)

AS

select * from Customers where [PowerUserName] =@PowerUserName