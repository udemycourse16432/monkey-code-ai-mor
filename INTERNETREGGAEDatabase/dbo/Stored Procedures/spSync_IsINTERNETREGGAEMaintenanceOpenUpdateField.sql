






-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spSync_IsINTERNETREGGAEMaintenanceOpenUpdateField]

 @RandomNumber nvarchar(50)

AS

update DatabaseVariables

set IsINTERNETREGGAEMaintenanceOpen=@RandomNumber





