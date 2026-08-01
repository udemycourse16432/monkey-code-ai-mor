-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE spGetAirParcelPostZone

@Country nvarchar(100)

AS

select * from WebCountryShippingZonesT
where country=@Country