
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].spGetWebSHIPX_ShippingHolidaysOutboundRow

@Date datetime
AS

select * from WebSHIPX_ShippingHolidaysOutbound
where [Date]=@Date
