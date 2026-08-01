-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PowerUserIPVerify] 
@IPAddress nvarchar(20)

AS
BEGIN
select top 1 ipaddress from poweruserlogons
where ipaddress=@IPAddress

END
