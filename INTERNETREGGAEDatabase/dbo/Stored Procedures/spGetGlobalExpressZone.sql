-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE spGetGlobalExpressZone

@Country nvarchar(100)

AS

select * from WebCountryShippingZonesT
where country=@Country