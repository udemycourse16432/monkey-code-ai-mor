


create PROCEDURE [dbo].[spUSPSNotShippingTo]
@Country nvarchar(50)

AS

select * from WebSHIPX_USPSNotShippingTo
where country=@Country