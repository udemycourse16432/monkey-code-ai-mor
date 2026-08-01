
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spGetWebSHIPX_FedExGroundTimeInTransitRow]

@ZipCode nvarchar(5)
AS

select * from WebSHIPX_FedExGroundTimeInTransit
where ZipCode=@ZipCode
