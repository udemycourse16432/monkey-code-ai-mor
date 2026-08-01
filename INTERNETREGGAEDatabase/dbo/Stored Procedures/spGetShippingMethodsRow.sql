-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE spGetShippingMethodsRow

@ShippingMethodCode nvarchar(50)

AS

select * from WebSHIPX_ShippingMethods
where ShippingMethodCode=@ShippingMethodCode