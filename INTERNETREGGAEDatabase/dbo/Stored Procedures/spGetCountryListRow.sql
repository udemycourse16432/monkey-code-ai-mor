





create PROCEDURE [dbo].[spGetCountryListRow]

@CountryText nvarchar(100)

AS

BEGIN

select * from CountryList
where CountryText=@CountryText


END





