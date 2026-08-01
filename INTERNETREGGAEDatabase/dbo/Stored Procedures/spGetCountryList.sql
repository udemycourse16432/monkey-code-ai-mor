




create PROCEDURE [dbo].[spGetCountryList]

AS

BEGIN

select CountryText,Country,SortOrderText,counter from CountryList
order by SortOrderText


END




