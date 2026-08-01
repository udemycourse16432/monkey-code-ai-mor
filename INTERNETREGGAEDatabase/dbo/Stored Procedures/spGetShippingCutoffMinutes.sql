
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spGetShippingCutoffMinutes]

 @ShippingMethodCode nvarchar(50)

AS

select WebShippingCutoffMinutes from WebSHIPX_ShippingMethods
where ShippingMethodCode = @ShippingMethodCode


