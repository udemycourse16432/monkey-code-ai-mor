-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE spGetWebCountryShippingZonesTRow

@Country nvarchar(100)

AS

select * from WebCountryShippingZonesT
where Country=@Country