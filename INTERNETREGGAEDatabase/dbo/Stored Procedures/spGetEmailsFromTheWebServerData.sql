-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE spGetEmailsFromTheWebServerData

@ID int

AS

select * from EmailsFromTheWebServer
where ID=13