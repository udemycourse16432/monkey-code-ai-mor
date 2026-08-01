

CREATE PROCEDURE [dbo].[FigureCountryForPaymentsProRequest]

@Country nvarchar(100)

AS
BEGIN

select FedExCountryCode from WebCountryShippingZonesT
where Country=@Country
END

