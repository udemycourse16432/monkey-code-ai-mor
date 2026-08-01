


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spSync_EmailsFromTheWebServer_Deletes]

@counter int

AS

delete EmailsFromTheWebServer where ID=@counter


