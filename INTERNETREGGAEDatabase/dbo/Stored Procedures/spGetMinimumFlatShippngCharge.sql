
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spGetMinimumFlatShippngCharge]

@ShippingMethodCode nvarchar(50)

AS

select * from WebSHIPX_ShippingMethods
where ShippingMethodCode=@ShippingMethodCode
