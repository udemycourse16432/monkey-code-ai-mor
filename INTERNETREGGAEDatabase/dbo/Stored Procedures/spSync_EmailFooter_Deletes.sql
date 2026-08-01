




-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spSync_EmailFooter_Deletes]

@counter int

AS

delete EmailFooter where counter=@counter




