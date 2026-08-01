
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].spGetSuperPowerUserNames

AS

select SuperPowerUserName from Customers where SuperPowerUserName is not null order by SuperPowerUserName


