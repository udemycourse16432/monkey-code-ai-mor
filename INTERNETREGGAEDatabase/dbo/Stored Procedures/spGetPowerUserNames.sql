
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].spGetPowerUserNames

AS

select PowerUserName from Customers where PowerUserName is not null order by PowerUserName


