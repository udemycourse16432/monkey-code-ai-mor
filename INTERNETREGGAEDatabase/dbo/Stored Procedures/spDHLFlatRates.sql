





CREATE PROCEDURE [dbo].[spDHLFlatRates]

AS

BEGIN

select CountryText,WebCountryShippingZonesT.Country as Country,SortOrderText,DHLFlatRate,counter from CountryList
inner join WebCountryShippingZonesT on CountryList.country=WebCountryShippingZonesT.Country
where DHLFlatRate>0 and WebCountryShippingZonesT.Country<>'USA'
order by SortOrderText


END




