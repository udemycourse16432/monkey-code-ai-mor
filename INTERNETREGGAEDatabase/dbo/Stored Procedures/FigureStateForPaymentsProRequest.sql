
CREATE PROCEDURE [dbo].[FigureStateForPaymentsProRequest]

(@Country nvarchar(100)
,@State nvarchar(100))

AS
BEGIN

select StateProvinceAbbreviation from WebCountryStateProvincesList
where Country=@Country
and StateProvince=@State
END
