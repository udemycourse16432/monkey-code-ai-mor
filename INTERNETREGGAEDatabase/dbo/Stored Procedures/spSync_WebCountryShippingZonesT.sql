







-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spSync_WebCountryShippingZonesT]

 @ID int
,@Country nvarchar(100)
,@FedExInternationalPriorityZone nvarchar(15)
,@AirParcelPostZone nvarchar(15)
,@AirSmallPacketZone nvarchar(15)
,@ErnieShippingZone nvarchar(5)
,@LetterPostRateGroup nvarchar(50)
,@GlobalExpressZone nvarchar(50)
,@FedExInternationalEconomyZone nvarchar(15)
,@FedexExportRatesThatWeChargeCustomersZone nvarchar(15)
,@EuropeanUnionCountry nvarchar(1)
,@AirSmallPacketWeightLimit int
,@RetailMinimumShippingCharge money
,@RetailPercentShippingCharge float
,@FedExCountryCode nvarchar(2)
,@PostalCodeRequired nvarchar(1)
,@StateProvinceRequired nvarchar(1)
,@StateProvinceWord nvarchar(50)
,@AddressUpperCase nvarchar(1)
,@AddressCityLine1 nvarchar(50)
,@AddressCityLine2 nvarchar(50)
,@CityRequired nvarchar(1)
,@IslandRequired nvarchar(1)
,@IslandWord nvarchar(50)
,@CityWord nvarchar(50)
,@PostalCodeWord nvarchar(50)
,@PostalCodeFormat nvarchar(50)
,@FedExFranceIPDZone nvarchar(50)
,@DutyShippingCostPercent float
,@EconomySurfaceParcelPostZone nvarchar(2)
,@WebUSMailWholesaleAllowed nvarchar(1)
,@FedexPhoneNumber nvarchar(50)
,@AirParcelPostWeightLimit int
,@GlobalExpressWeightLimit int
,@AllowFedexInternationalPriorityForRetail nvarchar(50)
,@AutomaticUSMailInsurance nvarchar(50)
,@DHLFlatRate decimal(8,2)
,@DHLInternationalExpressZone nvarchar(2)
AS

if exists (select ID from WebCountryShippingZonesT where ID=@ID)
 begin
  update WebCountryShippingZonesT set
   Country=@Country
  ,FedExInternationalPriorityZone=@FedExInternationalPriorityZone
  ,AirParcelPostZone=@AirParcelPostZone
  ,AirSmallPacketZone=@AirSmallPacketZone
  ,ErnieShippingZone=@ErnieShippingZone
  ,LetterPostRateGroup=@LetterPostRateGroup
  ,GlobalExpressZone=@GlobalExpressZone
  ,FedExInternationalEconomyZone=@FedExInternationalEconomyZone
  ,FedexExportRatesThatWeChargeCustomersZone=@FedexExportRatesThatWeChargeCustomersZone
  ,EuropeanUnionCountry=@EuropeanUnionCountry
  ,AirSmallPacketWeightLimit=@AirSmallPacketWeightLimit
  ,RetailMinimumShippingCharge=@RetailMinimumShippingCharge
  ,RetailPercentShippingCharge=@RetailPercentShippingCharge
  ,FedExCountryCode=@FedExCountryCode
  ,PostalCodeRequired=@PostalCodeRequired
  ,StateProvinceRequired=@StateProvinceRequired
  ,StateProvinceWord=@StateProvinceWord
  ,AddressUpperCase=@AddressUpperCase
  ,AddressCityLine1=@AddressCityLine1
  ,AddressCityLine2=@AddressCityLine2
  ,CityRequired=@CityRequired
  ,IslandRequired=@IslandRequired
  ,IslandWord=@IslandWord
  ,PostalCodeWord=@PostalCodeWord
  ,PostalCodeFormat=@PostalCodeFormat
  ,FedExFranceIPDZone=@FedExFranceIPDZone
  ,DutyShippingCostPercent=@DutyShippingCostPercent
  ,EconomySurfaceParcelPostZone=@EconomySurfaceParcelPostZone
  ,WebUSMailWholesaleAllowed=@WebUSMailWholesaleAllowed
  ,FedexPhoneNumber=@FedexPhoneNumber
  ,AirParcelPostWeightLimit=@AirParcelPostWeightLimit
  ,GlobalExpressWeightLimit=@GlobalExpressWeightLimit
  ,AllowFedexInternationalPriorityForRetail=@AllowFedexInternationalPriorityForRetail
  ,AutomaticUSMailInsurance=@AutomaticUSMailInsurance
  ,DHLFlatRate=@DHLFlatRate
  ,DHLInternationalExpressZone=@DHLInternationalExpressZone
 where ID=@ID
 end
else
 begin
  insert into WebCountryShippingZonesT
(ID 
,Country 
,FedExInternationalPriorityZone 
,AirParcelPostZone 
,AirSmallPacketZone 
,ErnieShippingZone 
,LetterPostRateGroup 
,GlobalExpressZone 
,FedExInternationalEconomyZone 
,FedexExportRatesThatWeChargeCustomersZone 
,EuropeanUnionCountry 
,AirSmallPacketWeightLimit 
,RetailMinimumShippingCharge 
,RetailPercentShippingCharge 
,FedExCountryCode 
,PostalCodeRequired 
,StateProvinceRequired 
,StateProvinceWord 
,AddressUpperCase 
,AddressCityLine1 
,AddressCityLine2 
,CityRequired 
,IslandRequired 
,IslandWord 
,CityWord 
,PostalCodeWord 
,PostalCodeFormat 
,FedExFranceIPDZone 
,DutyShippingCostPercent 
,EconomySurfaceParcelPostZone 
,WebUSMailWholesaleAllowed 
,FedexPhoneNumber 
,AirParcelPostWeightLimit 
,GlobalExpressWeightLimit 
,AllowFedexInternationalPriorityForRetail 
,AutomaticUSMailInsurance
,DHLFlatRate
,DHLInternationalExpressZone)
  values
(@ID 
,@Country 
,@FedExInternationalPriorityZone 
,@AirParcelPostZone 
,@AirSmallPacketZone 
,@ErnieShippingZone 
,@LetterPostRateGroup 
,@GlobalExpressZone 
,@FedExInternationalEconomyZone 
,@FedexExportRatesThatWeChargeCustomersZone 
,@EuropeanUnionCountry 
,@AirSmallPacketWeightLimit 
,@RetailMinimumShippingCharge 
,@RetailPercentShippingCharge 
,@FedExCountryCode 
,@PostalCodeRequired 
,@StateProvinceRequired 
,@StateProvinceWord 
,@AddressUpperCase 
,@AddressCityLine1 
,@AddressCityLine2 
,@CityRequired 
,@IslandRequired 
,@IslandWord 
,@CityWord 
,@PostalCodeWord 
,@PostalCodeFormat 
,@FedExFranceIPDZone 
,@DutyShippingCostPercent 
,@EconomySurfaceParcelPostZone 
,@WebUSMailWholesaleAllowed 
,@FedexPhoneNumber 
,@AirParcelPostWeightLimit 
,@GlobalExpressWeightLimit 
,@AllowFedexInternationalPriorityForRetail 
,@AutomaticUSMailInsurance
,@DHLFlatRate
,@DHLInternationalExpressZone)

 end







