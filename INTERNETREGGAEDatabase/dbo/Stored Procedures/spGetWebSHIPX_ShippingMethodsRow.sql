
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].spGetWebSHIPX_ShippingMethodsRow

 @ShippingMethodCode nvarchar(50)

AS

select * from WebSHIPX_ShippingMethods
where ShippingMethodCode=@ShippingMethodCode