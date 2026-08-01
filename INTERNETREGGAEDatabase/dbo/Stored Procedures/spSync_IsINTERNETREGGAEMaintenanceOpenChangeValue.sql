






-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spSync_IsINTERNETREGGAEMaintenanceOpenChangeValue]


AS

declare @a nvarchar(50)
set @a=(select IsINTERNETREGGAEMaintenanceOpen from DatabaseVariables)

if substring(@a,1,8)='IsItOpen' and len(@a)>8
 begin
  update DatabaseVariables
  set IsINTERNETREGGAEMaintenanceOpen='Yes'+right(@a,len(@a)-8)
 end




