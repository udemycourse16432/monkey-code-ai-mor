









-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spSync_InvoicesUpload_Deletes]

@counter int

AS

delete InvoicesUpload where counter=@counter









