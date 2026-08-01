
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spGetWebCountryShippingZonesT]


AS

select * from WebCountryShippingZonesT
order by Country
