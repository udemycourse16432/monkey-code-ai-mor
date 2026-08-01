
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spGetWebSHIPX_UPSGroundCanadaTimeInTransitRow]

@PostalCode nvarchar(5)
AS

select * from WebSHIPX_UPSGroundCanadaTimeInTransit
where PostalCode=@PostalCode
