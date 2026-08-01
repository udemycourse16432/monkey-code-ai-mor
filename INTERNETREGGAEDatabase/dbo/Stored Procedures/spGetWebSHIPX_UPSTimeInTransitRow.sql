
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spGetWebSHIPX_UPSTimeInTransitRow]

@ZipCode nvarchar(5)
AS

select * from WebSHIPX_UPSTimeInTransit
where ZipCode=@ZipCode
