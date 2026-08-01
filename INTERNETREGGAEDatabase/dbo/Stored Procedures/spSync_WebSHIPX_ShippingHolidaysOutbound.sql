







-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spSync_WebSHIPX_ShippingHolidaysOutbound]

 @counter int
,@Date datetime
,@FedexAirHoliday nvarchar(1)
,@FedexGroundHoliday nvarchar(1)
,@USPSHoliday nvarchar(1)
,@WorkHoliday nvarchar(1)
,@UPSGroundHoliday nvarchar(1)

AS

if exists (select counter from WebSHIPX_ShippingHolidaysOutbound where counter=@counter)
 begin
  update WebSHIPX_ShippingHolidaysOutbound set
   [Date]=@Date
  ,FedexAirHoliday=@FedexAirHoliday
  ,FedexGroundHoliday=@FedexGroundHoliday
  ,USPSHoliday=@USPSHoliday
  ,WorkHoliday=@WorkHoliday
  ,UPSGroundHoliday=@UPSGroundHoliday
  where counter=@counter
 end
else
 begin
  insert into WebSHIPX_ShippingHolidaysOutbound
   (counter
   ,[Date] 
   ,FedexAirHoliday
   ,FedexGroundHoliday 
   ,USPSHoliday
   ,WorkHoliday
   ,UPSGroundHoliday)
  values
   (@Counter
   ,@Date 
   ,@FedexAirHoliday
   ,@FedexGroundHoliday 
   ,@USPSHoliday
   ,@WorkHoliday
   ,@UPSGroundHoliday)
 end








