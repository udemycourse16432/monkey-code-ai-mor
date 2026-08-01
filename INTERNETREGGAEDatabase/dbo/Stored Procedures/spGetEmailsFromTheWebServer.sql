-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE spGetEmailsFromTheWebServer

@ID int

AS

select * from EmailsFromTheWebServer where ID=@ID