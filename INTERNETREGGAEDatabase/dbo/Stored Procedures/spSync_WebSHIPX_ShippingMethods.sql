







-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spSync_WebSHIPX_ShippingMethods]

 @counter int
,@ShippingMethodCode nvarchar(50)
,@Domestic nvarchar(1)
,@International nvarchar(1)
,@USPossessions nvarchar(1)
,@PickUpTime datetime
,@ShipViaService nvarchar(50)
,@ShippingViaCompany nvarchar(50)
,@ShippingCostTableName nvarchar(80)
,@POBoxOK nvarchar(1)
,@CODOK nvarchar(1)
,@FuelSurcharge float
,@OurDutyCostPercent float
,@MaxWeightOfShipment int
,@MaxWeightOfBox int
,@ShipmentFlatRateWeight int
,@CODCharge money
,@ResidentialDeliveryCharge money
,@MilitaryAddressOK nvarchar(1)
,@DeliveryDateGuaranteed nvarchar(1)
,@EUCountries nvarchar(1)
,@NumberOfBoxesMatters nvarchar(1)
,@MinimumWeightOfShipment int
,@HolidayColumnName nvarchar(50)
,@SaturdayDeliveryCharge money
,@WebShippingCutoffMinutes int
,@OfficeShippingCutoffMinutes int
,@PullSheetText nvarchar(50)
,@Hawaii nvarchar(1)
,@Alaska nvarchar(1)
,@Description1 nvarchar(max)
,@Description2 nvarchar(max)
,@Description3 nvarchar(max)
,@Description4 nvarchar(max)
,@TrackingWord nvarchar(max)
,@WebsiteTrackingDescription1 nvarchar(max)
,@WebsiteTrackingDescription2 nvarchar(max)
,@WebsiteTrackingDescription3 nvarchar(max)
,@WebsiteTrackingDescription4 nvarchar(max)
,@LPor12InchSurcharge money
,@CustomFlatShippingChargeSpendThreshold money
,@CustomFlatShippingCharge money
,@FedExAPIServiceEnumeration nvarchar(50)

AS

if exists (select counter from WebSHIPX_ShippingMethods where counter=@counter)
 begin
  update WebSHIPX_ShippingMethods set
   ShippingMethodCode=@ShippingMethodCode
  ,Domestic=@Domestic
  ,International=@International
  ,USPossessions=@USPossessions
  ,PickUpTime=@PickUpTime
  ,ShipViaService=@ShipViaService
  ,ShippingViaCompany=@ShippingViaCompany
  ,ShippingCostTableName=@ShippingCostTableName
  ,POBoxOK=@POBoxOK
  ,CODOK=@CODOK
  ,FuelSurcharge=@FuelSurcharge
  ,OurDutyCostPercent=@OurDutyCostPercent
  ,MaxWeightOfShipment=@MaxWeightOfShipment
  ,MaxWeightOfBox=@MaxWeightOfBox
  ,ShipmentFlatRateWeight=@ShipmentFlatRateWeight
  ,CODCharge=@CODCharge
  ,ResidentialDeliveryCharge=@ResidentialDeliveryCharge
  ,MilitaryAddressOK=@MilitaryAddressOK
  ,DeliveryDateGuaranteed=@DeliveryDateGuaranteed
  ,EUCountries=@EUCountries
  ,NumberOfBoxesMatters=@NumberOfBoxesMatters
  ,MinimumWeightOfShipment=@MinimumWeightOfShipment
  ,HolidayColumnName=@HolidayColumnName
  ,SaturdayDeliveryCharge=@SaturdayDeliveryCharge
  ,WebShippingCutoffMinutes=@WebShippingCutoffMinutes
  ,OfficeShippingCutoffMinutes=@OfficeShippingCutoffMinutes
  ,PullSheetText=@PullSheetText
  ,Hawaii=@Hawaii
  ,Alaska=@Alaska
  ,Description1=@Description1
  ,Description2=@Description2
  ,Description3=@Description3
  ,Description4=@Description4
  ,TrackingWord=@TrackingWord
  ,WebsiteTrackingDescription1=@WebsiteTrackingDescription1
  ,WebsiteTrackingDescription2=@WebsiteTrackingDescription2
  ,WebsiteTrackingDescription3=@WebsiteTrackingDescription3
  ,WebsiteTrackingDescription4=@WebsiteTrackingDescription4
  ,LPor12InchSurcharge=@LPor12InchSurcharge
  ,CustomFlatShippingChargeSpendThreshold=@CustomFlatShippingChargeSpendThreshold
  ,CustomFlatShippingCharge=@CustomFlatShippingCharge
  ,FedExAPIServiceEnumeration=@FedExAPIServiceEnumeration
  where counter=@counter
 end
