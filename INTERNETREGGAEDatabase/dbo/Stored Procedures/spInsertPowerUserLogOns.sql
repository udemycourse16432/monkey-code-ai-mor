
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spInsertPowerUserLogOns]

 @DateTime datetime
,@IPAddress nvarchar(50)
,@Password nvarchar(50)
,@PowerUserName nvarchar(50)

AS

insert PowerUserLogOns
(DateTime
,IPAddress
,Password
,PowerUserName)

values

(@DateTime
,@IPAddress
,@Password
,@PowerUserName)

