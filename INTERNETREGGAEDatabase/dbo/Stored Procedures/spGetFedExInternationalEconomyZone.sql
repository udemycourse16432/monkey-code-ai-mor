-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE spGetFedExInternationalEconomyZone

@Country nvarchar(100)

AS

select * from WebCountryShippingZonesT
where country=@Country