else
 begin
  insert into WebSHIPX_ShippingMethods
  (counter
  ,ShippingMethodCode 
  ,Domestic 
  ,International 
  ,USPossessions 
  ,PickUpTime
  ,ShipViaService 
  ,ShippingViaCompany 
  ,ShippingCostTableName
  ,POBoxOK 
  ,CODOK 
  ,FuelSurcharge 
  ,OurDutyCostPercent 
  ,MaxWeightOfShipment
  ,MaxWeightOfBox
  ,ShipmentFlatRateWeight
  ,CODCharge
  ,ResidentialDeliveryCharge
  ,MilitaryAddressOK 
  ,DeliveryDateGuaranteed 
  ,EUCountries 
  ,NumberOfBoxesMatters 
  ,MinimumWeightOfShipment
  ,HolidayColumnName 
  ,SaturdayDeliveryCharge
  ,WebShippingCutoffMinutes
  ,OfficeShippingCutoffMinutes
  ,PullSheetText 
  ,Hawaii 
  ,Alaska 
  ,Description1 
  ,Description2 
  ,Description3 
  ,Description4 
  ,TrackingWord 
  ,WebsiteTrackingDescription1 
  ,WebsiteTrackingDescription2 
  ,WebsiteTrackingDescription3 
  ,WebsiteTrackingDescription4
  ,LPor12InchSurcharge
  ,CustomFlatShippingChargeSpendThreshold
  ,CustomFlatShippingCharge
  ,FedExAPIServiceEnumeration)
  values
  (@counter
  ,@ShippingMethodCode 
  ,@Domestic 
  ,@International 
  ,@USPossessions 
  ,@PickUpTime
  ,@ShipViaService 
  ,@ShippingViaCompany 
  ,@ShippingCostTableName
  ,@POBoxOK 
  ,@CODOK 
  ,@FuelSurcharge 
  ,@OurDutyCostPercent 
  ,@MaxWeightOfShipment
  ,@MaxWeightOfBox
  ,@ShipmentFlatRateWeight
  ,@CODCharge
  ,@ResidentialDeliveryCharge
  ,@MilitaryAddressOK 
  ,@DeliveryDateGuaranteed 
  ,@EUCountries 
  ,@NumberOfBoxesMatters 
  ,@MinimumWeightOfShipment
  ,@HolidayColumnName 
  ,@SaturdayDeliveryCharge
  ,@WebShippingCutoffMinutes
  ,@OfficeShippingCutoffMinutes
  ,@PullSheetText 
  ,@Hawaii 
  ,@Alaska 
  ,@Description1 
  ,@Description2 
  ,@Description3 
  ,@Description4 
  ,@TrackingWord 
  ,@WebsiteTrackingDescription1 
  ,@WebsiteTrackingDescription2 
  ,@WebsiteTrackingDescription3 
  ,@WebsiteTrackingDescription4
  ,@LPor12InchSurcharge
  ,@CustomFlatShippingChargeSpendThreshold
  ,@CustomFlatShippingCharge
  ,@FedExAPIServiceEnumeration)
 end







